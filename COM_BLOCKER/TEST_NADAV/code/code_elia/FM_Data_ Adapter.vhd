library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity FM_Data_Adapter is
	port (
		clk :in std_logic;
		rst :in std_logic;
		nco_data_in :in std_logic_vector(10 downto 0);
		data_inc :out std_logic_vector(12 downto 0);
		fm_inc :out std_logic_vector(14 downto 0);
		Y :out std_logic_vector (27 downto 0);
		X :out std_logic_vector (27 downto 0);
		nco_FM_data_in :out std_logic_vector(30 downto 0);
		inc_150 :out std_logic_vector(12 downto 0);
		FM_wave_Freq :in std_logic
	);
end entity FM_Data_Adapter;

architecture Data of FM_Data_Adapter is
	signal val_freq :std_logic_vector(19 downto 0);
begin 

	val_freq <= ("00011001100110011010") when FM_wave_Freq ='1' else --5Mhz
				("00001010001111010111"); --2Mhz

	data_inc <= "0000000000011";
	fm_inc <= "000110011001101";
	inc_150 <= "0000000001100";

	X <= std_logic_vector(to_signed(1,28));
	Y <= std_logic_vector(to_signed(134217728,28));
	
	process(clk,rst)
	begin
		
		if(rst = '0') then
			nco_FM_data_in <= (others => '0');
			elsif(rising_edge(clk)) then
			nco_FM_data_in <= (val_freq) & nco_data_in ;
			
			end if;
		end process;
	end Data;

				