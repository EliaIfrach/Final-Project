library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--

entity Phase_Frequency_Converter_V2 is
	port (
		fifo_clk	 :in std_logic; 
		rst 		 :in std_logic;
		i_angle 	 :in std_logic_vector (27 downto 0);
		o_omega		 :out std_logic_vector (27 downto 0);
		o_valid		 :out std_logic;
		o_read_fifo  :out std_logic;
		fixed_spike_pn  :in std_logic;
		fixed_spike_np  :in std_logic
	);
end entity Phase_Frequency_Converter_V2;

architecture Converter of Phase_Frequency_Converter_V2 is

type State_type is (A,B); 
signal state : State_Type; 
	
signal stage_1  :integer;
signal count 	:integer range 0 to 7;
signal flag_pn 	:std_logic;
signal flag_np 	:std_logic;
signal spike    :std_logic;
signal holder   :std_logic_vector (27 downto 0);
signal val_no_fixedpoint :signed (27 downto 0);
begin

	
	process(fifo_clk,rst)
	begin
		o_read_fifo <= '1';	
		val_no_fixedpoint <= shift_right(signed(i_angle),8);

	if(rst = '0') then
		stage_1 <= 0;
		o_omega <= (others => '0');
		o_read_fifo <= '0';
		o_valid <= '0';
		count <= 0;
	
	elsif(rising_edge(fifo_clk)) then
---------------------------------------
---------------------------------------
		if(fixed_spike_pn= '1') then
			flag_pn <= '1';
		end if;
		
		if(fixed_spike_np= '1') then
			flag_np <= '1';
		end if;
---------------------------------------
---------------------------------------
		if (count = 0 ) then
			o_valid <= '0';
			count <= count + 1;
-------------------------------
---------------------------------------
---------------------------------------			
			if(fixed_spike_pn ='1') then
				flag_pn <= '0';
				o_omega <= std_logic_vector(to_signed(92160 + to_integer(signed(holder)),28));
			end if;
			if(fixed_spike_np ='1') then
				flag_np <= '0';
				o_omega <= std_logic_vector(to_signed(to_integer(signed(holder) - 92160),28));
-------------------------------
---------------------------------------
---------------------------------------		
			end if;
			-------------------------------
		elsif(count = 7) then
			count <= count + 1;
			o_valid <= '1';
			stage_1 <= to_integer(val_no_fixedpoint);
		
			-----------------------------------------
				if(flag_pn = '1') then 
					o_omega <= std_logic_vector(to_signed((92160 + to_integer(val_no_fixedpoint) - stage_1),28));
					holder <= std_logic_vector(to_signed((92160 + to_integer(val_no_fixedpoint) - stage_1),28));
					flag_pn <= '0';
				end if;
				if(flag_np = '1') then 
					o_omega <= std_logic_vector(to_signed(((to_integer(val_no_fixedpoint) - 92160) - stage_1),28));
					holder <= std_logic_vector(to_signed(((to_integer(val_no_fixedpoint) - 92160) - stage_1),28));
					flag_np <= '0';
				end if;
				if(flag_np = '0' AND flag_pn = '0') then
					o_omega <= std_logic_vector(to_signed((to_integer(val_no_fixedpoint) - stage_1),28));
					holder <= std_logic_vector(to_signed((to_integer(val_no_fixedpoint) - stage_1),28));
					flag_np <= '0';
					flag_pn <= '0';
				end if;
				-----------------------------------------
				if(fixed_spike_pn = '1' AND flag_np = '0' AND flag_pn = '0') then
					o_omega <= std_logic_vector(to_signed((92160 + to_integer(val_no_fixedpoint) - stage_1),28));
					holder <= std_logic_vector(to_signed((92160 + to_integer(val_no_fixedpoint) - stage_1),28));
					flag_pn <= '0';
				end if;
				if(fixed_spike_np = '1' AND flag_np = '0' AND flag_pn = '0') then
					o_omega <= std_logic_vector(to_signed(((to_integer(val_no_fixedpoint) - 92160) - stage_1),28));
					holder <= std_logic_vector(to_signed(((to_integer(val_no_fixedpoint) - 92160) - stage_1),28));
					flag_pn <= '0';
				end if;


		else
				count <= count + 1;	
		end if;

		end if;
	end process;

end Converter;