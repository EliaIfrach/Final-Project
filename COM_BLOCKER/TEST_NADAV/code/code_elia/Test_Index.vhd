library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Test_Index is
    port (
        clk          : in  std_logic;
        rst          : in  std_logic;
        o_index      : out std_logic_vector(10 downto 0);
        o_byteenable : out std_logic_vector(3 downto 0);
        o_chipselect : out std_logic;
        i_data       : in std_logic_vector(31 downto 0);
        i_dona_data  : in std_logic
    );
end entity Test_Index;

architecture arch_Test_Index of Test_Index is
    signal r_send_data : std_logic;
    signal send_data : std_logic;
    signal count : integer range 0 to 2047;
    
begin
    process(clk, rst)
    begin
        if rst = '0' then
            count <= 0;
        elsif rising_edge(clk) then
            if(r_send_data = '1' OR send_data = '1') then
                send_data <= '1';
                if count = 2047 then
                    count <= 0;
                    o_byteenable <= "0000";
                    o_chipselect <= '0';
                    send_data <= '0';
                else
                 count <= count + 1;
                 o_index <= std_logic_vector(to_unsigned(count, 11));
                 o_byteenable <= "1111";
                 o_chipselect <= '1';
                end if;
            end if;   
        end if;
    end process;
    r_send_data <= '1' when i_dona_data = '1' else
                   '0';
end architecture;
