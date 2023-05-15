library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RAM_Maneger is
    port (
        clk             : in    std_logic;
        rst             : in    std_logic;
        i_index         : in    std_logic_vector(12 downto 0);
        i_pow_data      : in    std_logic_vector(51 downto 0);
        i_Save_Data     : in    std_logic;
        i_SOP           : in    std_logic;
        o_pow_data      : out   unsigned(31 downto 0);
        o_index         : out   unsigned(10 downto 0);
        o_Done_Data     : out   std_logic;
        o_write         : out   std_logic;
        o_byteenable    : out   std_logic_vector(3 downto 0)
    );
end entity RAM_Maneger;

architecture arch_RAM_Maneger of RAM_Maneger is
    signal count        : integer range 0 to 2048;
    signal r_send_data  : std_logic;
begin
    process(clk,rst)
    begin
        if rst = '0' then
            r_send_data <= '0';
            o_write <= '0';
            o_byteenable <= (others => '0');
            o_Done_Data <= '0';
        elsif rising_edge(clk) then
            if (i_SOP = '1' and i_Save_Data = '1') then --לטפל בזה, בעיית זמנים
                r_send_data <= '1';
            end if;

            if r_send_data = '1' then
                if unsigned(i_index) < 2048 then
                    o_index <= unsigned(i_index(10 downto 0));
                    o_pow_data <= resize(unsigned(i_pow_data(51 downto 20)), 32);
                    o_write <= '1';
                    o_byteenable <= (others => '1');
                    o_Done_Data <= '0';
                    count <= count + 1;
                end if;
                if(count = 2047) then
                    count <= 0;
                    r_send_data <= '0';
                    o_Done_Data <= '1';
                    o_write <= '0';
                    o_byteenable <= (others => '0');
                end if;
            else
                o_write <= '0';
                o_byteenable <= (others => '0');
                o_Done_Data <= '0';
            end if;
        end if;
    end process;

end architecture ;
