-- ----------------------------------------------------------------
-- alu.vhd
--
-- 4/30/2017
--
-- alu
--
-- ----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library lpm;
use lpm.all;

entity alu is
	generic( IWIDTH : natural := 16;
				OWIDTH : natural := 16);
    
	 port( opcode : in  std_logic_vector(11 downto 0);
			 
			 a, b   : in  std_logic_vector(IWIDTH -1 downto 0);	       
			 
			 flags  : out std_logic_vector(3 downto 0);
			 
			 compout: out std_logic_vector(6 downto 0);
	       y      : out std_logic_vector(OWIDTH -1 downto 0));
end alu;

architecture beh of alu is

	-- ------------------------------------------------------------
	-- components
	-- ------------------------------------------------------------

	component lpm_clshift is
										generic( lpm_width		: natural;
													lpm_widthdist	: natural;
													lpm_shifttype	: string);
													
										port(	data		: in std_logic_vector (lpm_width downto 0);
												distance	: in std_logic_vector (lpm_widthdist downto 0);
												direction: in std_logic;												
												result	: out std_logic_vector (lpm_width downto 0));
										end component;
	
--	component lpm_divide	
--										generic (lpm_widthn					: natural;
--													lpm_widthd					: natural;
--													lpm_nrepresentation		: string;
--													lpm_drepresentation		: string);
--										
--										port (numer		: in  std_logic_vector (lpm_widthn downto 0);
--												denom		: in  std_logic_vector (lpm_widthd downto 0);												
--												quotient	: out std_logic_vector (lpm_widthn downto 0);
--												remain	: out std_logic_vector (lpm_widthd downto 0));
--										end component;
	
	-- ----------------------------------------------------------------
	-- internal signals
	-- ----------------------------------------------------------------

	-- signed versions of inputs
	signal a_sig, b_sig : signed(IWIDTH -1 downto 0);
--	signal multi_res    : signed((OWIDTH *2) -1 downto 0);
	
	-- signed version of output carry extended
	signal add_res 	: std_logic_vector(OWIDTH downto 0);
	signal sub_res 	: std_logic_vector(OWIDTH downto 0);
		
	signal inc_res 	: std_logic_vector(OWIDTH downto 0);
	signal dec_res 	: std_logic_vector(OWIDTH downto 0);
	
	-- flag bit
	signal c_bit  		: std_logic;
	signal ov_bit	 	: std_logic;
	signal zr_bit	 	: std_logic;
--	signal par_bit	 	: std_logic;

	signal comp 		: std_logic_vector(6 downto 0);
		
	--shift register signals
	signal ashft_res  : std_logic_vector(OWIDTH -1 downto 0);	
	signal lshft_res  : std_logic_vector(OWIDTH -1 downto 0);
--	signal rshft_res  : std_logic_vector(OWIDTH -1 downto 0);

	--division signals
--	signal rot_ovf		: std_logic;
--	signal quot_res	: std_logic_vector (OWIDTH -1 downto 0);
--	signal rem_res		: std_logic_vector (OWIDTH -1 downto 0);
	
	--convert std to integer for opcode;
	signal sel     	: natural range 0 to 15;	
	
	constant inc_value : signed(IWIDTH downto 0) := "00000000000000001";
	constant dec_value : signed(IWIDTH downto 0) := "00000000000000001";
	-- ----------------------------------------------------------------
	-- enumerate selection
	-- ----------------------------------------------------------------
	
	-- comparator enum
	type enumsel is (eqz, eql, grt, gre, lss, lse, sgn); -- remove gre lse sgn and concatenate flags
	-- instrs enum
	type instr is(add, sub, l_or, l_and, l_not, l_xor, inc, dec, ashf, lshf); --rshf, mul, div, mdls, bcd_add, bcd_sub
	--					0    1     2      3     4      5     6     7   8     9    10    11    12    13        14     15
	-- ----------------------------------------------------------------
	-- all zeros function
	-- ----------------------------------------------------------------
	
	function allzero(input : signed(IWIDTH downto 0)) return std_logic is
		variable temp   : signed(IWIDTH downto 0);
	begin
		temp(0) := input(0);
		for i in 1 to input'high loop
			temp(i) := temp(i -1) or input(i);
		end loop;
		return not temp(temp'high);
	end function allzero;

--	function parity(input : std_logic_vector(IWIDTH -1 downto 0)) return std_logic is
--		variable temp   : std_logic_vector(IWIDTH -1 downto 0);
--	begin
--		temp(0) := input(0);
--		for i in 1 to input'high loop
--			temp(i) := temp(i -1) xor input(i);
--		end loop;
--		return temp(temp'high);
--	end function parity;		

begin
	-- ------------------------------------------------------------
	-- component instanciation
	-- ------------------------------------------------------------
	
	-- ------------------------------------------------------------
	--The sign bit is extended for "arithmetic" right shifts. 				 

	arith_shift : lpm_clshift
										generic map (lpm_width 			=> IWIDTH,
														 lpm_widthdist 	=> (IWIDTH /4),
														 lpm_shifttype		=> "ARITHMETIC")
										
										port map (data 		=> a,
													 distance 	=> opcode(3 downto 0),
													 direction 	=> opcode(8),													 
													 result 		=> ashft_res);
				 
	-- ------------------------------------------------------------				 
	--For a "LOGICAL"  right shift, 0s are always shifted into the MSB or LSB.
		
	logical_shift : lpm_clshift
										generic map (lpm_width 			=> IWIDTH,
														 lpm_widthdist 	=> (IWIDTH /4),
														 lpm_shifttype		=> "LOGICAL")
										
										port map (data 		=> a,
													 distance 	=> opcode(3 downto 0),
													 direction 	=> opcode(8),													 
													 result 		=> lshft_res);
				 
--	-- ------------------------------------------------------------				
--	--Rotate 
--	
--	rotate_shift : lpm_clshift
--										generic map (lpm_width 			=> IWIDTH ,
--														 lpm_widthdist 	=> (IWIDTH /4),
--														 lpm_shifttype		=> "ROTATE")
--										
--										port map (data 		=> a,
--													 distance 	=> opcode(3 downto 0),
--													 direction 	=> opcode(8),													 
--													 result 		=> rshft_res);
				 
	-- ------------------------------------------------------------	
	--divide
	
--	lpm_divide_component : lpm_divide
--										generic map(lpm_widthn 				=> IWIDTH,
--														lpm_widthd 				=> IWIDTH,
--														lpm_nrepresentation 	=> "SIGNED",
--														lpm_drepresentation 	=> "SIGNED")
--														
--										port map(numer 	=> a,
--													denom 	=> b,				
--													quotient => quot_res,
--													remain 	=> rem_res);
				 
				 
	-- ----------------------------------------------------------------
	-- inputs
	-- ----------------------------------------------------------------
	
	sel <= to_integer(unsigned(opcode(7 downto 4)));
		
	-- converted to signed
	a_sig <= signed(a);
	b_sig <= signed(b);
	
	-- ----------------------------------------------------------------
	-- input conditions
	-- ----------------------------------------------------------------
	
	
	-- ----------------------------------------------------------------
	-- combinatorial multiplication
	-- ----------------------------------------------------------------
	
--	multi_res <= resize(a_sig, OWIDTH) * resize(b_sig, OWIDTH);
	
	-- ----------------------------------------------------------------
	-- combinatorial compare
	-- ----------------------------------------------------------------	

	comp(enumsel'pos(eqz)) <= '1' when allzero('0' & a_sig) = '1' else '0';	
	comp(enumsel'pos(eql)) <= '1' when a_sig = b_sig else '0';
	
	comp(enumsel'pos(grt)) <= '1' when a_sig > b_sig else '0';	
	comp(enumsel'pos(gre)) <= comp(enumsel'pos(grt)) or comp(enumsel'pos(eql));
	
	comp(enumsel'pos(lss)) <= '1' when a_sig < b_sig else '0';
	comp(enumsel'pos(lse)) <= comp(enumsel'pos(lss)) or comp(enumsel'pos(eql));
		
	comp(enumsel'pos(sgn)) <= '1' when a_sig(IWIDTH -1) = '1' else '0';
	
	-- ------------------------------------------------------------
	-- Combinatorial add/sub/inc/dec
	-- ------------------------------------------------------------

	-- VHDL-2008 is ok with this
	--	result <= resize(a_sig, IWIDTH+1) + resize(b_sig, IWIDTH+1) + cin;
	-- Old syntax needs to convert cin to a multi-bit signal, first need to make it an unsigned 1.
	add_res <= std_logic_vector(('0' & a_sig) + ('0' & b_sig));
	sub_res <= std_logic_vector(('0' & a_sig) - ('0' & b_sig));
	
	inc_res <= std_logic_vector(('0' & a_sig) + inc_value);
	dec_res <= std_logic_vector(('0' & a_sig) - dec_value);
	
	-- ------------------------------------------------------------
	-- Group carry outs
	-- ------------------------------------------------------------
	with sel select
	c_bit 	<= add_res(OWIDTH) when instr'pos(add),
					sub_res(OWIDTH) when instr'pos(sub),
					inc_res(OWIDTH) when instr'pos(inc),
					dec_res(OWIDTH) when instr'pos(dec),
					'0' when others;
	
	--> When we add two positive parameters, we expect the result to be positive, otherwise we have overflow.
	--> When we add two negative parameters, we expect the result to be negative, otherwise we have overflow.
	--> When we subtract two parameters (the first parameter is positive and the second one is negative), 
	--  we expect the result to be positive, otherwise we have overflow.
	--> When we subtract two parameters (the first parameter is negative and the second one is positive), 
	--  we expect the result to be negative, otherwise we have overflow.
	
	with sel select																																			--					(ov)
	ov_bit    <= 	((not a_sig(IWIDTH -1)) 	and (not b_sig(IWIDTH -1)) and 		add_res(OWIDTH -1))	or							-- (+) + (+) = (-) 0 0 1 = 1
						(a_sig(IWIDTH -1) 			and 		b_sig(IWIDTH -1) 	and (not add_res(OWIDTH -1))) when instr'pos(add), -- (-) + (-) = (+) 1 1 0 = 1
						(a_sig(IWIDTH -1) 			and (not b_sig(IWIDTH -1)) and (not sub_res(OWIDTH -1))) or							-- (-) - (+) = (+) 1 0 0 = 1
						((not a_sig(IWIDTH -1)) 	and 		b_sig(IWIDTH -1) 	and 		sub_res(OWIDTH -1))	when instr'pos(sub),	-- (+) - (-) = (-) 0 1 1 = 1
						
						((not a_sig(IWIDTH -1)) 	and (not inc_value(IWIDTH -1)) and		  inc_res(OWIDTH -1)) when instr'pos(inc),	-- (+) + (+) = (-) 0 0 1 = 1
						(a_sig(IWIDTH -1) 			and (not dec_value(IWIDTH -1)) and (not dec_res(OWIDTH -1))) when instr'pos(dec),	-- (-) - (+) = (+) 1 0 0 = 1
						'0' when others;																																							

					  
					  
							 
--	par_bit 	<= parity(a);
	
	with sel select
	zr_bit	<= allzero(signed(add_res)) when instr'pos(add), 
					allzero(signed(sub_res)) when instr'pos(sub), 
					allzero(signed(inc_res)) when instr'pos(inc), 
					allzero(signed(dec_res)) when instr'pos(dec),
					'0' when others;
							 
							 
	
	-- ------------------------------------------------------------
	-- Outputs
	-- ------------------------------------------------------------
	
	with sel select
	y	<= add_res(y'range) 	when instr'pos(add),
			sub_res(y'range) 	when instr'pos(sub),
			inc_res(y'range)	when instr'pos(inc),
			dec_res(y'range)	when instr'pos(dec),
			
			a or  b				when instr'pos(l_or),			
			a and b				when instr'pos(l_and),
			  not a				when instr'pos(l_not),												
			a xor b				when instr'pos(l_xor),

			ashft_res 			when instr'pos(ashf),
			lshft_res 			when instr'pos(lshf),			
			
			(others => '0') when others;
	

	compout <= comp;

	flags <= c_bit & ov_bit & '0' & zr_bit;
---- int div by zero
----stack overflow
--	
end beh;

