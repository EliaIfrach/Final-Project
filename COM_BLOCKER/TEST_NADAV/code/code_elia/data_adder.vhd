library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_adder is
    port(
        clk :in std_logic;
        rst :in std_logic;
        data_in :in signed(9 downto 0);
        data_150_in :in signed(9 downto 0);
        out_data :out signed(10 downto 0);
        SW_150   :in std_logic
    );
end entity data_adder;


architecture rtl of data_adder is
    signal holder :signed(10 downto 0);
begin
    holder <= resize(data_in,11);
    process(clk,rst)
    begin
        if(rst='0') then
            out_data <= (others => '0');
        elsif(rising_edge(clk)) then
            if SW_150 = '0' then
            out_data <= (holder + data_150_in);
            else
                out_data <= (holder);
            end if;             
        end if;
    end process;
end architecture rtl;