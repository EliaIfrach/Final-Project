library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Uart_Data_Test is
    port(
        DATA : out std_logic_vector(7 downto 0);
        tx_data :out std_logic;
        clk :in std_logic;
        rst :in  std_logic;
        key :in std_logic
    );
end entity Uart_Data_Test;


architecture rtl of Uart_Data_Test is
begin
    DATA <= "00001100";
    --tx_data <= '1';
    tx_data <= '1' when key ='0' else
               '0';
end architecture rtl;