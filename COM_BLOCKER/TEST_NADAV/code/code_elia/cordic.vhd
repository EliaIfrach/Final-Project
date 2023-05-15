library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cordic is
	port (
		clk 	     :in std_logic;
		rst 		 :in std_logic;
		i_I_filter   :in std_logic_vector(27 downto 0);
		i_Q_filter   :in std_logic_vector(27 downto 0);
		o_data_angle :out integer;
		o_valid 	 :out std_logic
	);
end entity cordic;

architecture calc of cordic is

type State_type is (A, B); 
	signal state : State_Type; 

type mem_t1 is array(0 to 7) of signed(12 downto 0);	--2pow-i window  ufix13_8EN
type mem_t2 is array(0 to 7) of signed(14 downto 0);	--tan window	ufix15_10EN

--2pow-i value:
	signal ram_2i : mem_t1;	
	attribute ram_init_file : string;

	attribute ram_init_file of ram_2i :
	signal is "2_pow_-i.mif";
	
--tan value:
	signal ram_tan : mem_t2;	
	attribute ram_init_file of ram_tan :
	signal is "tan.mif";
	
signal count :integer range 0 to 8;
signal X_new :integer;
signal Y_new :integer;
signal D	 :integer range -1 to 1;
signal D_new :integer range -1 to 1;
signal z :integer;
begin	
	D_new <= -1  when (to_integer(signed(i_Q_filter)) > 0 AND state = A) else
			  1  when (to_integer(signed(i_Q_filter)) < 0 AND state = A) else
			 -1  when (y_new > 0 AND state = B) else
			  1  when (y_new < 0 AND state = B) else
			  0;
	
process(clk,rst)
begin
	if(rst = '0') then
		--state
		state <= A;
		--outputs
		o_data_angle <= 0;
		o_valid <= '0';
		--signals
		count <= 0;
		z <= 0;
		X_new <=0;
		Y_new <=0;
		D <= 0;
	elsif(rising_edge(clk)) then
	

	
	case state is
	
	when A=>
		if (count = 0) then	
			o_valid <= '0';	

			--calc number 1:
				if(D_new = -1) then
					z <= (to_integer(ram_tan(count)));
				else
					z <= (0-to_integer(ram_tan(count)));
				end if;
			x_new <= ((to_integer(signed(i_I_filter))*1024) - to_integer(signed(i_Q_filter)*D_new*(ram_2i(count))));-- X-Y*D*ram 
			y_new <= ((to_integer(signed(i_Q_filter))*1024) + to_integer(signed(i_I_filter)*D_new*(ram_2i(count))));-- y+x*D*ram  
			
			count <= count + 1;
		state <= B;
		end if;
	when B=>
			if (count > 0 AND count < 8) then	
				if(D_new = -1) then
						z <= (z + to_integer(ram_tan(count)));
					else
						z <= (z - to_integer(ram_tan(count)));
				end if;
				
				x_new <= to_integer(x_new - (y_new*D_new*ram_2i(count))/1024);
				y_new <= to_integer(y_new + (x_new*D_new*ram_2i(count))/1024);
				count <= count + 1;	
				state <= B;
				
			elsif(count = 8) then
				o_data_angle <= z;
				o_valid <= '1';
				z <= 0;
				count <= 0;	
				state <= A;
			end if;	
		WHEN others =>
			state <= A;

end case;	
end if;
end process;
	
end architecture;