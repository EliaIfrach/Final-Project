library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity UART_Reciver is
    generic (
        NumOfDataBits : integer := 8
        );
    port (
        i_Clk       : in  std_logic;
        i_RX_Serial : in  std_logic;
        o_RX_Byte   : out std_logic_vector(NumOfDataBits-1 downto 0);
        valid_data  : out std_logic
    );
end entity UART_Reciver;

architecture rtl of UART_Reciver is
type StateMachine is (Idle, RX_Start_Bit, RX_Data_Bits,
                      RX_Stop_Bit);
signal state : StateMachine := Idle;

signal r_Bit_Index : integer range 0 to NumOfDataBits-1 := 0;
signal r_RX_Byte   : std_logic_vector(NumOfDataBits-1 downto 0) := (others => '0');
signal r_valid_data : std_logic;

begin

process(i_Clk)
begin
    if falling_edge(i_Clk) then
        case state is

            when Idle =>
              r_Bit_Index <= 0;
              r_valid_data <= '0';
              r_RX_Byte <= (others => '0');
              if i_RX_Serial = '0' then       -- Start bit detected
                state <= RX_Data_Bits;
              else
                state <= Idle;
              end if;

            when RX_Start_Bit =>
              if i_RX_Serial = '0' then
                state   <= RX_Data_Bits;
              else
                state   <= Idle;    
              end if;

            when RX_Data_Bits =>
              r_RX_Byte(r_Bit_Index) <= i_RX_Serial;

              if r_Bit_Index < NumOfDataBits-1 then
                r_Bit_Index <= r_Bit_Index + 1;
                state   <= RX_Data_Bits;
              else
                r_Bit_Index <= 0;
                state   <= RX_Stop_Bit;
              end if;
            
            when RX_Stop_Bit =>
              state   <= Idle;
              r_valid_data <= '1';
            

            when others =>
              state <= IDLE;
            end case;
end if;
end process;
valid_data <= r_valid_data;
o_RX_Byte <= r_RX_Byte;

end architecture rtl;