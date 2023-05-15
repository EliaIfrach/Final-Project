library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity one_mega is
	port (clk : in std_logic;
			divclk : out std_logic);

end one_mega;

architecture sec of one_mega is
signal timer : integer := 0;
signal divclk1 : std_logic := '0';
begin

	process(clk)
	begin

		if rising_edge(clk) then
			timer <= timer+1;
			if timer = 24 then
				divclk1 <= not divclk1;
				timer <= 0;
			end if;
			
		end if;
		divclk <= divclk1;
	end process;
	
end sec;
			