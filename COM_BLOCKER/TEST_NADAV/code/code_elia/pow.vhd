library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity pow is
port(
	clk 		:in std_logic;
	rst 		:in std_logic;
	real_in 	:in std_logic_vector(25 downto 0);
	image_in 	:in std_logic_vector(25 downto 0);
	pow_result	:out std_logic_vector(51 downto 0));
	
end entity;

architecture pow_mul of pow is
begin
	
	process(clk,rst)
	begin
	if(rst = '0') then
		pow_result <= (others => '0');
	elsif(rising_edge(clk)) then
			pow_result <= ((real_in * real_in) + (image_in * image_in));
end if;
end process;
	
end pow_mul;