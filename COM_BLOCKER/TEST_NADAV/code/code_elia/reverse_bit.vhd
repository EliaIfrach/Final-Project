library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity reverse_bit is
	port(
		clk			:in std_logic;
		rst			:in std_logic;
		source_sop 	:in std_logic;
		index_out 	:out std_logic_vector (12 downto 0)
		);
	end entity;
architecture indexmaker of reverse_bit is
	signal r_index		:std_logic_vector (12 downto 0);
	signal counter 		:std_logic_vector (12 downto 0);
	
begin 
		
		reverse: for i in 0 to 12 generate
				r_index(i) <= counter(12-i);
			end generate reverse;
			
	process(clk,rst)
	begin
		if(rst = '0') then
			index_out <= (others => '0');
			counter <=  (others => '0');
			
		elsif(rising_edge(clk)) then
		
			counter <= counter + 1;
			
			if(source_sop = '1') then
				index_out <=  (others => '0');
				counter <=  (others => '0');
			end if;
			if (counter = "1111111111111") then
				counter <=  (others => '0');
			end if;			
		end if;
	index_out <= r_index;		
	end process;
end architecture;