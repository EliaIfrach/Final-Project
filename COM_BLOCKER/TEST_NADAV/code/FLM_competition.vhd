/*
	The FLM_competition unit - Frequency Limiting Master - manages the frequency range the IFFT should block. By giving it
	a lower limit and an upper limit, the FLM_competition knows to generate a corresponding pulse. This pulse is 'high'
	in the range between those 2 limits, and the IFFT blocks all the frequencies inside that range.
	However, Both limits have to be whole multiplicates of Mhz.
	
	Therefore, the IFFT will generate a sinc wave corresponding to the pulse given to it.
	
	Inputs and Outputs:
		
		1. i_clk 		 : The clock input.
		
		2. i_rst		 : The synchronous reset input.
		
		3. i_enable		 : The enable input. Whenever it's high, the FLM_competition operates and whenever it's low, it stops.
		
		4. i_limit_down  : This input represents the lowest frequency the IFFT should block. It has to be noted in integer multiplicates of Mhz.
		
		5. i_limit_up	 : This input represents the highest frequency the IFFT should block. It has to be noted in integer multiplicates of Mhz.
		
		6. o_block_range : The output signal sent to the IFFT. Whenever it's high, the IFFT will block its current
						   frequency and vice versa.
	
	Throughput Latency:
		
		The FLM_competition has 1 clock cycle latency to react to a change in any of its inputs
		
	***It's made specifically for the project competition!


*/



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;



entity FLM_competition is
	
	generic
		(
			g_data_wid_in  : integer := 7	  ;		-- The data width of input data. It should be large enough to contain the highest frequencies the IFFT should block.
			g_fft_pts_wid  : integer := 10	  ;		-- The bit_length of the value of the throughput latency of the IFFT ( or to the transform length - 1 ).
			g_fft_pts	   : integer := 1024  ;		-- The transform length of the IFFT - 1.
			g_sig_power	   : integer := 128000;		-- The amplitude the IFFT should generate when it's blocking a frequency.
			g_data_wid_out : integer := 18			-- The data width of the output data. It should be equal to the data precision of the IFFT.
			
		);
	
	port
		(
			i_clk, i_rst			 : in  std_logic;
			i_enable, i_valid		 : in  std_logic;
			i_limit_down, i_limit_up : in  std_logic_vector ( g_data_wid_in  - 1 downto 0 );
			o_block_range			 : out std_logic_vector ( g_data_wid_out - 1 downto 0 );
			o_valid					 : out std_logic
			
		);

end FLM_competition;



architecture Freq_Limiting of FLM_competition is


	
	function Frq_2_samp
		(
			f_limit : std_logic_vector( g_data_wid_in - 1 downto 0 )
			
		)
		
		return integer is

	begin
	
	return
		
		to_integer( shift_left( resize( unsigned( f_limit ), g_fft_pts_wid - 1 ), 1 ) + 1 );
	
	end function; 
	
	
	
	signal s_count : std_logic_vector ( g_fft_pts_wid - 1 downto 0 );
	
begin
	
	process ( i_clk )
	begin
		
		if rising_edge( i_clk ) then
			
			if i_rst = '0' then
				
				s_count		  <= ( others => '0' );
				o_block_range <= ( others => '0' );
				o_valid		  <= '0';
			
			elsif ( i_enable = '1' ) and ( i_valid = '1' ) then
				
				s_count <= s_count + 1;
				o_valid <= '1';
				
				
				if ( ( s_count >= 			  Frq_2_samp( i_limit_down ) ) and ( s_count <= 			Frq_2_samp( i_limit_up	 ) ) ) or
				   ( ( s_count >= g_fft_pts - Frq_2_samp( i_limit_up   ) ) and ( s_count <= g_fft_pts - Frq_2_samp( i_limit_down ) ) )
					then
				   
					o_block_range <= std_logic_vector( to_unsigned( g_sig_power, g_data_wid_out ) );
				
				else
					
					o_block_range <= ( others => '0' );
				
				end if;
			
			elsif i_valid = '0' then
				
				o_valid <= '0';
			
			else
				
				o_block_range <= o_block_range;
			
			end if;
		end if;
	
	
	end process;
end Freq_Limiting;
