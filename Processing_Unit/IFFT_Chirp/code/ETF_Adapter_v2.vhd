/*
	This External-to-IFFT adapter unit matches frequency data to the Avalon-ST input format of the IFFT.
	It adds the necessary bits and performs other adaptations, so the proper signal will enter the IFFT.
	
	Inputs and Outputs -
		
		1. i_clk : The clock input of the ETF.
		
		2. i_rst : The reset input of the ETF. It is asynchronous reset.
		
		3. i_enable : The enable input of the ETF. This input allows the ETF to switch between an operative state
		   and a none operative state.
		
		4. i_valid : This input signs to the ETF whether the incoming data is valid or invalid. In case of valid
		   data, the ETF will output data normally. However, in case of invalid data, the ETF will output an invalid
		   data flag.
		   
		5. i_source_ready : This input is another flag, that signs whether the downstream is ready to accept data.
		   Whenever this input is '1', the ETF knows that the downstream is ready and will produce output.
		   On the contrary, if this input is '0', the ETF starts "waiting" for the downstream to be ready: It won't
		   produce output data and send the upstream a flag signaling that the ETF won't accept input.
		
		6. i_real_data : The data input making the real part of fourier transform of the signal.

		7. i_imag_data : The data input making the imaginary part of fourier transform of the signal.
			
		8. o_data : The output data of the ETF. The output data is connected directly to the data input port of
		   the IFFT.
		
		9. o_sop : This output signs start of packet to the IFFT.
		
		10. o_eop : This output signs end of packet to the IFFT.
		
		11. o_valid : This is the output valid flag of the ETF. It is assigned the value of i_valid ( see 5 ).
	
	Throughput Latency -
		1. Input Enable : 2 clock cycles to change internal values, 1 clock cycles to change o_valid.
		2. Input Data : 1 clock cycle. Data is produced immediately.
	
	Limitations -
		
		1. Enable length : Resulting from the inner throughput latency of the IFFT to certain signals, the i_enable
						   must stay stable for a while after changing its logic level. Whenever i_enable changes,
						   it must stay the same for no less than 12 clock cycles. Any less time than that will
						   result in the IFFT being late to react to the enable signal.
		
*/

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;



entity ETF_Adapter_v2 is
	
	generic
		(
			g_fft_pts	: integer := 11  ; 		-- Should be equal to log2(transform length of the IFFT) plus 1. View the IFFT qsys file and user guide for further detail.			
			g_data_wid1 : integer := 18	 ; 		-- Should be equal to the input data width and the IFFT (Real data precision).
			g_data_wid2 : integer := 48	 ; 		-- Should be equal to g_data_wid1 * 2 + g_fft_pts + 1.
			g_pts_num	: integer := 1024 		-- Should be equal to the transform length of the IFFT.
			
		);

	port
		(
			i_clk, i_enable, i_rst	 : in  std_logic									;
			i_valid, i_source_ready	 : in  std_logic									;
			i_real_data, i_imag_data : in  std_logic_vector ( g_data_wid1 - 1 downto 0 );
			o_data					 : out std_logic_vector ( g_data_wid2 - 1 downto 0 );
			o_sop, o_eop, o_valid	 : out std_logic								 
		
		);
		
end ETF_Adapter_v2;



architecture Adapting of ETF_Adapter_v2 is

	signal s_count	: unsigned ( g_fft_pts - 2 downto 0 ) := ( others => '0' );
	signal s_enable : std_logic;
	signal s_sop	: std_logic;
	

begin
	
	process ( i_clk )
	begin
			
		if rising_edge( i_clk ) then
			
			if i_rst = '0' then
			
				s_count	 <= ( others => '0' );
				s_sop	 <= '0'				 ;
				s_enable <= i_enable		 ;
				o_data	 <= ( others => '0' );
				o_sop	 <= '0'				 ;
				o_eop	 <= '0'				 ;
				o_valid  <= '0'				 ;
				
			
			else
				
				if i_enable = '0' then
						
					o_valid	 <= '0';
					s_enable <= i_enable;
					
				else
						
					o_valid <= i_valid and s_sop;
					
				end if;
				
				if ( s_enable = '0' ) or ( i_source_ready = '0' ) or ( i_valid = '0' ) then
					
					s_enable <= i_enable;
				
				else
						
					if s_count = to_unsigned( 0, g_fft_pts - 1 ) then
						
						s_sop   <= '1' ;		
						o_valid <= '1' ;
						o_sop   <= '1' ;
						o_eop   <= '0' ;
						
					elsif s_count = to_unsigned( g_pts_num - 1, g_fft_pts - 1 ) then
							
						o_sop <= '0';
						o_eop <= '1';
						
					else
							
						o_sop <= '0';
						o_eop <= '0';
						
					end if;
							
					o_data <= i_real_data & i_imag_data & std_logic_vector( to_signed( g_pts_num, g_fft_pts ) ) & '1';
					s_count <= s_count + 1;
					
				
				end if;
			end if;
		end if;
	
	end process;
end Adapting;