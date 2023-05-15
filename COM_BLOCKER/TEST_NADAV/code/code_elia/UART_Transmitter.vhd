library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART_Transmitter is
    generic (
        NumOfDataBits : integer := 8
        );
    port (
        i_Clk       : in  std_logic;
        i_TX_Byte   : in  std_logic_vector(NumOfDataBits-1 downto 0);
        i_TX_DV     : in std_logic;
        o_TX_Serial : out std_logic;
        o_TX_Active : out std_logic
    );
end entity UART_Transmitter;

architecture rtl of UART_Transmitter is

type StateMachine is (IDLE, TX_START_BIT, TX_DATA_BITS,
                        TX_STOP_BIT);
signal state : StateMachine ;
signal r_TX_Data   : std_logic_vector(NumOfDataBits-1 downto 0);
signal r_Bit_Index : integer range 0 to NumOfDataBits-1;  -- 8 Bits Total

begin

process(i_Clk)
    begin
    if(rising_edge(i_Clk)) then
        case state is

            when Idle =>
                o_TX_Serial <= '1'; --Idle State
                r_Bit_Index <= 0;

                if i_TX_DV = '1' then
                    r_TX_Data <= i_TX_Byte;
                    state <= TX_START_BIT;
                  else
                    state <= IDLE;
                  end if;
            
            when TX_START_BIT =>
                  o_TX_Serial <='0';
                  state <= TX_DATA_BITS;
            
            when TX_DATA_BITS =>
                o_TX_Serial <= r_TX_Data(r_Bit_Index);
                if r_Bit_Index < NumOfDataBits - 1 then
                    r_Bit_Index <= r_Bit_Index + 1;
                    state   <= TX_DATA_BITS;
                else
                    r_Bit_Index <= 0;
                    state   <= TX_STOP_BIT;
                end if;
            when TX_STOP_BIT =>
                o_TX_Serial <= '1';
                state   <= Idle;

            when others =>
                state <= IDLE;
        end case;

    end if;
end process;
o_TX_Active <='1' when (i_TX_DV = '1' and state = idle) or (state /= TX_STOP_BIT and state/=idle) else
              '0';
               --'0' when state = TX_STOP_BIT or state = idle else
end architecture rtl;