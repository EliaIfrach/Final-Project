library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;



entity Input_Data_Router_v2 is
	
	generic
		(
			g_data_width : integer := 14
		
		);
	
	port
		
		(
			i_clk, i_rst   : in  std_logic;
			i_valid		   : in  std_logic;
			i_type		   : in  std_logic;
			i_data		   : in  std_logic_vector ( g_data_width - 1 downto 0 );
			o_data		   : out std_logic_vector ( g_data_width - 1 downto 0 );
			o_IFFT_enable  : out std_logic;
			o_chirp_enable : out std_logic;
			o_valid		   : out std_logic
			
		);
		
end entity;


architecture arch_data_routing of Input_Data_Router_v2 is

begin

process( i_clk )
begin
	if rising_edge( i_clk ) then
		
		if i_rst = '0' then
			
			o_data		   <= ( others => '0' );
			o_IFFT_enable  <= '0';
			o_chirp_enable <= '0';
			o_valid		   <= '0';
			
		else
			
			o_data		   <= i_data;
			o_valid		   <= i_valid;
			o_iFFT_enable  <= i_type;
			o_chirp_enable <= not( i_type );
			
		end if;
	end if;
end process;
	
end arch_data_routing;