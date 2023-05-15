/*
	This component shall function as a tester unit, for reset inputs, valid inputs, enable inputs, etc.
	By swiftly asserting and deasserting the inputs, the influence of said input over the output will become easier
	to understand.
*/

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;



entity Tester is
	
	generic
		(
			g_data_wid1 : integer						   := 11										 ;
			g_normal0 	: std_logic_vector ( 10 downto 0 ) := std_logic_vector( to_unsigned( 10 , 11 ) ) ;
			g_normal1 	: std_logic_vector ( 10 downto 0 ) := std_logic_vector( to_unsigned( 30 , 11 ) ) ;
			g_normal2 	: std_logic_vector ( 10 downto 0 ) := std_logic_vector( to_unsigned( 200, 11 ) ) ;
			g_normal3 	: std_logic_vector ( 10 downto 0 ) := std_logic_vector( to_unsigned( 1500, 11 ) );
			g_test1		: integer						   := 50
		
		);
	
	port
		(
			i_clk, i_rst	 : in  std_logic									;
			i_mode 			 : in  std_logic_vector ( 1 downto 0 )				;
			i_flip, i_enable : in  std_logic									;
			o_data			 : out std_logic_vector ( g_data_wid1 - 1 downto 0 );
			o_asser			 : out std_logic
		
		);
		
end Tester;



architecture Test of Tester is

	type t_col_vector is array( 0 to 3 ) of std_logic_vector ( g_data_wid1 - 1 downto 0 );
	
	signal s_limit1 : t_col_vector := ( g_normal0, g_normal1, g_normal2, g_normal3 );

	
	signal s_count1 : std_logic_vector ( g_data_wid1 - 1 downto 0 )			 ;
	signal s_DFF1   : std_logic_vector ( 1 				 downto 0 ) := i_mode;
	
begin

	process( i_clk, i_rst )
	begin
		
		if i_rst = '0' then
			
			o_asser <= '0';
			s_count1 <= std_logic_vector( to_unsigned( 0, g_data_wid1 ) );
			o_data <= ( others => '0' );
		
		elsif rising_edge( i_clk ) then
		
			if i_enable = '1' then
				
				s_DFF1 <= i_mode;
				o_data <= s_count1 + 1;
				
				if s_count1 >= ( s_limit1( to_integer( unsigned( s_DFF1 ) ) ) - 1 ) then
					
					if s_count1 >= ( s_limit1( to_integer( unsigned( s_DFF1 ) ) ) + g_test1 - 1 ) then
						
						o_asser  <= not( i_flip );
						s_count1 <= std_logic_vector( to_unsigned( 0, g_data_wid1 ) );
					
					else
						
						s_count1 <= s_count1 + 1;
						o_asser  <= i_flip;
					
					end if;
						
				else
					
					s_count1 <= s_count1 + 1;
					o_asser  <= not( i_flip );
				
				end if;
			
			else
				
				o_asser <= i_flip;
				
			
			end if;
		end if;
	
	end process;
end Test;			