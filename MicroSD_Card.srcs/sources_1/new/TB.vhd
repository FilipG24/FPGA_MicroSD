----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/09/2020 03:11:48 PM
-- Design Name: 
-- Module Name: TB - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TB is
--  Port ( );
end TB;

architecture Behavioral of TB is

signal Clk: std_logic := '0';
signal Rst: std_logic;
signal Sel: std_logic_vector(1 downto 0);
            
signal SD_MISO: std_logic;
signal SD_MOSI: std_logic;
signal SD_CS: std_logic;
signal SD_Clk: std_logic := '0';

signal HSynch: std_logic;
signal VSynch: std_logic;
signal vgaRed: std_logic_vector(3 downto 0);
signal vgaBlue: std_logic_vector(3 downto 0);
signal vgaGreen: std_logic_vector(3 downto 0);



begin

DUT: entity WORK.Main port map(
            Clk => Clk,
            Rst => Rst,
            Sel => Sel,
            
            SD_MISO => SD_MISO,
            SD_MOSI => SD_MOSI,
            SD_CS => SD_CS,
            SD_CLK => SD_Clk,
            SD_Rst => Rst,
            
            HSynch => HSynch,
            VSynch => VSynch,
            vgaRed => vgaRed,
            vgaBlue => vgaBlue,
            vgaGreen => vgaGreen
            );

Clk <= not Clk after 5 ns;
SD_Clk <= not SD_Clk after 20 ns;
Rst <= '0';
Sel <= "00";
SD_MISO <= '1', '0' after 20 ns, '1' after 60 ns;
 

end Behavioral;
