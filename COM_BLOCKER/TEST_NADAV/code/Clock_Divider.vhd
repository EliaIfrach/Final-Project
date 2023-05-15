library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;



entity Clock_Divider is
	
	generic
		(
			g_data_wid : integer := 29		 ;
			g_mode0    : integer := 124999999;
			g_mode1    : integer := 24999999
		
		);
	
	port
		(
			i_clk, i_rst			  : in  std_logic;
			i_enable, i_mode, i_onoff : in  std_logic;
			o_clk					  : out std_logic
		
		);

end Clock_Divider;



architecture Division of Clock_Divider is

	signal s_clk   : std_logic;
	signal s_onoff : std_logic;
	signal s_count : std_logic_vector ( g_data_wid - 1 downto 0 );
	
begin
	
	process ( i_clk, i_rst )
	begin
		
		if i_rst = '0' then
		
			s_clk	<= '0';
			s_count <= ( others => '0' );
			s_onoff <= '0';
			o_clk	<= '0';
		
		elsif rising_edge( i_clk ) then
			
			if ( i_onoff = '1' ) or ( s_onoff = '1' ) then
			
				s_onoff <= '1';
			
				if i_enable = '1' then
					
					if ( ( i_mode = '0' ) and ( s_count = g_mode0 ) ) or
					   ( ( i_mode = '1' ) and ( s_count = g_mode1 ) ) then
					   
					   s_count <= ( others => '0' );
					   o_clk <= not( s_clk );
					   s_clk <= not( s_clk );
					 
					else
						
						s_count <= s_count + 1;
					
					end if;
				
				else
					
					o_clk <= not( s_clk );
					s_clk <= not( s_clk );
				
				end if;
			
			else
				
				o_clk <= '0';
			
			end if;
		end if;
	
	end process;
end Division;