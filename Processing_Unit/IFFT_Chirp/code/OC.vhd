library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;



entity OC is
	
	generic
		(
			g_data_wid1 : integer := 18
			
		);
	
	port
		(
			i_clk, i_rst		   : in  std_logic;
			i_enable, i_sink_valid : in  std_logic;
			i_sink_data		  	   : in  std_logic_vector ( g_data_wid1 - 1 downto 0 );
			o_source_valid		   : out std_logic;
			o_source_data		   : out std_logic_vector ( g_data_wid1 - 1 downto 0 )
		
		);

end OC;



architecture Output_Control of OC is


begin
	
	process ( i_clk )
	begin
		
		if rising_edge( i_clk ) then
			
			if ( i_rst = '0' ) or ( i_enable = '0' ) then
				
				o_source_data  <= ( others => '0' );
				o_source_valid <= i_rst and i_sink_valid;
			
			else
				
				if i_sink_valid = '1' then
					
					o_source_data <= i_sink_data;
					o_source_valid <= '1';
				
				else
					
					o_source_valid <= '0';
				
				
				end if;
			end if;
		end if;
	
	end process;
end Output_Control;