-- g_CLKS_PER_BIT = (Frequency of i_Clk)/(Frequency of UART)

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity UART_RX is
  generic (
    g_CLKS_PER_BIT : integer := 434     -- Needs to be set correctly
    );
  port (
    i_Clk       : in  std_logic;
    i_RX_Serial : in  std_logic;
    o_RX_DV     : out std_logic;
    o_RX_Byte   : out std_logic_vector(7 downto 0)
    );
end UART_RX;

architecture RTL of UART_RX is

  type StateMachine is (Idle, RX_Start_Bit, RX_Data_Bits,
                     RX_Stop_Bit, Cleanup);
  signal state : StateMachine := Idle;

  signal r_Clk_Count : integer range 0 to g_CLKS_PER_BIT-1 := 0;
  signal r_Bit_Index : integer range 0 to 7 := 0;  -- 8 Bits Total
  signal r_RX_Byte   : std_logic_vector(7 downto 0) := (others => '0');
  signal r_RX_DV     : std_logic := '0';
  
begin

  -- Purpose: Control RX state machine
  p_UART_RX : process (i_Clk)
  begin
    if rising_edge(i_Clk) then
        
      case state is

        when Idle =>
          r_RX_DV     <= '0';
          r_Clk_Count <= 0;
          r_Bit_Index <= 0;

          if i_RX_Serial = '0' then       -- Start bit detected
            state <= RX_Start_Bit;
          else
            state <= Idle;
          end if;

          
        -- Check middle of start bit to make sure it's still low
        when RX_Start_Bit =>
          if r_Clk_Count = (g_CLKS_PER_BIT-1)/2 then
            if i_RX_Serial = '0' then
              r_Clk_Count <= 0;  -- reset counter since we found the middle
              state   <= RX_Data_Bits;
            else
              state   <= Idle;
            end if;
          else
            r_Clk_Count <= r_Clk_Count + 1;
            state   <= RX_Start_Bit;
          end if;

          
        -- Wait g_CLKS_PER_BIT-1 clock cycles to sample serial data
        when RX_Data_Bits =>
          if r_Clk_Count < g_CLKS_PER_BIT-1 then
            r_Clk_Count <= r_Clk_Count + 1;
            state   <= RX_Data_Bits;
          else
            r_Clk_Count            <= 0;
            r_RX_Byte(r_Bit_Index) <= i_RX_Serial;
            
            -- Check if we have sent out all bits
            if r_Bit_Index < 7 then
              r_Bit_Index <= r_Bit_Index + 1;
              state   <= RX_Data_Bits;
            else
              r_Bit_Index <= 0;
              state   <= RX_Stop_Bit;
            end if;
          end if;
        -- Receive Stop bit.  Stop bit = 1
        when RX_Stop_Bit =>
          -- Wait g_CLKS_PER_BIT-1 clock cycles for Stop bit to finish
          if r_Clk_Count < g_CLKS_PER_BIT-1 then
            r_Clk_Count <= r_Clk_Count + 1;
            state   <= RX_Stop_Bit;
          else
            r_RX_DV     <= '1';
            r_Clk_Count <= 0;
            state   <= Cleanup;
          end if;            
        -- Stay here 1 clock
        when Cleanup =>
          state <= Idle;
          r_RX_DV   <= '0';

        when others =>
          state <= Idle;

      end case;
    end if;
  end process p_UART_RX;

  o_RX_DV   <= r_RX_DV;
  o_RX_Byte <= r_RX_Byte;
  
end RTL;