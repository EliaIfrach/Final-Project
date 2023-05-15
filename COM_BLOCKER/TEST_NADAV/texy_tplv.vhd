library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity texy_tplv is
    port (
        o_flag :out std_logic;
        o_index :out std_logic_vector(14 downto 0)
    );
end entity texy_tplv;

architecture rtl of texy_tplv is
    
begin
 o_flag <= '1';
    o_index <= std_logic_vector(to_unsigned(1320,15));
    
    
end architecture rtl;