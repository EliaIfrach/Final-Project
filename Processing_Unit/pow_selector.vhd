library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pow_selector is
    port(
        clk :in std_logic;
        rst :in std_logic;
        index :in std_logic_vector(12 downto 0);
        pow :in std_logic_vector(51 downto 0);
        source_eop :in std_logic;
        main_pow :out  std_logic_vector(51 downto 0);
        out_index :out std_logic_vector(12 downto 0);
        nco_inc :out std_logic_vector(14 downto 0);
        inc_test:out std_logic_vector(14 downto 0);
        testval:out std_logic_vector(14 downto 0)
    );
end entity pow_selector;


architecture rtl of pow_selector is
    signal pow_holder :std_logic_vector(51 downto 0);
    signal index_holder :std_logic_vector(12 downto 0);
begin
    inc_test <= "000010100011111";
    testval <= "000001111101000";
    process(clk,rst)
    begin
        if(rst='0') then
            main_pow <= (others => '0');
            pow_holder <= (others => '0');
            index_holder <= (others => '0');

        elsif(rising_edge(clk)) then
            if(source_eop = '1') then
                main_pow <= pow_holder;
                out_index <= index_holder;
                pow_holder <= (others => '0');
                index_holder <= (others => '0');

                if(index_holder(12) = '0') then
                    nco_inc <= std_logic_vector(resize((unsigned(index_holder) * 4),15));

                end if;
                    

            elsif((signed(pow)) > (signed(pow_holder))) then
                pow_holder <= pow;
                index_holder <= index;
            end if;
        end if;
    end process;
end architecture;