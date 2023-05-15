library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity Mul_FM_IQ is
	port (
		clk 	:in std_logic;
		rst 	:in std_logic;
		IQ_in 	:in std_logic_vector (27 downto 0);
		FM_in 	:in std_logic_vector(13 downto 0);
		Out_I	:out std_logic_vector (27 downto 0);
		Out_Q	:out std_logic_vector (27 downto 0)
	);
end entity Mul_FM_IQ;

architecture Mul of Mul_FM_IQ is
begin
	process(clk,rst)
	begin
		if(rst = '0') then
			Out_I <= (others => '0');
			Out_Q <= (others => '0');
			
			elsif(rising_edge(clk)) then
				out_Q <= FM_in * IQ_in (27 downto 14);
				out_I <= FM_in * IQ_in (13 downto 0);
			end if;
		end process;
	end Mul;