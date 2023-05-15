library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cordic_v2 is
	port (
		clk 	     :in std_logic;
		rst 		 :in std_logic;
		i_I_filter   :in std_logic_vector(27 downto 0);
		i_Q_filter   :in std_logic_vector(27 downto 0);
		o_data_angle :out signed (15 downto 0);
		o_valid 	 :out std_logic
	);
end entity cordic_v2;

architecture calc of cordic_v2 is

type State_type is (A, B); 
	signal state : State_Type; 
	
type mem_t1 is array(0 to 7) of signed(12 downto 0);	--2pow-i window  ufix13_10EN
type mem_t2 is array(0 to 7) of signed(14 downto 0);	--tan window	ufix15_8EN

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
signal X_new :signed(41 downto 0);
signal Y_new :signed(41 downto 0);
signal D	 :integer range -1 to 1;
signal y_D_new :integer range -1 to 1;
signal x_D_new :integer range -1 to 1;
signal z :integer;
--pipeline
signal flag_stage_A: std_logic;
signal flag_stage_B: std_logic;
signal x_stage_1 :signed(41 downto 0);
signal x_stage_2 :signed(41 downto 0);
signal x_stage_3 :signed(41 downto 0);
signal y_stage_1 :signed(41 downto 0);
signal y_stage_2 :signed(41 downto 0);
signal y_stage_3 :signed(41 downto 0);


begin	
	y_D_new <= -1  when (to_integer(signed(i_Q_filter)) > 0 AND state = A) else
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
		o_data_angle <= to_signed(0,16);
		o_valid <= '0';
		--signals
		count <= 0;
		z <= 0;
		X_new <=(others => '0');
		Y_new <=(others => '0');
		--pipeline
		 x_stage_1 <= (others => '0');
		 x_stage_2 <= (others => '0');
		 x_stage_3 <= (others => '0');
		 y_stage_1 <= (others => '0');
		 y_stage_2 <= (others => '0');
		 y_stage_3 <= (others => '0');
		 flag_stage_A <= '0';
		 flag_stage_B <= '0';

	elsif(rising_edge(clk)) then
		case state is 
		
		when A=>
			if (count = 0) then	
				o_valid <= '0';	
							x_stage_1 <= resize(signed(i_I_filter),42);
							x_stage_2 <= shift_right(resize(signed(i_Q_filter)*(ram_2i(count)),42),10);
							y_stage_1 <= resize(signed(i_Q_filter),42);
							y_stage_2 <= shift_right(resize(signed(i_I_filter)*(ram_2i(count)),42),10);		
				-- PHASE FIXED:
							if ((i_Q_filter(27) = '0') AND (i_I_filter(27) = '1')) then
								x_D_new <= 1;
							elsif ((i_Q_filter(27) = '1') AND (i_I_filter(27) = '1')) then
								x_D_new <= -1;
							else
								x_D_new <= 0;
							end if;
				--calc number 1:
					if(y_D_new = -1) then
						if(flag_stage_A = '0') then
							-------------------------------------------------------------
							flag_stage_A <= '1';
							--state <= A;
							-------------------------------------------------------------
						else
							x_new <= x_stage_1 + x_stage_2;	
							y_new <= y_stage_1 - y_stage_2;
							-------------------------------------------------------------
							flag_stage_A <= '0';
							z <= (to_integer(ram_tan(count)));
							count <= count + 1;		
							state <= B;							
							-------------------------------------------------------------						
						end if;					
					else
						if(flag_stage_A = '0') then
							-------------------------------------------------------------
							flag_stage_A <= '1';
							-------------------------------------------------------------			
					else
						x_new <= x_stage_1 - x_stage_2;
						y_new <= y_stage_1 + y_stage_2;
						-------------------------------------------------------------
						flag_stage_A <= '0';
						z <= (0 - to_integer(ram_tan(count)));
						count <= count + 1;		
						state <= B;
					end if;	
					end if;	
			end if;

		when B=>
				if (count > 0 AND count < 8) then	
					if(y_D_new = -1) then
						if (flag_stage_B = '0') then
							x_stage_3 <= shift_right(resize(y_new*ram_2i(count),42),10);
							y_stage_3 <= shift_right(resize(x_new*ram_2i(count),42),10);
							flag_stage_B <= '1';
						else
							x_new <= x_new + x_stage_3;
							y_new <= y_new - y_stage_3;
							z <= (z + to_integer(ram_tan(count)));
							flag_stage_B <= '0';
							count <= count + 1;	
						end if;
						
						else
							if (flag_stage_B = '0') then
									x_stage_3 <= shift_right(resize(y_new*ram_2i(count),42),10);
									y_stage_3 <= shift_right(resize(x_new*ram_2i(count),42),10);
								flag_stage_B <= '1';						
							else
								x_new <= x_new - x_stage_3;
								y_new <= y_new + y_stage_3;
								z <= (z - to_integer(ram_tan(count)));
								flag_stage_B <= '0';	
								count <= count + 1;	
					end if;
					end if;				
				elsif(count = 8) then
						--------------------------------------------
						if (x_D_new = 1) then
							o_data_angle <= to_signed((46080-z),16);
						elsif (x_D_new = -1) then
							o_data_angle <= to_signed((z+46080),16);
						else
							o_data_angle <= to_signed(z,16);
						end if;
						--------------------------------------------
					o_valid <= '1';
					z <= 0;
					count <= 0;	
					state <= A;
					X_new <=(others => '0');
					Y_new <=(others => '0');
				end if;	
			WHEN others =>
				state <= A;

end case;	
end if;
end process;
end architecture;