-- g_CLKS_PER_BIT = (Frequency of i_Clk)/(Frequency of UART)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART_TX is
  generic (
    g_CLKS_PER_BIT : integer := 434     -- Needs to be set correctly
    );
  port (
    i_Clk       : in  std_logic;
    i_TX_DV     : in  std_logic;
    i_TX_Byte   : in  std_logic_vector(7 downto 0);
    o_TX_Active : out std_logic;
    o_TX_Serial : out std_logic;
    o_TX_Done   : out std_logic
    );
end UART_TX;


architecture RTL of UART_TX is

  type StateMachine is (IDLE, TX_START_BIT, TX_DATA_BITS,
                     TX_STOP_BIT, CLEANUP);
  signal state : StateMachine := IDLE;

  signal r_Clk_Count : integer range 0 to g_CLKS_PER_BIT-1 := 0;
  signal r_Bit_Index : integer range 0 to 7 := 0;  -- 8 Bits Total
  signal r_TX_Data   : std_logic_vector(7 downto 0) := (others => '0');
  signal r_TX_Done   : std_logic := '0';
  
begin

  
  p_UART_TX : process (i_Clk)
  begin
    if rising_edge(i_Clk) then
        
      r_TX_Done   <= '0';  -- Default assignment

      case state is

        when IDLE =>
          o_TX_Active <= '0';
          o_TX_Serial <= '1';         -- Drive Line High for Idle
          r_Clk_Count <= 0;
          r_Bit_Index <= 0;

          if i_TX_DV = '1' then
            r_TX_Data <= i_TX_Byte;
            state <= TX_START_BIT;
          else
            state <= IDLE;
          end if;

          
        -- Send out Start Bit. Start bit = 0
        when TX_START_BIT =>
          o_TX_Active <= '1';
          o_TX_Serial <= '0';

          -- Wait g_CLKS_PER_BIT-1 clock cycles for start bit to finish
          if r_Clk_Count < g_CLKS_PER_BIT-1 then
            r_Clk_Count <= r_Clk_Count + 1;
            state   <= TX_START_BIT;
          else
            r_Clk_Count <= 0;
            state   <= TX_DATA_BITS;
          end if;

          
        -- Wait g_CLKS_PER_BIT-1 clock cycles for data bits to finish          
        when TX_DATA_BITS =>
          o_TX_Serial <= r_TX_Data(r_Bit_Index);
          
          if r_Clk_Count < g_CLKS_PER_BIT-1 then
            r_Clk_Count <= r_Clk_Count + 1;
            state   <= TX_DATA_BITS;
          else
            r_Clk_Count <= 0;
            
            -- Check if we have sent out all bits
            if r_Bit_Index < 7 then
              r_Bit_Index <= r_Bit_Index + 1;
              state   <= TX_DATA_BITS;
            else
              r_Bit_Index <= 0;
              state   <= TX_STOP_BIT;
            end if;
          end if;


        -- Send out Stop bit.  Stop bit = 1
        when TX_STOP_BIT =>
          o_TX_Serial <= '1';

          -- Wait g_CLKS_PER_BIT-1 clock cycles for Stop bit to finish
          if r_Clk_Count < g_CLKS_PER_BIT-1 then
            r_Clk_Count <= r_Clk_Count + 1;
            state   <= TX_STOP_BIT;
          else
            r_TX_Done   <= '1';
            r_Clk_Count <= 0;
            state   <= CLEANUP;
          end if;

                  
        -- Stay here 1 clock
        when CLEANUP =>
          o_TX_Active <= '0';
          state   <= IDLE;
          
            
        when others =>
          state <= IDLE;

      end case;
    end if;
  end process p_UART_TX;

  o_TX_Done <= r_TX_Done;
  
end RTL;