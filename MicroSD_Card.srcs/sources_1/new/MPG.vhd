----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/07/2019 04:06:42 PM
-- Design Name: 
-- Module Name: MPG - Behavioral
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

entity MPG is
     Port (Clk: in std_logic;
           Reset: in std_logic;
           Btn: in std_logic;
           BtnOut: out std_logic 
         );
end MPG;

architecture Behavioral of MPG is

signal Q1, Q2, Q3 : std_logic;

begin
--**Insert the following after the 'begin' keyword**
process(Clk)
begin
   if (Clk'event and Clk = '1') then
      if (Reset = '1') then
         Q1 <= '0';
         Q2 <= '0';
         Q3 <= '0';
      else
         Q1 <= Btn;
         Q2 <= Q1;
         Q3 <= Q2;
      end if;
   end if;
end process;

BtnOut <= Q1 and Q2 and (not Q3);

end Behavioral;
