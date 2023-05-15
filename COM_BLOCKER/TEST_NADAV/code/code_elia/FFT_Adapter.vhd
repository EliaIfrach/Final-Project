library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_SIGNED.ALL;


entity FFT_Adapter is
	port(
		clk 			:in std_logic ;
		rst 		 	:in std_logic ;
		sink_real		:in std_logic_vector (13 downto 0);
		data			:out std_logic_vector (42 downto 0);
		sink_valid 	 	:out std_logic ;
		source_ready	:out std_logic ;
		sink_sop		:out std_logic ;
		sink_eop		:out std_logic ;
		valid_in 		:in  std_logic
	);
end entity;

architecture fft_time of FFT_Adapter is
	signal count :integer range 0 to 8191 :=0;
	signal image_sig	:std_logic_vector (13 downto 0); 
	signal flag :std_logic;
begin
	process(clk,rst)
		begin
		if(rst = '0') then
				image_sig <= "00000000000000";		
				sink_valid <= '0';
				count <= 0;
				--
				flag <= '0';
				data <= (others => '0');
			elsif(rising_edge(clk)) then
			if(valid_in ='1' or flag = '1') then
				flag <= '1';
				if(count = 0) then
					sink_valid <= '1';
					source_ready <= '1'; --connect to vcc
					sink_sop <= '1';
					sink_eop<='0';

				elsif(count = 1) then
					sink_sop <= '0';
		
				elsif(count = 8191) then 
					sink_eop<='1';

				end if;
			end if;
				count <= count + 1;
				data <= sink_real & image_sig & "100000000000000";
end if;
end process;
	
end fft_time;