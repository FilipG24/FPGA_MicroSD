Library UNISIM;
use UNISIM.vcomponents.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity rational_divider is
  Generic ( 
        G_input_clock_mhz       : real := 100.0;     -- input clock frequency in MHz
        G_output_clock_mhz      : real := 0.0;       -- Output clock frequency in MHz (must be less than or equal to half the input clock frequency)
        G_output_interval_ns    : real := 0.0;       -- Alternate parameter for output tick interval in ns.  G_output_clock_mhz must be 0.0 if this is used!
        G_max_accum_bits        : natural := 24;     -- If set higher then 24 bits, best to simulate to verify that the numerator/denominator pair are satisfactory.
        G_one_shot              : boolean := false;  -- If true, only one output pulse is produced after each reset.
        G_use_dsp48             : boolean := false;  -- Will use G_max_accum_bits fabric accumulator (or shorter) if false, 48 bit DSP48E1 if true
        G_alt_multiply          : unsigned(47 downto 0) := (others => '0');   -- Alternate parameter to directly specify the multiplier, only used if non-zero
        G_alt_divide            : unsigned(47 downto 0) := (others => '0')    -- Alternate parameter to directly specify the divider, only used if non-zero (both must be used!)
        );
  Port ( 
    clk         : in std_logic;         -- global input clock from a clock buffer.   Connect it to a local clock at your own peril.
    clk_en      : in std_logic := '1';  -- pro-forma clock enable
    rst_sync    : in std_logic := '0';  -- synchronous reset with priority over the clock enable.
    tick_out    : out std_logic := '0'  -- clock tick signal usable in the input clock domain.  This is a single cycle pulse at the desired AVERAGE frequency.  There will be JITTER.
  );                         -- the output SHOULD NOT be connected to a clock buffer, unless you know how to use a BUFGCE and multicycle constraints.
end rational_divider;        -- The output is intended as a clock enable for sub-circuits that need to run at a fractional rate of the global clock.
                             -- it can also be used as a timer tick with a precise AVERAGE interval.  There will be jitter, of course.

architecture Behavioral of rational_divider is

function ulogb2( i : unsigned ) return natural is  -- calculate log2 of unsigned number.. could be more than 32!
    variable temp    : unsigned(i'range) := i;
    variable ret_val : natural := 1;
begin
    while temp /= 0 loop
        ret_val := ret_val + 1;
        temp    := shift_right(temp,1);
    end loop;  
    assert FALSE report "rational_divider: Accumulator length is " & integer'image(ret_val) severity NOTE;
    return ret_val;
end function;

type ratio_vector is array(natural range <>) of unsigned(63 downto 0);

-- search the Stern-Brocot tree for the best rational approximation
-- The ratio of Fout/Fin should be in the range of (0.0,0.5] but not equal to 0  
function rat_approx( Fin, Fout, Tint : real; u,v : unsigned(47 downto 0); flag : boolean ) return ratio_vector is
   constant mt : unsigned(63 downto 0) := (G_max_accum_bits-1 => '1', others => '0');
   constant md : unsigned(63 downto 0) := mt - 1;
   variable f, f2  : real;
   variable h  : ratio_vector(0 to 2) := ( (others => '0'), (0=>'1',others=>'0'), (others =>'0'));
   variable k  : ratio_vector(0 to 2) := ( (0=>'1',others => '0'), (others=>'0'), (others =>'0'));
   variable a, x, d, n  : unsigned(md'range) := (0=>'1', others => '0');
   variable ret_val : ratio_vector(0 to 1);
   variable i : integer := 0;
begin
    assert G_max_accum_bits < 55 report "G_max_accum_bits exceeds internal precision available." severity ERROR;
    if u /= 0 and v /= 0 then  -- user manually specified the numerator and denominator
        ret_val := ( resize(u,64), resize(v,64) );  -- return numerator u and denominator v
        return ret_val;        
    end if;
    assert Fout /= 0.0 or Tint /= 0.0 report "You forgot to specify either G_output_clock_mhz OR G_output_interval_ns!  Pick One!" severity ERROR;
    if Fout = 0.0 then
        f := 1.0E3/Tint/Fin;        -- user wants to specify a tick interval.. 
    else
        f := Fout/Fin;              -- user specified an output frequency.   No problem.
    end if;
    assert f > 0.0 and f <= 0.5 report "Output/Input Ratio must be nonzero AND <= 0.5!!!  You have a ratio of " & real'image(f) severity ERROR;
    f2 := f; d := (others => '0');
    while f /= floor(f) loop
        f   := 2.0 * f;
        f2  := 2.0 * f2;
        n   := shift_left(n,1);
        d   := shift_left(d,1);
        if f2 >= 1.0 then   -- convert f2 to integer d
            f2  := f2 - 1.0;
            d   := d + 1;   -- this conversion limited to about 54 bits (IEEE double precision mantissa) for synthesis in Vivado 2017.x+
        end if; 
    end loop;
    if G_use_dsp48 then -- terminate early then, after normalizing to a 48 bit denominator.
        i := ulogb2(n);
        if i < 51 then
            n := shift_left(n,50 - i);
            d := shift_left(d,50 - i);
        else
            n := shift_right(n,i - 50);
            d := shift_right(d,i - 50);
        end if;
        ret_val := ( n , d);
        return ret_val;
    end if;
    while i < 64 loop       -- This code uses 64 bit unsigned types for computation.
        if n = 0 then
            a := (others => '0');
        else
            a := d / n;
        end if;
        if i /= 0 and a=0 then
            exit;
        end if;
        x := d; d := n; n := x mod n;
        x := a;
        if ( k(1) * a + k(0) >= md ) then
            x := (md - k(0))/k(1);
            if (x * 2 > a or k(1) > md) then
                i := 65;
            else
                exit;
            end if;
        end if;
        h(2) := resize(x * h(1) + h(0),md'length);  h(0) := h(1); h(1) := h(2);
        k(2) := resize(x * k(1) + k(0),md'length);  k(0) := k(1); k(1) := k(2);    
        i := i + 1;      
    end loop;
    assert k(1) /= 0 report "rational_divider: Addition constant is 0! Try fewer bits." severity ERROR;
    assert h(1) /= 0 report "rational_divider: Subtraction constant is 0!  Try fewer bits." severity ERROR;
    ret_val := ( h(1), k(1) );  -- return numerator h(1) and denominator k(1)
    return ret_val;
end function;

constant ratio : ratio_vector(0 to 1) := rat_approx(G_input_clock_mhz, G_output_clock_mhz, G_output_interval_ns, G_alt_multiply, G_alt_divide, G_use_dsp48 );
signal one_shot  : std_logic := '0';

begin
g0: if not G_use_dsp48 generate
    constant c_acc_len : natural := ulogb2(ratio(1));   -- ratio(1) is always larger than ratio(0)
    signal accum : unsigned(c_acc_len-1 downto 0) := (others => '0');
    attribute use_dsp : string;
    attribute use_dsp of accum : signal is "no";
begin
    process(clk) is
    begin
    if rising_edge(clk) then
        if rst_sync = '1' then
            accum <= resize(ratio(1),c_acc_len) - resize(2 * ratio(0),c_acc_len); -- a reset will start a new cycle
            tick_out <= '0';
            one_shot <= '0';
        elsif clk_en = '1' then
            if accum(accum'left)='1' then
                one_shot <= '1';
                accum <= accum + resize(ratio(1),c_acc_len) - resize( ratio(0),c_acc_len);  -- use a ternary adder/subtractor
            else
                accum <= accum - resize(ratio(0),c_acc_len);
            end if;
            if G_one_shot then
                tick_out <= accum(accum'left) and not one_shot;  -- provide an output register so physical synthesis has something easy to replicate in case of high fanout
            else
                tick_out <= accum(accum'left);  -- provide an output register so physical synthesis has something easy to replicate in case of high fanout
            end if;
        end if;    
    end if;
    end process;
end generate g0;

-- Attempts to generate a properly configured DSP48E1 with behavioral code have failed, so here we resort to primitive instantiation.
-- We can't use the add/subtract model like the fabric, so here we resort to a simple 48 bit accumulation, taking the tick_out from the carry output.
-- the numerator of the division is effectively fixed at 2**48
g1: if G_use_dsp48 generate
    signal accum: std_logic_vector(47 downto 0);
    signal a : std_logic_vector(29 downto 0);
    signal b : std_logic_vector(17 downto 0);
    signal c : std_logic_vector(47 downto 0);
    signal opmode : std_logic_vector(6 downto 0);
    signal carry  : std_logic_vector(3 downto 0);
begin    
   a <=  std_logic_vector( ratio(1)(47 downto 18) ); 
   b <=  std_logic_vector( ratio(1)(17 downto  0) );
   opmode <= '0' & not rst_sync & '0' & rst_sync & rst_sync & "11";
   c <= std_logic_vector( resize( 3 * ratio(1)(47 downto 0),48) );
   
   DSP48E1_inst : DSP48E1
   generic map (
      -- Feature Control Attributes: Data Path Selection
      A_INPUT => "DIRECT",               -- Selects A input source, "DIRECT" (A port) or "CASCADE" (ACIN port)
      B_INPUT => "DIRECT",               -- Selects B input source, "DIRECT" (B port) or "CASCADE" (BCIN port)
      USE_DPORT => FALSE,                -- Select D port usage (TRUE or FALSE)
      USE_MULT => "NONE",                -- Select multiplier usage ("MULTIPLY", "DYNAMIC", or "NONE")
      USE_SIMD => "ONE48",               -- SIMD selection ("ONE48", "TWO24", "FOUR12")
      -- Pattern Detector Attributes: Pattern Detection Configuration
      AUTORESET_PATDET => "NO_RESET",    -- "NO_RESET", "RESET_MATCH", "RESET_NOT_MATCH" 
      MASK => X"3fffffffffff",           -- 48-bit mask value for pattern detect (1=ignore)
      PATTERN => X"000000000000",        -- 48-bit pattern match for pattern detect
      SEL_MASK => "MASK",                -- "C", "MASK", "ROUNDING_MODE1", "ROUNDING_MODE2" 
      SEL_PATTERN => "PATTERN",          -- Select pattern value ("PATTERN" or "C")
      USE_PATTERN_DETECT => "NO_PATDET", -- Enable pattern detect ("PATDET" or "NO_PATDET")
      -- Register Control Attributes: Pipeline Register Configuration
      ACASCREG => 0,                     -- Number of pipeline stages between A/ACIN and ACOUT (0, 1 or 2)
      ADREG => 0,                        -- Number of pipeline stages for pre-adder (0 or 1)
      ALUMODEREG => 0,                   -- Number of pipeline stages for ALUMODE (0 or 1)
      AREG => 0,                         -- Number of pipeline stages for A (0, 1 or 2)
      BCASCREG => 0,                     -- Number of pipeline stages between B/BCIN and BCOUT (0, 1 or 2)
      BREG => 0,                         -- Number of pipeline stages for B (0, 1 or 2)
      CARRYINREG => 0,                   -- Number of pipeline stages for CARRYIN (0 or 1)
      CARRYINSELREG => 0,                -- Number of pipeline stages for CARRYINSEL (0 or 1)
      CREG => 0,                         -- Number of pipeline stages for C (0 or 1)
      DREG => 0,                         -- Number of pipeline stages for D (0 or 1)
      INMODEREG => 0,                    -- Number of pipeline stages for INMODE (0 or 1)
      MREG => 0,                         -- Number of multiplier pipeline stages (0 or 1)
      OPMODEREG => 1,                    -- Number of pipeline stages for OPMODE (0 or 1)
      PREG => 1                          -- Number of pipeline stages for P (0 or 1)
   )
   port map (
      -- Cascade: 30-bit (each) output: Cascade Ports
      ACOUT => open,                   -- 30-bit output: A port cascade output
      BCOUT => open,                   -- 18-bit output: B port cascade output
      CARRYCASCOUT => open,            -- 1-bit output: Cascade carry output
      MULTSIGNOUT => open,             -- 1-bit output: Multiplier sign cascade output
      PCOUT => open,                   -- 48-bit output: Cascade output
      -- Control: 1-bit (each) output: Control Inputs/Status Bits
      OVERFLOW => open,             -- 1-bit output: Overflow in add/acc output
      PATTERNBDETECT => open, -- 1-bit output: Pattern bar detect output
      PATTERNDETECT => open,   -- 1-bit output: Pattern detect output
      UNDERFLOW => open,           -- 1-bit output: Underflow in add/acc output
      -- Data: 4-bit (each) output: Data Ports
      CARRYOUT => carry,             -- 4-bit output: Carry output
      P => accum,                   -- 48-bit output: Primary data output
      -- Cascade: 30-bit (each) input: Cascade Ports
      ACIN => (others =>'0'),                     -- 30-bit input: A cascade data input
      BCIN => (others =>'0'),                     -- 18-bit input: B cascade input
      CARRYCASCIN => '0',       -- 1-bit input: Cascade carry input
      MULTSIGNIN => '0',         -- 1-bit input: Multiplier sign input
      PCIN => (others =>'0'),                     -- 48-bit input: P cascade input
      -- Control: 4-bit (each) input: Control Inputs/Status Bits
      ALUMODE => "0000",               -- 4-bit input: ALU control input
      CARRYINSEL => "000",         -- 3-bit input: Carry select input
      CLK => clk,                       -- 1-bit input: Clock input
      INMODE => (others => '0'),                 -- 5-bit input: INMODE control input
      OPMODE => opmode,                 -- 7-bit input: Operation mode input
      -- Data: 30-bit (each) input: Data Ports
      A => A,                           -- 30-bit input: A data input
      B => B,                           -- 18-bit input: B data input
      C => C,                           -- 48-bit input: C data input
      CARRYIN => '0',               -- 1-bit input: Carry input signal
      D => (others =>'0'),                           -- 25-bit input: D data input
      -- Reset/Clock Enable: 1-bit (each) input: Reset/Clock Enable Inputs
      CEA1 => '1',                     -- 1-bit input: Clock enable input for 1st stage AREG
      CEA2 => '1',                     -- 1-bit input: Clock enable input for 2nd stage AREG
      CEAD => '1',                     -- 1-bit input: Clock enable input for ADREG
      CEALUMODE => '1',                -- 1-bit input: Clock enable input for ALUMODE
      CEB1 => '1',                     -- 1-bit input: Clock enable input for 1st stage BREG
      CEB2 => '1',                     -- 1-bit input: Clock enable input for 2nd stage BREG
      CEC => '1',                      -- 1-bit input: Clock enable input for CREG
      CECARRYIN => '1',                -- 1-bit input: Clock enable input for CARRYINREG
      CECTRL => '1',                   -- 1-bit input: Clock enable input for OPMODEREG and CARRYINSELREG
      CED => '1',                      -- 1-bit input: Clock enable input for DREG
      CEINMODE => '1',                 -- 1-bit input: Clock enable input for INMODEREG
      CEM => '1',                      -- 1-bit input: Clock enable input for MREG
      CEP => clk_en,                   -- 1-bit input: Clock enable input for PREG
      RSTA => '0',                     -- 1-bit input: Reset input for AREG
      RSTALLCARRYIN => '0',            -- 1-bit input: Reset input for CARRYINREG
      RSTALUMODE => '0',               -- 1-bit input: Reset input for ALUMODEREG
      RSTB => '0',                     -- 1-bit input: Reset input for BREG
      RSTC => '0',                     -- 1-bit input: Reset input for CREG
      RSTCTRL => '0',                  -- 1-bit input: Reset input for OPMODEREG and CARRYINSELREG
      RSTD => '0',                     -- 1-bit input: Reset input for DREG and ADREG
      RSTINMODE => '0',                -- 1-bit input: Reset input for INMODEREG
      RSTM => '0',                     -- 1-bit input: Reset input for MREG
      RSTP => '0'                 -- 1-bit input: Reset input for PREG
   );
   
    process(clk) is
    begin
    if rising_edge(clk) then
        if rst_sync = '1' then
            one_shot <= '0';
            tick_out <= '0';
        elsif clk_en = '1' then
            one_shot <= one_shot or carry(3);
            if G_one_shot then
                tick_out <= carry(3) and not one_shot;
            else
                tick_out <= carry(3);
            end if;
        end if;    
    end if;
    end process;   
   
end generate g1;

end Behavioral;