library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Jammer_Connector is
    generic(
        f_size   : integer := 7;
        inc_size : integer := 15
    ); 
    port (
        i_clk         : in std_logic;
        i_rst         : in std_logic;
        i_flag_150    : in std_logic;
        i_index       : in std_logic_vector(inc_size-1 downto 0);
        o_f_min       : out std_logic_vector(f_size-1 downto 0); --out integer;
        o_f_max       : out std_logic_vector(f_size-1 downto 0); --integer;
        o_valid       : out std_logic;
        o_kind_block  : out std_logic;
        o_scan_rate   : out std_logic_vector(19 downto 0) := "00000000000000001001"

    );
end entity Jammer_Connector;

architecture arch_Jammer_Connector of Jammer_Connector is


    signal r_inc : integer range 0 to 32768;
    signal r_cnt_delay : integer range 0 to 100000000;
    signal r_pac       : integer range 0 to 1023;
begin
    process(i_clk,i_rst)
	begin
        if(i_rst = '0') then
            o_f_min <= (others => '0');
            o_f_max <= (others => '0');
            o_valid <= '0';
            r_cnt_delay <= 0;
            r_pac <= 0;

        elsif(rising_edge(i_clk)) then
            if(i_flag_150 = '0') then --Not IDF Wave
                o_kind_block <= '1'; -- IFFT
                r_inc <= to_integer(unsigned(i_index)); 
            end if;

            if(r_pac = 1023) then
                o_valid <= '1';
                o_f_min <=  std_logic_vector(to_unsigned(((r_inc*10 - 830)/664)-4,f_size));
                o_f_max <=  std_logic_vector(to_unsigned(((r_inc*10 + 830)/664)+4,f_size));
                r_pac <= 0;                   
            else
                r_pac <= r_pac + 1;
            end if;
        end if;
    end process;
end architecture arch_Jammer_Connector;