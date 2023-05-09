--17/01/2021
--Ron Krakovsky
--this entity do arctan(Q/I) for calculate the phase of Q/I with algorithm CORDIC (Vectoring mode).
-------------------------------------------------------------------------------
--	entity frequency_rec pin discription :
--	inputs 	: i_clk			- input clock 
--				  i_Q				- input Q signal 
--            i_I				- input I signal
--				  i_reset		- input reset => '1' reset all
--  
--	outputs 	: o_arctan 		- Output arctan(Q/I)


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity f_ARCTAN is
generic(
		arctan_inDataWidth : integer := 28
		

);
port(
		csi_clock_clk : in std_logic;
		rsi_sink_reset_n : in std_logic;
		o_valid : out std_logic;
		o_I_POSITION, o_Q_POSITION : out std_logic;
		i_Q 	: in std_logic_vector(arctan_inDataWidth - 1 downto 0);  -- sfix28_En8
		i_I 	: in std_logic_vector(arctan_inDataWidth - 1 downto 0);  -- sfix28_En8
		o_arctan : out std_logic_vector(16 downto 0)  -- sfix17_En8

);
end entity f_ARCTAN;

architecture rtl of f_ARCTAN is
signal pipeline,pipeline_d,pipeline_d2 : std_logic;
signal I_POSITION,Q_POSITION : STD_logic;
signal D : signed(1 downto 0);
signal Qi,Qi_p,Ii,Ii_p : signed((arctan_inDataWidth + 9) - 1 downto 0); -- sfix37_En8
signal angle, angle_out, angle_fix : integer range -65536 to 65536;
signal counter_i,counter : integer range 0 to 16;
--angles tan^-1(2^-i)
type mem_angle is array(0 to 7) of integer range 0 to 11521; -- ufix14_En8
constant rom_angle_i : mem_angle :=(11520,6799,3593,1823,913,458,228,113);
-- 2^-i
type mem is array(0 to 8) of integer range 0 to 256; -- ufix9_En8
constant rom_2i : mem :=(256,128,64,32,16,8,4,2,1);

type state_type is (reset, si);
signal state : state_type;

begin

	process(csi_clock_clk,rsi_sink_reset_n)
	begin
		if(rsi_sink_reset_n = '0') then
		state <= reset;
		angle <= 0;
		angle_out <= 0;
		counter_i <= 0;
		counter <= 0;
		pipeline <= '0';
		pipeline_d <= '0';
		pipeline_d2 <= '0';
		o_valid <= '0';
		elsif	rising_edge(csi_clock_clk) then
			case state is
				when reset =>
					state <= si;
						
				when si => 
					
					if D = 1 then
						
						if pipeline_d = '0' then 
							angle <= angle - (rom_angle_i(counter_i));
							Qi_p <= shift_right(resize(Ii*rom_2i(counter_i),arctan_inDataWidth + 9),0);
							Ii_p <= shift_right(resize(Qi*rom_2i(counter_i),arctan_inDataWidth + 9),0);
							pipeline_d <= '1';
						else
							Qi <= Qi + Qi_p;
							Ii <= Ii - Ii_p;
							pipeline_d <= '0';
						end if;
						
					else
						
						
						if pipeline_d2 = '0' then 
							angle <= angle + (rom_angle_i(counter_i));
							Qi_p <= shift_right(resize(Ii*rom_2i(counter_i),arctan_inDataWidth + 9),0);
							Ii_p <= shift_right(resize(Qi*rom_2i(counter_i),arctan_inDataWidth + 9),0);
							pipeline_d2 <= '1';
						else
							Qi <= Qi - Qi_p;
							Ii <= Ii + Ii_p;
							pipeline_d2 <= '0';
						end if;
						
					end if;
					
					if counter_i = 7 then 
						Qi <= resize(signed(i_Q),arctan_inDataWidth + 9);
						Ii <= resize(signed(i_I),arctan_inDataWidth + 9);
						angle_out <= angle + angle_fix;
						o_valid <= '1';
						angle <= 0;
						counter_i <= 0;
						pipeline <= '0';
						pipeline_d <= '0';
						pipeline_d2 <= '0';
						I_POSITION <= i_I(arctan_inDataWidth - 1);
						Q_POSITION <= i_Q(arctan_inDataWidth - 1);
					elsif pipeline = '1' then 
						counter_i <= counter_i + 1;
						pipeline <= '0';
						o_valid <= '0';
					else
						pipeline <= '1';
						o_valid <= '0';
					end if;
					
			end case;	
		end if;
	end process;
	
			
	D <= "11" when Qi((arctan_inDataWidth + 9) - 1) = Ii((arctan_inDataWidth + 9) - 1) else -- positive or negativ 
			"01";
					
	o_arctan <= std_logic_vector(to_signed(angle_out,17));
	
	angle_fix <= -46080 when I_POSITION = '1' and Q_POSITION = '1' else
					  46080 when I_POSITION = '1' and Q_POSITION = '0' else
					  0;

	o_Q_POSITION <= Q_POSITION;
	o_I_POSITION <= I_POSITION;
	
end architecture rtl;