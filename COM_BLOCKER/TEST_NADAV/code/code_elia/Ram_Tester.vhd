library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Ram_Tester is
    port
    (
    clk         : in std_logic;
    rst         : in std_logic;
    o_index     : out std_logic_vector(12 downto 0);
    o_FFT_Data  : out std_logic_vector(51 downto 0);
    o_SOP       : out std_logic;
    o_Save_Data : out std_logic
    );
end entity Ram_Tester;

architecture arch_Ram_Tester of Ram_Tester is
    signal count : integer range 0 to 2047;
begin
    process(clk, rst)
        begin
            if rst = '0' then
                count <= 0;
                
            elsif rising_edge(clk) then
                if(count = 2047) then
                    count <= 0;
                    o_SOP <= '0';
                    o_Save_Data <= '0';
                    o_index <= std_logic_vector(to_unsigned(count, 13));

                else
                    count <= count + 1;
                    o_index <= std_logic_vector(to_unsigned(count, 13));
                    o_SOP <= '1';
                    o_Save_Data <= '1';
                end if;
      
            end if;
    end process;
    --o_FFT_Data <= std_logic_vector(to_unsigned(count*1000000000, 52));
    o_FFT_Data <= std_logic_vector(to_unsigned(100000000000000, 52)) when count = 64 or count = 4096 else
                  std_logic_vector(to_unsigned(109951162800, 52));
end architecture arch_Ram_Tester;