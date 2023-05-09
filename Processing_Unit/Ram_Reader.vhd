library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Ram_Reader is
  port (
    -- Avalon Memory Mapped interface
    avalon_mm_clk   : in  std_logic;
    avalon_mm_reset : in  std_logic;
    avalon_mm_addr  : out std_logic_vector(10 downto 0);
    avalon_mm_wdata : out std_logic_vector(31 downto 0);
    avalon_mm_wen   : out std_logic;
    avalon_mm_wait  : in  std_logic;
    avalon_mm_rdata : in  std_logic_vector(31 downto 0);
    avalon_mm_ren   : out std_logic;
    o_byteenable : out std_logic_vector(3 downto 0);
  );
end entity Ram_Reader;

architecture rtl of Ram_Reader is
  signal address_counter    : unsigned(10 downto 0) := (others => '0');
  signal read_address       : std_logic_vector(10 downto 0);
  signal state              : integer range 0 to 1 := 0; -- 0: read, 1: done
begin

  -- Generate read address
  read_address <= std_logic_vector(address_counter);

  -- Avalon Memory Mapped interface
  avalon_mm_addr <= read_address;
  avalon_mm_ren <= '1' when (state = 0) else '0';
  o_byteenable <= "1111" when (state = 0) else "0000";
  process(avalon_mm_clk)
  begin
    if rising_edge(avalon_mm_clk) then
      if avalon_mm_reset = '1' then
        address_counter <= (others => '0');
        state <= 0;
      else
        case state is
          when 0 => -- Read
            if avalon_mm_wait = '0' then
              address_counter <= address_counter + 1;
            end if;
            if address_counter = to_unsigned(2047, 11) then -- RAM depth
              state <= 1; -- Done
            end if;
          when 1 => -- Done
            null; -- Do nothing
        end case;
      end if;
    end if;
  end process;

end architecture rtl;
