library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;



entity Value_Generator is
	
	generic
		(
			g_val_wid1 : integer := 4;
			g_val_wid2 : integer := 11;
			g_val_wid3 : integer := 15;
			g_value1   : integer := 20;
			g_value2   : integer := 21;
			g_value3   : integer := 5;
			g_value4   : integer := 6
			
		);
	
	port
		(
			i_clk, i_rst	   : in  std_logic;
			o_value1, o_value2 : out std_logic_vector ( g_val_wid1 - 1 downto 0 );
			o_value3		   : out std_logic_vector ( g_val_wid2 - 1 downto 0 );
			o_value4		   : out std_logic_vector ( g_val_wid3 - 1 downto 0 )
			
		);

end value_Generator;



architecture Generation of Value_Generator is


begin
	
	process ( i_clk, i_rst )
	begin
		
		if i_rst = '0' then
			
			o_value1 <= ( others => '0' );
			o_value2 <= ( others => '0' );
			o_value3 <= ( others => '0' );
			o_value4 <= ( others => '0' );
		
		elsif rising_edge( i_clk ) then
			
			o_value1 <= std_logic_vector( to_unsigned( g_value1, g_val_wid1 ) );
			o_value2 <= std_logic_vector( to_unsigned( g_value2, g_val_wid1 ) );
			o_value3 <= std_logic_vector( to_unsigned( g_value3, g_val_wid2 ) );
			o_value4 <= std_logic_vector( to_unsigned( g_value4, g_val_wid3 ) );
		
		end if;
	
	end process;
end Generation;