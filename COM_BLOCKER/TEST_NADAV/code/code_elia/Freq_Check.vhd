library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Freq_Check is
port(
	clk 		:in std_logic;
	rst 		:in std_logic;
    index    	:in std_logic_vector(7 downto 0);
	pow_msb		:in std_logic_vector(5 downto 0);
	Flag_Freq	:out std_logic
    );
	
end entity;

architecture bhv of Freq_Check is
	signal count :integer range 0 to 255;
begin
	process(clk,rst)
	begin
	if(rst = '0') then
		Flag_Freq <= '0';
	elsif(rising_edge(clk)) then


		if(index = "00010100" OR index = "00010101" OR index = "00010110" OR index = "11101100" OR index = "11101011" OR index = "11101010") then
			if(pow_msb > "000000") then
				Flag_Freq <= '1';
			else
				Flag_Freq <= '0';
			end if;  
		end if;
end if;
end process;
	
end bhv;
