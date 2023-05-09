library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity UartManeger is
    generic(FFT_NumOfBits : integer := 52;
            NumOfBits : integer := 8
           );
    port (
        clk             : in    std_logic;
        rst             : in    std_logic;
        i_valid_data_rx : in    std_logic;
        i_FFT           : in    std_logic_vector(FFT_NumOfBits - 1 downto 0);
        i_flag_150      : in    std_logic;
        i_RX_Data       : in    std_logic_vector(NumOfBits - 1 downto 0);
        i_TX_Active     : in    std_logic;
        o_TX_Data       : out   std_logic_vector(NumOfBits - 1 downto 0);
        o_valid         : out   std_logic
    );
end entity;

architecture arch_UartManeger of UartManeger is
    signal r_FFT_Data : unsigned(FFT_NumOfBits - 1 downto 0);
--FFT Data Signals:
    signal counter : integer;
begin
    process(clk,rst)
    begin
        if (rst = '0') then
            r_FFT_Data <= (others => '0');
            counter <= 0;
        elsif (rising_edge(clk)) then
            
        --Sends FFT Data:
            if(i_valid_data_rx = '1' AND i_RX_Data = "00001010" AND i_TX_Active = '0') then --Val 10;
               if(counter >= 0) then
                    r_FFT_Data <= resize(shift_right(unsigned(r_FFT_Data),NumOfBits),FFT_NumOfBits);
                    o_TX_Data <= std_logic_vector(r_FFT_Data(NumOfBits -1 downto 0));
                    counter <= counter + 1;
                    o_valid <= '1';
               elsif (counter = 7) then
                    counter <= 0;
                    r_FFT_Data <= unsigned(i_FFT);
                    o_valid <= '0';
                end if;
            elsif(i_valid_data_rx = '1' AND i_RX_Data = "00000010" AND i_TX_Active = '0') then --Val 2;
                o_TX_Data <= "0000000" & i_flag_150;
           end if;
    end if;
    end process;

end architecture;