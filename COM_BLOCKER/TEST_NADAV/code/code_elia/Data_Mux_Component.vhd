library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Data_Mux_Component is
    port(
        i_clk       : in std_logic;
        i_rst       : in std_logic;
        i_TX_Active : in std_logic;
        i_Data      : in std_logic_vector(31 downto 0);
        i_RX_Data   : in std_logic_vector(7 downto 0);
        o_Uart_Data : out std_logic_vector(7 downto 0);
        o_Ram_Index : out std_logic_vector(10 downto 0);
        o_TX_DV     : out std_logic;
        o_save_data : out std_logic
    );
end entity Data_Mux_Component;

architecture rtl of Data_Mux_Component is
    type t_state is (s_rst, s_idle, s_index, s_save, s_transmit);
        signal state : t_state;
    signal r_Ram_index      : integer range 0 to 2047; --There is 2048 Adresses in Ram
    signal r_Ram_Data       : std_logic_vector(31 downto 0); --Data Holder
    signal r_Data_index     : integer range 0 to 4;
    signal r_flag_data      : std_logic;
    signal r_Data_Divider   : integer range 0 to 16;
begin
    process(i_rst, i_clk)
        begin
            if (i_rst = '0') then
                state <= s_rst;

            elsif (rising_edge(i_clk)) then

                case state is

                    when s_rst =>
                        o_save_data <= '0';
                        o_TX_DV <= '0';
                        o_Uart_Data <= (others => '0');
                        r_Ram_index <= 0;
                        state <= s_idle;

                    when s_idle =>
                        --When data from MATLAB is 1:
                        if (i_RX_Data = "00000001") then
                            state <= s_save;
                            r_Ram_index <= 0;
                            --r_Data_Divider <= 0;
                            r_Data_Divider <= 1; --Will be ready to next stage
                            o_Ram_Index <= std_logic_vector(to_unsigned(0,11));
                            r_Data_index <= 0;

                        --When data from MATLAB is 2:
                        elsif(i_RX_Data = "00000010") then
                            state <= s_save;
                            --o_Ram_Index <= std_logic_vector(to_unsigned(128*r_Data_Divider,11)); --Not mult
                            --o_Ram_Index <= std_logic_vector(to_unsigned(r_Ram_index,11));
                            r_Ram_index <= 128 * (r_Data_Divider-1);
                            o_Ram_Index <= std_logic_vector(to_unsigned(128 * (r_Data_Divider-1),11));
                            --r_Data_index <= 0;
                        end if;

                    when s_index =>
                        o_Ram_Index <= std_logic_vector(to_unsigned(r_Ram_index,11));
                        state <= s_save;

                    when s_save => 
                            r_Ram_Data <= i_Data;
                            state <= s_transmit;
                    
                    when s_transmit =>
                        if (r_Data_index < 4 and i_TX_Active = '0') then --added i_TX_Active = '0'
                            o_Uart_Data <= r_Ram_Data(8*(r_Data_index+1)-1 downto r_Data_index * 8);  --FROM LSB to MSB - 8 bits
                            o_TX_DV <= '1'; --Set date Byte to be valid
                            r_Data_index <= r_Data_index + 1;
                            state <= s_transmit;
                        elsif (r_Data_index = 4 and i_TX_Active = '0') then
                            o_TX_DV <= '0';
                            r_Data_index <= 0;
                            r_Ram_index <= r_Ram_index + 1;
                            state <= s_index;
                        end if;

                        if ((r_Ram_index = 127 OR (r_Ram_index = 127 * r_Data_Divider + (r_Data_Divider-1))) and r_Data_index = 4 and  i_TX_Active = '0') then --added i_TX_Active = '0'
                            state <= s_idle;
                            r_Data_Divider <= r_Data_Divider + 1;
                            --r_Ram_index <= r_Ram_index + 1; --ADDED
                            o_TX_DV <= '0';
                        end if;

               end case;
            end if;
            

    end process;
    
end architecture rtl;