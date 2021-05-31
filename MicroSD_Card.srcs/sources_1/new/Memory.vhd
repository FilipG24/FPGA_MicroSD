----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/12/2019 03:38:46 PM
-- Design Name: 
-- Module Name: Memory - Behavioral
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

entity Memory is
        Port (
               Clk: in std_logic;
               DataIn: in std_logic_vector(7 downto 0);
               Addr: in integer RANGE 0 to 640 * 480; 
               We: in std_logic;
               DataOut: out std_logic_vector(7 downto 0)
             );
end Memory;

architecture Behavioral of Memory is

type RAM_type is array ( 0 to 640 * 480 ) of std_logic_vector(7 downto 0);
signal RAM: RAM_type := (others => X"FF");

begin

process(Clk)
begin 
    if rising_edge(Clk) then 
        if WE = '1' then 
            RAM(Addr) <= DataIn;
        else 
            DataOut <= RAM(Addr);
        end if;
    end if;
end process;
                
end Behavioral;
