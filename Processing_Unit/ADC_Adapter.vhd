library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ADC_Adapter is
    port (
        clk                : in std_logic;
        rst                : in std_logic;
        AD_SCLK            : out std_logic;
        AD_SDIO            : out std_logic;
        ADA_D              : in std_logic_vector(13 downto 0);
        ADA_DCO            : in std_logic;
        ADA_OE             : out std_logic;
        ADA_OR             : out std_logic;
        ADA_SPI_CS         : out std_logic;
        DA                 : out std_logic_vector(13 downto 0);
        FPGA_CLK_A_N       : out std_logic;
        FPGA_CLK_A_P       : out std_logic

    );
end entity ADC_Adapter;
architecture rtl of ADC_Adapter is

begin
    FPGA_CLK_A_P <= not(clk);
    FPGA_CLK_A_N <= clk;
    AD_SCLK <= '1';
    AD_SDIO <= '0';
    ADA_OE <= '0';
    ADA_SPI_CS <= '1';

    DA	<= ADA_D;

end architecture rtl;

