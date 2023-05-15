library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Uart_FFT_TEST_DATA is
    port (
        Data : out std_logic_vector(51 downto 0)
    );
end entity Uart_FFT_TEST_DATA;

architecture rtl of Uart_FFT_TEST_DATA is
    
begin
    Data <= std_logic_vector(to_unsigned(1000, 52));
    
    
end architecture ;