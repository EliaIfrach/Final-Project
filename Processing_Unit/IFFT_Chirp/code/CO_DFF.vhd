library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity CO_DFF is
	
	port
		(
			i_clk, i_rst : in  std_logic;
			i_D 		 : in  std_logic;
			o_Q			 : out std_logic
			
		);

end CO_DFF;



architecture Transfer of CO_DFF is
begin

	process ( i_clk )
	begin
		
		if rising_edge( i_clk ) then
			
			if i_rst = '0' then
				
				o_Q <= '0';
			
			else
			
				o_Q <= i_D;
			
			end if;
		end if;
	
	end process;
end Transfer;