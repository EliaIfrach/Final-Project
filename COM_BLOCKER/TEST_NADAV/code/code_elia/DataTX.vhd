library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity DataTX is
    port (
        i_clk         : in  std_logic;
        i_rst         : in  std_logic;
        i_RX_Data     : in  std_logic_vector(7 downto 0);
        o_Data        : out std_logic_vector(31 downto 0)
    );
end entity DataTX;

architecture rtl of DataTX is
    
signal cnt_1 : integer range 0 to 3;
signal r_cnt_1 : std_logic;

signal cnt_2 : integer range 4 to 7;
signal r_cnt_2 : std_logic;

type rom_type is array(0 to 7) of integer;
signal rom: rom_type :=(2,4,6,10,50,40,30,20);

begin
    process(i_clk , i_rst)
        begin
        if i_rst = '0' then
            o_Data <= (others => '0');
        elsif(rising_edge(i_clk)) then
            if (i_RX_Data = "00000001" OR r_cnt_1 = '1') then
                r_cnt_1 <= '1';
                o_Data <= std_logic_vector(to_unsigned(rom(cnt_1),32));
                --o_Data <= std_logic_vector(to_unsigned(1048576,32));
                cnt_1 <= cnt_1 + 1;
                if(cnt_1 = 3) then
                    r_cnt_1 <= '0';
                    cnt_1 <= cnt_1 + 1;
                end if;
            end if;
            if (i_RX_Data = "00000010" OR r_cnt_2 = '1') then
                r_cnt_2 <= '1';
                o_Data <= std_logic_vector(to_unsigned(rom(cnt_2),32));
                --o_Data <= std_logic_vector(to_unsigned(1048576,32));
                cnt_2 <= cnt_2 + 1;
                if(cnt_2 = 7) then
                    r_cnt_2 <= '0';
                    cnt_2 <= cnt_2 + 1;
                    cnt_2 <= 4;
                end if; 
            end if;       
        end if;
    end process;
end architecture;