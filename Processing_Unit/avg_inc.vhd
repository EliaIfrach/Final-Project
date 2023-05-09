library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
 
entity avg_inc is
port ( clk,reset: in std_logic;
       i_index :in  std_logic_vector(14 downto 0);
       o_inc: out std_logic_vector(14 downto 0)
    );
end avg_inc;
 
architecture bhv of avg_inc is
 
	signal count :integer range 0 to 14999;
    signal out_cout :integer range 0 to 20;
    signal sum   : integer;
 
begin
 
process(clk,reset)
begin
    if(reset='0') then
        o_inc <= (others => '0');
    elsif(rising_edge(clk)) then
        if (count = 14999) then
            sum <= sum + to_integer(unsigned(i_index));
            count <= 0;
            out_cout <= out_cout + 1;
        elsif(out_cout = 20) then
            o_inc <=  std_logic_vector(to_unsigned((sum/20),15));
            out_cout <= 0;
            count <= 0;
            sum <= 0;
        else
            count <= count +1;
        end if;
    end if;

end process;
 
end bhv;