library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Decimation is
    generic(NumOfBits : integer :=20);
    port (
        clk : in std_logic;
        rst : in std_logic;
        i_data : in std_logic_vector(NumOfBits-1 downto 0);
        o_write_fifo : out std_logic;
        o_data : out std_logic_vector(NumOfBits-1 downto 0)
    );
end entity Decimation;

architecture rtl of Decimation is
    signal counter : integer range 0 to NumOfBits;
begin
    process(clk,rst)
    begin
        if(rst = '0') then
            counter <= 0;
            o_data <= (others => '0');
        elsif(rising_edge(clk)) then
            if(counter = 5) then
                counter <= 0;
                o_data <= i_data;
                o_write_fifo <= '1';
            else
                counter <= counter + 1;
                o_write_fifo <= '0';
            end if;
        end if;
    end process;
end architecture rtl;