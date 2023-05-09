library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Data_Mux_v2 is
    port (
        i_clk        : in std_logic;
        i_rst        : in std_logic;
        i_data       : in std_logic_vector(31 downto 0);
        i_TX_Active  : in std_logic;
        o_Uart_Data  : out std_logic_vector(7 downto 0); 
        o_TX_DV      : out std_logic;
        i_RX_Data    : in std_logic_vector(7 downto 0);
        o_save_data  : out std_logic;
        o_index     : out std_logic_vector(10 downto 0)
    );
end entity Data_Mux_v2;

architecture rtl_Data_Mux_v2 of Data_Mux_v2 is
    signal r_data     : std_logic_vector(31 downto 0);
    signal r_count    : integer range 0 to 3;
    signal r_index    : integer range 0 to 2047;
    signal r_flag     : std_logic;
    signal flag     : std_logic;

    type t_State is (rst, idle, save_data, transmit);
    signal state : t_State;

begin
process(i_clk, i_rst)
    begin
        if i_rst = '0' then
            state <= rst;
        elsif rising_edge(i_clk) then

            case state is
                when rst =>
                    r_data <= (others => '0');
                    r_count <= 0;
                    r_index <= 0;
                    o_TX_DV <= '0';
                    state <= idle;
                    o_save_data <= '0';

                when idle =>
                    o_TX_DV <= '0'; --?????
                    if (i_RX_Data = "00000001" OR r_flag = '1') then
                        r_flag <= '1';
                        o_index <= std_logic_vector(to_unsigned(r_index, 11)); --Adress to ram
                        state <= save_data;
                    else
                        state <= idle;
                    end if;

                    if (r_index = 127) then --sends the first 128 bytes          
                        o_save_data <= '1';
                        r_flag <= '0';
                        r_index <= 0;     
                    else                              
                        o_save_data <= '0';           
                    end if;                 

                when save_data =>
                    r_data <= i_data;
                    state <= transmit;
                    
                    
                when transmit =>
                    if(r_count < 3) then
                        if(i_TX_Active = '0') then
                            o_Uart_Data <= r_data(8*(r_count+1)-1 downto r_count * 8);  --FROM LSB to MSB - 8 bits
                            --o_Uart_Data <= r_data((32-r_count*8)-1 downto 24-(8*r_count)); --FROM MSB to LSB
                            o_TX_DV <= '1'; --Set date Byte to be valid
                            r_count <= r_count + 1;
                        else 
                            o_TX_DV <= '0';
                        end if;
                    else
                        if(i_TX_Active = '0') then
                            o_Uart_Data <= r_data(8*(r_count+1)-1 downto r_count * 8);  --FROM LSB to MSB - 8 bits
                            --o_Uart_Data <= r_data((32-r_count*8)-1 downto 24-(8*r_count)); --FROM MSB to LSB
                            o_TX_DV <= '1'; --Set date Byte to be valid
                            r_count <= 0;
                            state <= idle;
                            r_index <= r_index + 1;
                        else
                            o_TX_DV <= '0';
                        end if;
                    end if;
            end case;
        end if;    
    end process;
end architecture rtl_Data_Mux_v2;


















