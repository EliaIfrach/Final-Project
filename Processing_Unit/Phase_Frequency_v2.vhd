library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--

entity Phase_Frequency_v2 is
	port (
		fifo_clk	 :in std_logic; 
		rst 		 :in std_logic;
		i_angle 	 :in std_logic_vector (16 downto 0);
		o_omega		 :out std_logic_vector (16 downto 0);
		o_valid		 :out std_logic;
		o_read_fifo  :out std_logic;
		fixed_spike_pn  :in std_logic;
		fixed_spike_np  :in std_logic
	);
end entity Phase_Frequency_v2;

architecture Converter of Phase_Frequency_v2 is

type State_type is (A,B); 
signal state : State_Type; 
	
signal stage_1  :integer;
signal count 	:integer range 0 to 7;
signal flag_pn 	:std_logic;
signal flag_np 	:std_logic;
signal in_holder :std_logic;

begin
	
	process(fifo_clk,rst)
	begin
		o_read_fifo <= '1';	
	if(rst = '0') then
		stage_1 <= 0;
		o_omega <= (others => '0');
		o_read_fifo <= '0';
		o_valid <= '0';
		count <= 0;
	
	elsif(rising_edge(fifo_clk)) then

		if(fixed_spike_pn= '1' AND count < 7) then
			flag_pn <='1';
		end if;
		
		if(fixed_spike_np= '1' AND count < 7) then
			flag_np <='1';
		end if;

		if (count = 0 ) then
			o_valid <= '0';
			count <= count + 1;

		elsif(count = 7) then
			count <= count + 1;
			o_valid <= '1';
			stage_1 <= to_integer(signed(i_angle));
			in_holder <= i_angle(16);
				if((in_holder ='0' AND i_angle(16) = '1')) then 
					o_omega <= std_logic_vector(to_signed((92160 + to_integer(signed(i_angle)) - stage_1),17));
					flag_pn <= '0';
				elsif((in_holder ='1' AND i_angle(16) = '0')) then 
					o_omega <= std_logic_vector(to_signed(((to_integer(signed(i_angle)) - 92160) - stage_1),17));
					flag_np <= '0';
				else
					o_omega <= std_logic_vector(to_signed((to_integer(signed(i_angle)) - stage_1),17));
				end if;
		else
				count <= count + 1;	
		end if;

		end if;
	end process;

end Converter;