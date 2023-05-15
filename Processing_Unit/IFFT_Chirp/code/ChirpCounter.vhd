/*
	This unit acts as the frequency changer of the chirp jammer. It functions as a simple up-counter, 
	which creates a sawtooth waveform, input into the NCO. This way, the NCO will generate a wave at 
	increasing frequencies, and so serve as a chirp signal generator.
	
	
	Additional functionalities of the counter include:
	
	1.	Limit Set: The user can input binary values to the counter, and so limit the chirp wave in 
		its initial and final frequencies.
		
	2.	Scan Rate: Dictates the frequency in which the frequency changer operates. The frequency 
		can only move between 1 Hz to 1 MHz.
		
	3.	Custom Mode: Whenever the custom mode is active, the user can change the frequency limits
		to his heart's content. However, When this mode is inactive, the limits are set as
		follows:
		Upper Limit: 20 MHz
		Lower Limit: 15 MHz
		
	4.	Enable: In order to adapt the device to operate during set periods of time only, 
		Enable Mode is added.
	
	Limitations:
	
	1.	Range Limit: The frequency range has a maximum size of 5 MHz. The user must not define a 
		larger range, or else the Chirp won't be able to operate at its highest scan rates.
	
	
	Inputs and Outputs:
	
	1.	i_clk : This input is connected to the appropriate external clock.
	
	2.	i_rst : This input is connected to the global asynchronous reset of the Transmitter.
	
	3.	i_limit_up : This input is connected to an external data vector, which controls the upper limit of
					 the chirp signal.
	
	4.	i_limit_down: Same as number 3, except the lower limit is affected.
	
	5.	i_enable : This input signs the time period for which the chirp counter is operating. Whenever 
				   it's '1', the Jammer is active and when the signal is '0' the jammer is inactive.
	
	6.	i_scan_rate : This input controls the scan rate of the chirp signal - How many times the chirp 
					  counter repeats its spectrum every second. Its value can be calculated with 
					  the following formula:
					  i_scan_rate = (maximum_scan_rate) / (target_scan_rate) - 1.
					  In order to stay within the designated limits, i_scan_rate must not surpass 
					  999,999, or go below 0.
	
	7.	i_custom : Enables or disables custom mode. Activates on a '1'.
	
	8.	i_source_ready : Signs whether the NCO is 'recovering from reset'. Whenever it's low, the NCO
						 generates invalid data. In order to re-assert this input, the NCO must receive 5 clock
						 cycles for which the sink_valid is high. This input is deasserted only when the NCO
						 is reset.
	
	9.	i_sink_valid : This input signs whether sink_data is valid and should be adressed, or invalid and must be
					   ignored. Whenever this input is deasserted, source_valid is set to low and the ChirpCounter
					   stops generating new outputs.
		
		o_source_valid : The source_valid output.
	
	.	o_fcw: The current frequency for the NCO to generate.
	
	
	Throughput Latency:
	
	1. i_enable : The clock latency of this input is 2 clock cycles.
	
	2. data : Data will be output by the ChirpCounter after 1 clock cycle.
	
	3. boot : Whenever the ChirpSignal generator receives its first high i_enable, it will generate data after 7
			  clock cycles.
	
	4. reset (asserted) : 1 clock cycle.
	5. reset (deasserted) : 5 clock cycles.
*/


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;



entity ChirpCounter is

	generic
		(
			g_data_wid1 : integer := 9  ; 	-- The width of input and output phase jumps, transmitted to the NCO.
			g_scan_wid1 : integer := 20 ;	-- The width of i_scan_rate and s_scan.
			g_size_up 	: integer := 204;	-- This integer is equivalent to the phase jump required to achieve the Upper Limit frequency.
			g_size_down : integer := 154    -- This integer is equivalent to the phase jump required to achieve the Lower Limit frequency.
			
		);

	port
		(
			i_clk, i_rst									 : in  std_logic;
			i_enable, i_custom, i_source_ready, i_sink_valid : in  std_logic;
			i_limit_down, i_limit_up						 : in  std_logic_vector ( g_data_wid1 - 1 downto 0 );
			i_scan_rate										 : in  std_logic_vector ( g_scan_wid1 - 1 downto 0 );
			o_source_valid									 : out std_logic;
			o_fcw											 : out std_logic_vector ( g_data_wid1 - 1 downto 0 )
		
		);

end ChirpCounter;




architecture Chirp of ChirpCounter is

	signal s_fcw	: std_logic_vector ( g_data_wid1 - 1 downto 0 ) := std_logic_vector( to_unsigned( -1	, g_data_wid1 ) );
	signal s_scan	: std_logic_vector ( g_scan_wid1 - 1 downto 0 ) := std_logic_vector( to_unsigned( 999999, g_scan_wid1 ) );
	signal s_enable : std_logic;
	
begin
	
	process( i_clk )
	begin
	
		if rising_edge( i_clk ) then
			
			if i_rst = '0' then
				
				if i_custom = '1' then
				
					s_fcw <= i_limit_down;
				
				else
				
					s_fcw <= std_logic_vector( to_unsigned( g_size_down, g_data_wid1 ) );
				
				end if;
				
				s_enable <= i_enable;
				s_scan	 <= ( others => '0' );
				o_fcw	 <= ( others => '0' );
				o_source_valid <= '0';
			
			else
			
				o_source_valid <= i_enable and i_sink_valid;
				s_enable	   <= i_enable;
				
				if ( s_enable = '0' ) or ( i_source_ready = '0' ) or ( i_sink_valid = '0' ) then
					
					s_enable <= i_enable;
				
				else	
				
					
					if s_scan >= i_scan_rate then
					
						if ( i_custom = '1' ) and ( s_fcw >= i_limit_up ) then
							
							s_fcw	<= i_limit_down;
							o_fcw	<= i_limit_down;
							
						elsif ( i_custom = '0' ) and ( s_fcw >= g_size_up ) then
						
							s_fcw	<= std_logic_vector( to_unsigned( g_size_down, g_data_wid1 ) );
							o_fcw	<= std_logic_vector( to_unsigned( g_size_down, g_data_wid1 ) );
							
						else
							
							s_fcw	<= s_fcw + 1;
							o_fcw	<= s_fcw + 1;
						
						end if;
						
						s_scan <= ( others => '0' );
					
					else
						
						s_scan <= s_scan + 1;
					
					
					end if;
				end if;
			end if;
		end if;
	
	end process;
end Chirp;