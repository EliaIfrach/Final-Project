library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity Digital_Switch is 
	
	port
	
	(
		i_clk, i_rst : in  std_logic;
		i_onoff		 : in  std_logic;
		o_onoff		 : out std_logic
		
	);
	
end entity;


architecture arch_switch of Digital_Switch is 

	signal r_onoff : std_logic;
	
begin

	process( i_clk )
	begin
	
		if rising_edge( i_clk ) then
			
			if i_rst = '0' then
				
				o_onoff <= '0';
				r_onoff <= '0';
				
			else
				
				if ( i_onoff or r_onoff ) = '1' then
				
					r_onoff <= '1';
					o_onoff <= '1';
				
				else
				
					o_onoff <= '0';
				
				
				end if;
			end if;
		end if;
		
	end process;
end arch_switch;