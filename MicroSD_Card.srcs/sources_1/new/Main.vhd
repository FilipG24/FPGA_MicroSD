----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/07/2019 04:05:39 PM
-- Design Name: 
-- Module Name: Main - Behavioral
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

entity Main is
      Port (Clk: in std_logic;
            Rst: in std_logic;
            Sel: in std_logic_vector(1 downto 0);
            
            SD_MISO: in std_logic;
            SD_MOSI: out std_logic;
            SD_CS: out std_logic;
            SD_CLK: out std_logic;
            SD_Rst: out std_logic;
            
            HSynch: out std_logic;
            VSynch: out std_logic;
            vgaRed: out std_logic_vector(3 downto 0);
            vgaBlue: out std_logic_vector(3 downto 0);
            vgaGreen: out std_logic_vector(3 downto 0)
            );
end Main;

architecture Behavioral of Main is

signal MPG_Out: std_logic;

signal Clk_40: std_logic;
signal Clk_35: std_logic;
signal Clk_25: std_logic;

signal VgaClk: std_logic;

signal W: integer;
signal H: integer;

signal SD_Data: std_logic_vector(7 downto 0);
signal SD_Busy: std_logic;
signal SD_WE: std_logic := '0';
signal SD_Addr: integer := 0;

signal RAM_Data: std_logic_vector(7 downto 0);

signal R: std_logic_vector(3 downto 0);
signal G: std_logic_vector(3 downto 0);
signal B: std_logic_vector(3 downto 0);

begin

MPG_instance: entity WORK.MPG port map(
                    Clk => Clk,
                    Reset => '0',
                    Btn => Rst,
                    BtnOut => MPG_Out
                    );

dut0: entity WORK.rational_divider 
  Generic map ( 
        G_input_clock_mhz  => 100.0,   -- input clock frequency in MHz
        G_output_clock_mhz => 25.0    -- Output clock frequency in MHz (must be less than half input clock)
           )
  Port map ( 
    clk      => Clk,
    rst_sync => Rst,
    tick_out => Clk_25
    ); 
           
dut1: entity WORK.rational_divider 
  Generic map ( 
        G_input_clock_mhz  => 100.0,   -- input clock frequency in MHz
        G_output_clock_mhz => 35.0    -- Output clock frequency in MHz (must be less than half input clock)
           )
  Port map ( 
    clk      => Clk,
    rst_sync => Rst,
    tick_out => Clk_35
    );
    
dut2: entity WORK.rational_divider 
  Generic map ( 
        G_input_clock_mhz  => 100.0,   -- input clock frequency in MHz
        G_output_clock_mhz => 40.0    -- Output clock frequency in MHz (must be less than half input clock)
           )
  Port map ( 
    clk      => Clk,
    rst_sync => Rst,
    tick_out => Clk_40
    ); 
    
process(Sel)
    begin
    case Sel is 
        when "00" => VgaClk <= Clk_25;
                     W <= 640;
                     H <= 480;
        when "01" => VgaClk <= Clk_35;
                       W <= 768;
                       H <= 576;
        when others => VgaClk <= Clk_40;
                     W <= 800;
                     H <= 600;
                                   
    end case;
end process;   

SD_Clk <= Clk_25;

SD_inst: entity WORK.SD_Controller port map(
            Clk => Clk_25,
            MISO => SD_MISO,
            Rst => MPG_Out,
            MOSI => SD_MOSI,
            CS => SD_CS,
            Busy => SD_Busy,
            Data => SD_Data,
            We => SD_WE,
            Addr => SD_Addr
	       );

Mem_inst: entity Work.Memory port map (
               Clk => Clk,
               DataIn => SD_Data,
               Addr => SD_Addr,
               We => SD_WE,
               DataOut => RAM_Data
               );
    
R <= "0" & RAM_Data(7 downto 5);
G <= "0" & RAM_Data(4 downto 2);
B <= "00" & RAM_Data(1 downto 0);

VGA_Controller_instance: entity WORK.VGA_Controller port map(
         W => W,
         H => H,
         Gen_Clk => VgaClk,
         Sel => Sel,
         Rst => MPG_Out,
         R => R,
         G => G,
         B => B,
         HSynch => HSynch,
         VSynch => VSynch,
         Red => vgaRed,
         Green => vgaGreen,
         Blue => vgaBlue
         );
             
end Behavioral;
