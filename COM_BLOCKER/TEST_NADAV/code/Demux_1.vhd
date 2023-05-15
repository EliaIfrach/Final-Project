library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;



entity DeMux_1 is
	
	generic
		(
			g_data_wid_in  : integer := 3;
			g_data_wid_out : integer := 8
		
		);
	
	port
		(
			i_clk, i_rst   : in  std_logic										 ;
			i_mode, i_data : in  std_logic										 ;
			i_control	   : in  std_logic_vector ( g_data_wid_in - 1 downto 0 ) ;
			o_demux		   : out std_logic_vector ( g_data_wid_out - 1 downto 0 )
			
		);

end DeMux_1;



architecture Demuxing of DeMux_1 is


	
begin
	
	process ( i_clk, i_rst )
	begin
		
		if i_rst = '0' then
			
			o_demux <= ( others => '0' );
		
		elsif rising_edge( i_clk ) then
			
			if i_mode = '1' then
				
				o_demux <= std_logic_vector( to_unsigned( 0 - 1, g_data_wid_out ) );
			
			else
				
				o_demux <= ( others => '0' );
			
			end if;
			
			o_demux( to_integer( unsigned( i_control ) ) ) <= i_data;
		
		end if;
	
	end process;
end Demuxing;
