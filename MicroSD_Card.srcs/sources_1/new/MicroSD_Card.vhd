----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/11/2019 05:20:01 PM
-- Design Name: 
-- Module Name: MicroSD_Card - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use WORK.Commands_Package.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MicroSD_Card is
     Port (
            Clk: in std_logic;
            MISO: in std_logic;
            Rst: in std_logic;
            MOSI: out std_logic;
            CS: out std_logic;
            Busy: out std_logic;
            Data: out std_logic_vector(7 downto 0);
            We: out std_logic;
            Addr: out integer RANGE 0 to 640 * 480
     
      );
end MicroSD_Card;

architecture Behavioral of MicroSD_Card is

--signals for FSM
type state is (INIT, COMMAND_STATE, READ_START, READ_IMAGE_START, READ8, READ40,
               READ_IMAGE, WAIT_STATE, DONE, IDLE);
signal prState: state :=INIT;
signal nextState: state :=INIT;
signal prCmd: integer RANGE 0 to 4 := 0;
signal nextCmd: integer RANGE 0 to 4 :=0;
signal ready: std_logic;
signal dataTemp: std_logic_vector(7 downto 0);

--Time related declarations
constant INIT_TIME: natural := 100;
constant COMMAND_TIME: natural :=48;
constant WAIT_TIME: natural := 8;
constant READ8_TIME: natural := 8;
constant READ40_TIME: natural := 40;
constant READ_IMAGE_TIME: natural := 512 * 8;
signal t: natural RANGE 0 to READ_IMAGE_TIME := 0;

--Signals for memory 
signal prAddr: integer RANGE 0 to 640 * 480 := 0;
signal nextAddr: integer RANGE 0 to 640 * 480 := 0;
signal prBlockAddr: std_logic_vector(31 downto 0) := "00000000000000000111011011100110";
signal nextBlockAddr: std_logic_vector(31 downto 0) :="00000000000000000111011011100110";

--Commands 
constant CMD0: std_logic_vector(47 downto 0) := "010000000000000000000000000000000000000010010101";
constant CMD8: std_logic_vector(47 downto 0) := "010010000000000000000000000000011010101010000111";
constant CMD55: std_logic_vector(47 downto 0) := "011101110000000000000000000000000000000000000001";
constant ACMD41: std_logic_vector(47 downto 0) := "011010010100000000000000000000000000000000000001";
constant CMD17: std_logic_vector(47 downto 0) := "010100011111111111111111111111111111111100000001";

signal ErrorCheck: std_logic_vector(7 downto 0) := "00000000";

begin

Addr <= prAddr;

--Timer 
process(Clk, Rst)
begin 
    if Rst = '1' then 
        t <= 0;
    elsif rising_edge(Clk) then
        if prState /= nextState then 
            t <= 0;
        elsif t /= READ_IMAGE_TIME then 
            t <= t + 1;
        end if;
    end if;
end process;  

--State register
process(Clk, Rst)
begin 
    if Rst = '1' then 
        prState <= INIT;
        prCmd <= 0;
        prAddr <= 0;
        prBlockAddr <= "00000000000000000111011011100110";
    elsif rising_edge(clk) then 
        prState <= nextState;
        prCmd <= nextCmd;
        prAddr <= nextAddr;
        prBlockAddr <= nextBlockAddr;
        dataTemp <= dataTemp(6 downto 0) & MISO;
    end if;
end process;

--Combinational logic
process(Clk, Rst, MISO)
variable command: std_logic_vector(47 downto 0);
begin
   
    
    case prState is 
        when INIT => MOSI <= '1';
                     CS <= '1';
					 WE <= '0';
					 Busy <= '1';
					 
                    if t >= INIT_TIME then 
                        nextState <= COMMAND_STATE;
						
                     else
                        nextState <= INIT;
                    end if;
                           
		
		when COMMAND_STATE => 
		    CS <= '0';
            if prCmd = 4 then 
                command := retriveCommandBits(prCmd) AND ("11111111" & prBlockAddr & "11111111");
            else 
                command := retrieveCommandBits(prCmd);
            end if;
            
            if COMMAND_TIME - t /= 0 then 
                MOSI <= command(COMMAND_TIME - t - 1);
                nextState <= COMMAND_STATE;
            else
                nextState <= READ_START;
            end if;
                     
        when READ_START => 
            if MISO = '1' then 
                nextState <= READ_START;
            else 
                case prCmd is 
                    when 1 => nextState <= READ40;
                    when others => nextState <= READ8;
                end case;
            end if;	
						
		
					
		when READ8 =>
			MOSI <= '1';
			CS <= '0';
            if READ8_TIME - t - 1 /= 0 then 
				ErrorCheck <= ErrorCheck(6 downto 0) & MISO;
                nextState <= READ8;
				
            elsif ErrorCheck = "00000001" then 
                nextState <= WAIT_STATE; 
            else 
                nextState <= INIT;
            end if;
            
        when READ40 => 
			MOSI <= '1';
			CS <= '0';
            if READ40_TIME - t - 1 /= 0 then
								if t <= 38 and t >= 32 then
								ErrorCheck <= ErrorCheck(6 downto 0) & MISO;
								end if;
								nextState <= READ40;
            elsif ErrorCheck = "00000001" then 
					nextState <= WAIT_STATE; 
			else 
				nextState <= INIT;
			end if;    

        when READ_IMAGE_START => 
             if dataTemp = "11111110" then 
                nextState <= READ_IMAGE;
             else
                nextState <= READ_IMAGE_START;
             end if;      

        when READ_IMAGE => 
            if READ_IMAGE_TIME - t - 1 /= 0 then
                if ( t MOD 8 ) + 1 = 8 then 
                    WE <= '1'; 
                    nextAddr <= prAddr + 1;
                end if;
                nextState <= READ_IMAGE;    
            else
                nextState <= WAIT_STATE;
            end if;
                            
        when WAIT_STATE => 
            if WAIT_TIME - t /= 0 then
                nextState <= WAIT_STATE;
            else
                case prCmd is 
                when 0 => nextCmd <= 1;
                          nextState <= COMMAND_STATE;
                when 1 => nextCmd <= 2;
                          nextState <= COMMAND_STATE;
                when 2 => nextCmd <= 2;
                          nextState <= COMMAND_STATE;
                when 3 => if ready /= '0' then 
                            nextCmd <= 2;
                          else
                            nextCmd <= 4;
                          end if;
                          nextState <= COMMAND_STATE;                                              
                when others => nextCmd <= 2;
                               nextState <= DONE;
                end case;                
            end if;
      
        when DONE => 
            if prAddr /= 640 * 480 then 
                nextBlockAddr <= STD_LOGIC_VECTOR(TO_UNSIGNED(TO_INTEGER(UNSIGNED(prBlockAddr)) + 1, 32));
                nextState <= COMMAND_STATE;
            else
                nextState <= IDLE;
            end if;
        
        when others => busy <= '0';
                       nextState <= IDLE;
                                                       
    end case;
 
data <= dataTemp;   

end Behavioral;
