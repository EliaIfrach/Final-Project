library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity window_mult is
	port(
		clk 		:in std_logic;
		rst 		:in std_logic;
		data_in 	:in std_logic_vector (13 downto 0);
		data_out 	:out std_logic_vector (13 downto 0)
	);
end entity;
architecture multiplication of window_mult is

type mem_t is array(0 to 16383) of unsigned(13 downto 0);

--rect window:
	signal ram_react : mem_t;	
	attribute ram_init_file : string;

	attribute ram_init_file of ram_react :
	signal is "window_mif.mif";
	
	
signal count :integer range 0 to 16383;
signal r_out :std_logic_vector (27 downto 0);	
	
begin
	mult: process(clk,rst)
		begin
			if(rst = '0') then
				r_out <= "0000000000000000000000000000";
				count <=0;
			elsif(rising_edge(clk)) then			
					r_out <= std_logic_vector(signed(data_in) * signed(ram_react(count))/4);
					if(count /=16383) then
						count <= count + 1;
                    elsif(count = 16383) then
                        count <= 0;
					else
						r_out <= "0000000000000000000000000000";
					end if;

end if;
	end process;
	data_out <= r_out(27 downto 14); --put outs the 14 bit's -MSB
end multiplication;