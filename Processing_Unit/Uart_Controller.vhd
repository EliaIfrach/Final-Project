library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Uart_Controller is
    port
        (
        clk                 : in std_logic;
        rst                 : in std_logic;
        i_Pow_Data          : in std_logic_vector(31 downto 0);
        i_Done_Saving       : in std_logic;
        i_RX_Data           : in std_logic_vector(7 downto 0);
        i_TX_Active         : in std_logic;
        i_Read_Data         : out std_logic;
        o_TX_Data           : out std_logic_vector(7 downto 0);
        o_Save              : out std_logic
        );
end entity;

architecture arch_Uart_Controller of Uart_Controller is
    signal r_pow_data     : std_logic_vector(31 downto 0);
    signal r_counter      : integer range 0 to 4;
    signal r_done_saving  : std_logic;
    signal r_count_data   : integer range 0 to 2047;
begin
    r_done_saving <= '1' when i_Done_Saving = '1' else
                     '0';
    process(clk, rst)
    begin
        if rst = '0' then
            r_pow_data <= (others => '0');
            r_counter <= 1;
        elsif rising_edge(clk) then
            if(i_RX_Data = "00001010") then -- האם זו לא בעיה לשלוח למשדר מידע כל עליית שעון? מבחינת זמני שידור בייט
                if(r_done_saving = '1' AND r_count_data < 2048) then
                    i_Read_Data <= '1'; -- לבדוק את היציאה הזו
                    r_done_saving <= '1';
                    r_pow_data <= i_Pow_Data;
                    if(r_counter < 4 AND r_counter > 0 AND i_TX_Active ='0') then
                        o_TX_Data <= r_pow_data((8 * r_counter)- 1 downto (8 * r_counter) - 8);
                    else
                        r_count_data <= r_count_data + 1;
                        r_counter <= 0;
                    end if;
                    if(r_count_data = 2047) then
                        r_done_saving <= '0';
                        o_Save <= '1';
                    else
                        r_done_saving <= '1';
                        o_Save <= '0';
                    end if;
                else
                    o_TX_Data <= "00000001"; -- Ram Is Not Full;
                end if;
            end if;
        end if;
    end process;
end architecture;







--אני לא אצליח לקלוט את הנתון שהראם התמלא,שתי פרוסס? פיפו? מה ניתן לעשות