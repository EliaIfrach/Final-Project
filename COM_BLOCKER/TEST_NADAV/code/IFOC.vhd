/*
	This component serves to control the final Output of the IFFT - Block unit. While also making sure that
	system output is '0' whenever it is disabled, it has an additional use as well.
	
	The main issue with the IFFT is its reaction to the enable input. Since I didn't design the FFT/IFFT 
	design unit, I must adapt the rest of the system accordingly. One those issues is the lack of enable input
	in the FFT. Therefore, I decided to use the sink_valid input for the purpose of enable,
	since the function of disable input is the same as invalid data input.
	
	However, further testing showed that the throughput latency of sink_valid is equal to 10 clock cycles.
	
	Thus, the second ( I might even say, the main ) goal of this component is to overcome that unwanted latency.
	To that end, whenever this component receives low enable and high valid, it saves the incoming data until
	sink_valid is low.
	
	Moreover, when sink_enable is high and valid is low, it ignores the invalid input and transmits the data
	it saved. Finally, it saves and generates the source_valid signal associated with the saved data samples;
	there is no guarantee that the saved data is valid to begin with.
	
	
	Inputs and Outputs:
		
		1.	i_clk	: The clock input.
		2.	i_rst	: The synchronous reset input.
		3.	i_enable: The enable input. whenever this input is low, the IFOC will transmit '0' on all of its outputs.
					  Moreover, it will start saving input data, as explained above. Whenever this input goes back
					  to high, it will produce output data once again.
		4.	i_sop	: This input takes the incoming start of packet signal and moves it to the output.
		5.	i_eop	: This input is similiar to i_sop, but for end of packet.
		6.	i_valid : The sink_valid input.
		7.	i_data	: The sink_data input.
		8.	o_data	: The source_data output.
		9.	o_sop	: The source sop, in accordance with i_sop.
		10. o_eop	: same as o_sop, but for i_eop.
		11.	o_valid	: The source_valid output.
	
	Throughput Latency:
		
		1. i_enable: Whenever i_enable changes its logic level, the output values update after 2 clock cycles.
		2. i_valid, i_data: Whenever i_valid or i_data change their logic level, the output updates after 1 clock
							cycle.
	
*/



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;



entity IFOC is
	
	generic
		(
			g_fft_pts	   : integer := 11;		-- The bit_length representing the number of samples used by the IFFT.
			g_data_wid_in  : integer := 47;		-- The bit_length of input data.
			g_data_wid_out : integer := 18		-- The bit_length of output data.
		
		);
	
	port
		(
			i_clk, i_rst					: in  std_logic										  ;
			i_enable, i_sop, i_eop, i_valid : in  std_logic										  ;
			i_data							: in  std_logic_vector ( g_data_wid_in  - 1 downto 0 );
			o_data							: out std_logic_vector ( g_data_wid_out - 1 downto 0 );
			o_sop, o_eop, o_valid			: out std_logic
		
		);

end IFOC;



architecture Adapting of IFOC is
	
	type t_mem is array( 0 to 9 ) of std_logic_vector ( g_data_wid_out - 1 downto 0 );
	
	signal s_mem	   : t_mem	  ;
	signal s_enable	   : std_logic;
	signal s_count	   : unsigned ( 3 downto 0 );
	signal s_mem_valid : unsigned ( 10 downto 0 );
	signal s_action	   : std_logic;

	
begin
	
	process ( i_clk )
	begin
		
		if rising_edge( i_clk ) then
			
			if i_rst = '0' then
				
				s_count		<= ( others => '0' )								 			   ;			
				s_mem		<= ( others => std_logic_vector( to_signed( 0, g_data_wid_out ) ) );
				s_mem_valid <= ( others => '0' )											   ;
				s_action	<= '0'															   ;
				o_data		<= ( others => '0' )								 			   ;
				o_sop		<= '0'												 			   ;
				o_eop		<= '0'												 			   ;
				o_valid		<= '0'												 			   ;
			
			elsif s_enable = '0' then
				
				o_data	<= ( others => '0' );
				o_sop	<= '0'				;
				o_eop	<= '0'				;
			
			
				if ( s_count < 10 ) and ( s_action = '0' ) then
				
					s_mem( to_integer( s_count ) ) 		 <= i_data( g_data_wid_in - 1 downto g_data_wid_in - g_data_wid_out );
					s_mem_valid( to_integer( s_count ) ) <= i_valid;
					s_count								 <= s_count + 1;
					s_action							 <= s_count( 3 ) and s_count( 0 );
				
				else
					
					s_count 		  <= ( others => '0' );
					s_mem_valid( 10 ) <= i_valid or s_mem_valid( 10 );
				
				end if;
			
			
			elsif ( s_count < 10 ) and ( s_action = '1' ) then
				
				o_data  <= s_mem( to_integer( s_count ) ) + std_logic_vector( to_unsigned( 4096, g_data_wid_out ) );
				o_valid <= s_mem_valid( to_integer( s_count ) );
				s_count <= s_count + 1						   ;
				
			
			else
				
				s_count			  <= ( others => '0' );
				s_action		  <= '0';
				s_mem_valid( 10 ) <= '0';
				o_sop			  <= i_sop;
				o_eop			  <= i_eop;
				o_data			  <= i_data( g_data_wid_in - 1 downto g_data_wid_in - g_data_wid_out ) + std_logic_vector( to_unsigned( 4096, g_data_wid_out ) );
				o_valid			  <= i_valid or s_mem_valid( 10 );
			
			end if;
			
			
			s_enable <= i_enable;
		
		end if;
	
	end process;
end Adapting;