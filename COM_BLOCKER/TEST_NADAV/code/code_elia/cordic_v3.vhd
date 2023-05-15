library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--
entity cordic_v3 is
	port (
		clk 	     :in std_logic;
		rst 		 :in std_logic;
		i_I_filter   :in std_logic_vector(26 downto 0);
		i_Q_filter   :in std_logic_vector(26 downto 0);
		o_data_angle :out signed (18 downto 0); --sfix17_EN8
		o_valid 	 :out std_logic;

        xt_out : out signed(44 downto 0)
	);
end entity cordic_v3;

architecture rtl of cordic_v3 is

    type State_type is (RESET,A); 
	signal state : State_Type; 

    type mem_t1 is array(0 to 7) of signed(9 downto 0);	--2pow-i window  ufix10_8EN
    type mem_t2 is array(0 to 7) of signed(14 downto 0);	--tan window	ufix15_8EN
    --2^-i value:
	signal ram_2i : mem_t1;	
	attribute ram_init_file : string;

	attribute ram_init_file of ram_2i :
	signal is "2_pow_-i.mif";
	
    --tan value:
	signal ram_tan : mem_t2;	
	attribute ram_init_file of ram_tan :
	signal is "tan.mif";
    --calc signals:
    signal count :integer range 0 to 8;
    signal count_fixed_pn :std_logic;
    signal count_fixed_np :std_logic;
    signal xt :signed(44 downto 0);
    signal yt :signed(44 downto 0);
    signal angle : integer; 
    signal flagA :std_logic;
    signal flagB :std_logic;
    signal flag_RST :std_logic;
    signal x :signed(44 downto 0);
    signal y :signed(44 downto 0);
    signal D :integer range -1 to 1;
    signal I_type :std_logic;
    signal Q_type :std_logic;
    signal angle_fix :integer;
    signal spike_fixed_pn  :std_logic;
    signal spike_fixed_np  :std_logic;
begin
    D <=   -1  when (yt(44) = xt(44)) else
            1;
        xt_out <= xt;
    angle_fix <= -46080 when (Q_type = '1' AND I_type = '1') else
                  46080 when (Q_type = '0' AND I_type = '1') else
                  0;
   cordic_v3_calc: process(clk, rst)
   begin
    if rst = '0' then
        state <= RESET;
        count <= 0;
        count_fixed_pn <= '0';
        count_fixed_np <= '0';
        spike_fixed_pn <= '0';
        spike_fixed_np <= '0';
        xt <= (others => '0');
        yt <= (others => '0');
        angle <= 0;
        flagA <= '0';
        flagB <= '0';
        flag_RST <= '0';
        x <= (others => '0');
        y <= (others => '0');

    elsif rising_edge(clk) then
     case state is   
        when reset =>
					state <= A;  
        when A =>
                if D = -1 then
                    if flagA = '0' then
                         angle <= angle + to_integer(ram_tan(count));
                         x <= shift_right(resize((yt*ram_2i(count)),45),8);
                         y <= shift_right(resize((xt*ram_2i(count)),45),8); 
                         flagA <= '1';
                    else
                        xt <= xt + x;
                        yt <= yt - y;
                        flagA <= '0';
                    end if;

                else
                    if flagB = '0'then
                         angle <= angle -  to_integer(ram_tan(count));
                         x <= shift_right(resize((yt*ram_2i(count)),45),8);
                         y <= shift_right(resize((xt*ram_2i(count)),45),8); 
                        flagB <= '1';
                    else
                         xt <= xt - x;
                         yt <= yt + y;
                         flagB <= '0';      
                    end if;
                end if;
                
                if count = 8 then  
                    spike_fixed_pn <= '0';
                    spike_fixed_np <= '0';
                    ----------------------
                    yt <= shift_left(resize(signed(i_Q_filter),45),8);
                    xt <= shift_left(resize(signed(i_I_filter),45),8);
                    o_data_angle <= (spike_fixed_np) & (spike_fixed_pn) & to_signed(angle + angle_fix,17);
                    o_valid <= '1';
                    angle <= 0;
                    count <= 0;
                    flagA <= '0';
                    flagB <= '0';
                    flag_RST <= '0';
                    Q_type <= i_Q_filter(26);
                    I_type <= i_I_filter(26);
                    -------------------------------------------------------
                    if(I_type = '1' AND Q_type = '0' AND count_fixed_pn = '0') then 
                        count_fixed_pn <= '1';
                    elsif(I_type = '1' AND Q_type = '1' AND count_fixed_pn = '1') then 
                        spike_fixed_pn <= '1';
                        count_fixed_pn <= '0';
                  end if;
                     -------------------------------------------------------
                     if(I_type = '1' AND Q_type = '1' AND count_fixed_np = '0') then 
                        count_fixed_np <='1';
                    elsif(I_type = '1' AND Q_type = '0' AND count_fixed_np = '1') then 
                        spike_fixed_np <= '1';
                        count_fixed_np <= '0';
                    end if;
                     -------------------------------------------------------
                    if(I_type = '0') then
                        count_fixed_np <='0';
                        count_fixed_pn <='0';
                    end if;
                     -------------------------------------------------------

                elsif flag_RST = '1' then 
                    count <= count + 1;
                    flag_RST <= '0';
                    o_valid <= '0';
                else
                    flag_RST <= '1';
                    o_valid <= '0';
                end if;
        end case;	
    end if;
   end process cordic_v3_calc;
    
end architecture rtl;

