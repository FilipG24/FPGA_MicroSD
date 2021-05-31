library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.Command_Package.ALL;

entity SD_Controller is
    Port
	(
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
end entity;

architecture Behavioral of SD_Controller is

--signals for FSM
type state is (INIT, COMMAND_STATE, READ_START, READ_IMAGE_START, READ8, READ40,
               READ_IMAGE, WAIT_STATE, DONE, IDLE);
signal prState: state := INIT;
signal nextState: state := INIT;
signal prCmd: integer RANGE 0 to 4 := 0;
signal nextCmd: integer RANGE 0 to 4 :=0;
signal ready: std_logic;
signal dataTemp: std_logic_vector(7 downto 0);

--Time related declarations
constant INIT_TIME: natural := 100;
constant COMMAND_TIME: natural := 48;
constant WAIT_TIME: natural := 8;
constant READ8_TIME: natural := 8;
constant READ40_TIME: natural := 40;
constant READ_IMAGE_TIME: natural := 512 * 8;
signal t: natural RANGE 0 to READ_IMAGE_TIME := 0;

--Signals for memory 
signal prAddr: integer RANGE 0 to 640 * 480 := 0;
signal nextAddr: integer RANGE 0 to 640 * 480 := 0;
signal prBlockAddr: std_logic_vector(31 downto 0) := "00000000000000000111011011100110";
signal nextBlockAddr: std_logic_vector(31 downto 0) := "00000000000000000111011011100110";
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
	MOSI <= '1';
	CS <= '0';
	Busy <= '1';
	nextCmd <= prCmd;
	nextAddr <= prAddr;
	nextBlockAddr <= prBlockAddr;
    WE <= '0';
   
    case prState is 
		-- At power up, the SD card needs time to set up before it can begin
		-- to accept commands. Therefore, the state machine stays in the INIT
		-- state with the MOSI and CS lines held high for a few clock cycles
		-- (at least 74 according to the specs) before beginning to send 
		-- commands.
        when INIT => MOSI <= '1';
                     CS <= '1';
		             if t >= INIT_TIME then 
                        nextState <= COMMAND_STATE;
					else
                        nextState <= INIT;
                    end if;
                           
		-- In the command state, the bit pattern for the current command to be
		-- sent is retrieved using the retrieveCommandBits function defined
		-- in the command package. Each bit is then sent over the MOSI line.
		when COMMAND_STATE => 
		    CS <= '0';
            if prCmd = 4 then 
                command := retrieveCommandBits(prCmd) and ("11111111" & prBlockAddr & "11111111");
            else 
                command := retrieveCommandBits(prCmd);
            end if;
            
            if COMMAND_TIME - t /= 0 then 
                MOSI <= command(COMMAND_TIME - t - 1);
                nextState <= COMMAND_STATE;
            else
                nextState <= READ_START;
            end if;
        
		-- The SD card keeps the MISO line high when it's not sending data. So
		-- only start reading data when the MISO line is pulled low.
        when READ_START => 
            if MISO = '1' then 
                nextState <= READ_START;
            else 
                case prCmd is 
                    when 1 => nextState <= READ40;
                    when others => nextState <= READ8;
                end case;
            end if;	
						
		
		-- The SD card responds to some commands with 8-bit replies and to
		-- others with 40-bit replies. The machine goes to this state if it is
		-- expecting the SD card to send an 8-bit reply...			
		when READ8 =>
			if READ8_TIME - t - 1 /= 0 then 
				ErrorCheck <= ErrorCheck(6 downto 0) & MISO;
                nextState <= READ8;
				
            elsif ErrorCheck = "00000001" then 
                nextState <= WAIT_STATE; 
            else 
                nextState <= INIT;
            end if;
            
        when READ40 => 
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

		-- When a read command is sent to the SD card, the SD card will often
		-- send back garbage before it begins to send back actual data. So we
		-- need to wait for the pattern (11111110) before we start accepting
		-- data. This pattern signals the beginning of a 512-byte package.
        when READ_IMAGE_START => 
             if dataTemp = "11111110" then 
                nextState <= READ_IMAGE;
             else
                nextState <= READ_IMAGE_START;
             end if;      

		--Read 512 bytes from the SD card, composing 512 pixels of the
		-- image. After each byte, set the Write Enable flag and the increment
		-- the address so that the byte can be stored in block memory. 
        when READ_IMAGE => 
            if READ_IMAGE_TIME - t - 1 /= 0 then
                if ( t MOD 8 ) + 1 = 8 then 
                    WE <= '1'; 
                    nextAddr <= prAddr + 1;
				else
					WE <= '0';	
                end if;
                nextState <= READ_IMAGE;    
            else
                nextState <= WAIT_STATE;
            end if;
                            
        -- After each command is sent and a reply is received, we need to wait
		-- for a few clock cycles before the SD card is ready to accept
		-- commands again.
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
                when 3 => if ready = '1' then 
                            nextCmd <= 2;
                          else
                            nextCmd <= 4;
                          end if;
                          nextState <= COMMAND_STATE;                                              
                when others => nextCmd <= 2;
                               nextState <= DONE;
                end case;                
            end if;
      
        -- After each 512-byte block has been read, check to make sure if we
		-- have read in all 640x480 pixels. If we have, we are all done.
		-- Otherwise, read in the next block.
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
   end process; 
 
data <= dataTemp;   

end Behavioral;
