library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity VGA_Controller is
     
    Port (
            W: in integer;
            H: in integer;
            Gen_Clk: in std_logic;
            Sel: in std_logic_vector(1 downto 0);
            Rst: in std_logic;
            R: in std_logic_vector(3 downto 0);
            G: in std_logic_vector(3 downto 0);
            B: in std_logic_vector(3 downto 0);
            HSynch: out std_logic;
            VSynch: out std_logic;
            Red: out std_logic_vector(3 downto 0);
            Green: out std_logic_vector(3 downto 0);
            Blue: out std_logic_vector(3 downto 0)
          );
end VGA_Controller;

architecture Behavioral of VGA_Controller is

signal Cnt: integer :=0;

signal hPos : integer :=0;     --current Vertical Position
signal vPos : integer :=0;     --current Horizontal Position

signal video_on: std_logic :='0';

 signal HD: integer;      --Horizontal Display
 signal HFP: integer;     --Horizontal Front Porch
 signal HSP: integer;       --Horizontal Synch Pulse
 signal HBP: integer;        --Horizontal Back Porch
        
 signal VD: integer;   --Vertical Display
 signal VFP: integer;      --Vertical Front Porch
 signal VSP: integer;       --Vertical Synch Pulse
 signal VBP: integer;   
 
begin
    
    process(Sel)
    begin
        case Sel is 
            when "00" => HD <= 639;       --Horizontal Display
                         HFP <= 16;    --Horizontal Front Porch
                         HSP <= 96;       --Horizontal Synch Pulse
                         HBP <= 48;       --Horizontal Back Porch
     
                        VD <= 479;       --Vertical Display
                        VFP <= 10;       --Vertical Front Porch
                        VSP <= 2;       --Vertical Synch Pulse
                        VBP <= 33;
                        
                       
                         
            when "01" =>  HD <= 767;       --Horizontal Display
                            HFP <= 24;    --Horizontal Front Porch
                            HSP <= 80;       --Horizontal Synch Pulse
                            HBP <= 104;       --Horizontal Back Porch
     
                            VD <= 575;       --Vertical Display
                            VFP <= 1;       --Vertical Front Porch
                            VSP <= 3;       --Vertical Synch Pulse
                            VBP <= 17;
							
			when others =>  HD <= 799;       --Horizontal Display
                            HFP <= 40;    --Horizontal Front Porch
                            HSP <= 128;       --Horizontal Synch Pulse
                            HBP <= 88;       --Horizontal Back Porch
     
                            VD <= 599;       --Vertical Display
                            VFP <= 1;       --Vertical Front Porch
                            VSP <= 4;       --Vertical Synch Pulse
                            VBP <= 23;
							
			

        end case;
     end process;                     
    

    
    --Horizontal position counter 
    process(Gen_Clk, Rst)
    begin 
    if (Rst = '1') then 
        hPos <= 0;
    elsif rising_edge(Gen_Clk) then
          if (hPos = (HD + HFP + HSP + HBP) ) then 
              hPos <= 0;
          else 
              hPos <= hPos +1;
          end if;     
    end if;
    end process;
    
    --Vertical position counter 
    process(Gen_Clk, Rst, hPos)
    begin 
    if (Rst = '1') then 
        vPos <= 0;
    elsif rising_edge(Gen_Clk) then
          if (hPos = (HD + HFP + HSP + HBP) ) then 
              if( vPos = (VD + VFP + VSP + VBP) ) then
                    vPos <= 0;
              else 
                    vPos <= vPos +1;
              end if;     
          end if;
    end if;      
    end process;
    
    --Horizontal synchronization
    process(Gen_Clk, Rst, hPos)
    begin
    if (Rst = '1') then
        HSynch <= '0';
    elsif rising_edge(Gen_Clk) then
          if ( (hPos <= (HD + HFP)) or (hPos > HD + HFP + HSP) ) then 
            HSynch <= '1';
          else 
            HSynch <='0';
          end if;       
    end if;           
    end process;
    
    --Vertical synchronization
    process(Gen_Clk, Rst, vPos)
    begin
    if (Rst = '1') then
        VSynch <= '0';
    elsif rising_edge(Gen_Clk) then
          if ( (vPos <= (VD + VFP)) or (vPos > VD + VFP + VSP) ) then 
            VSynch <= '1';
          else 
            VSynch <='0';
          end if;       
    end if;           
    end process;
    
    --Process to set the drawing signal 
    process(Gen_Clk, Rst, hPos, vPos)
    begin 
    if (Rst ='1') then
        video_on <= '0';
    elsif rising_edge(Gen_Clk) then 
          if (hPos <= HD and vPos <= VD ) then
            video_on <= '1';
          else 
            video_on <= '0';
          end if;
     end if;
     end process;
     
     process(Gen_Clk)
     begin
        if Rst = '1' then 
            Red <= "0000";
            Green <= "0000";
            Blue <= "0000";
        elsif rising_edge(Gen_Clk) then
            if (video_on = '1') then 
                Red <= R;
                Green <= G;
                Blue <= B;
                
            else 
                Red <= "0000";
                Green <= "0000";
                Blue <= "0000";
            
            end if;
         end if;  
         
    end process;        
end Behavioral;
