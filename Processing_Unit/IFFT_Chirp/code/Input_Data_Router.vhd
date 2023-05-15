library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;



entity Input_Data_Router is
	
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


architecture arch_data_routing of Input_Data_Router is

type 	t_state is ( s_invalid, s_chirp_enable, s_ifft_enable );
signal	r_state : t_state;
signal	r_data	: std_logic_vector ( g_data_width - 1 downto 0 );

begin

process( i_clk )
begin
	if rising_edge( i_clk ) then
		
		if i_rst = '0' then
			
			r_state		   <= s_invalid;
			r_data		   <= ( others => '0' );
			o_data		   <= ( others => '0' );
			o_IFFT_enable  <= '0';
			o_chirp_enable <= '0';
			o_valid		   <= '0';
			
		else
			
			o_data <= r_data;
			r_data <= i_data;
			
			case r_state is
				
				when s_invalid =>
					
					o_valid <= '0';
					
					if i_valid = '0' then
						
						r_state <= s_invalid;
						
					elsif i_type = '1' then
						
						r_state <= s_ifft_enable;
					
					else
						
						r_state <= s_chirp_enable;
						
					end if;
					
				when s_ifft_enable =>
					
					o_valid		   <= '1';
					o_ifft_enable  <= '1';
					o_chirp_enable <= '0';
					
					if i_valid = '0' then
						
						r_state <= s_invalid;
						
					elsif i_type = '1' then
						
						r_state <= s_ifft_enable;
					
					else
						
						r_state <= s_chirp_enable;
						
					end if;
					
				when s_chirp_enable =>
					
					o_valid		   <= '1';
					o_ifft_enable  <= '0';
					o_chirp_enable <= '1';
					
					if i_valid = '0' then
						
						r_state <= s_invalid;
						
					elsif i_type = '1' then
						
						r_state <= s_ifft_enable;
					
					else
						
						r_state <= s_chirp_enable;
						
					end if;
					
				when others =>
					
					r_state <= s_invalid;
					
			end case;
			
		end if;
	end if;
end process;
	
end arch_data_routing;
					
					
					