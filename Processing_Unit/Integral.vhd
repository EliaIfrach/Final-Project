library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Integral is
	generic(
		Data_Vector_Size : integer :=18

		); 
	port (
		clk 			:in std_logic;
		rst 			:in std_logic;
		Filter_Data_In  :in std_logic_vector (Data_Vector_Size-1 downto 0);
		sum             :out integer;
		flag_150		:out std_logic
	);
end entity Integral;

architecture bhv of Integral is
	signal count :integer range 0 to 15;
	signal holder :integer;
	signal vector_type :integer range -1 to 1;
begin
	vector_type <= -1 when (Filter_Data_In(Data_Vector_Size-1) = '1') else
				    1 when (Filter_Data_In(Data_Vector_Size-1) = '0') else
					0;

	process(clk,rst)
	begin
	if(rst = '0') then
		sum <= 0;
		count <=0;
		holder <= 0;
		elsif(rising_edge(clk)) then
			if(vector_type = -1) then
				holder <= holder + to_integer(0 - signed(Filter_Data_In));
				sum <= holder;
				count <= count + 1;
			elsif(vector_type = 0 OR vector_type = 1) then
				holder <= holder + to_integer(signed(Filter_Data_In));
				sum <= holder;
				count <= count + 1;
			end if;
			if(count = 15) then
				count <= 0;
				sum <= 0;
				holder <= 0;
			if (holder > 50 AND holder < 300) then
					flag_150 <= '1';
			else
					flag_150 <= '0';
			end if;
			end if;
		end if;
	end process;
end bhv;