library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package conversion is
	type instruction is(addr, sub, l_or, l_and, l_not, l_xor, inc, dec, shl, shr, comp, ld, st, clr);
	type instr_cat   is(imm, dir, alu, mem, sp, bra, irpt, indx);
	type reg			  is(a, b, c, d, e, f, g, h, tmp0, temp1, x, y, irpt, irptm, sp, pc);
	type alu_a_sel	  is(ram_b, reg_a);
	type alu_b_sel	  is(reg_b, ram_a);
	type reg_sel	  is(ram_b, ram_a, y, lo);
	type ram_addr	  is(pc, reg_a, sp, irpt);
	type ram_data	  is(pc, reg_a, reg_b, gnd);
	
	
--	function to_instruction (data :std_logic_vector) return instruction;
--	function to_mode (data :std_logic_vector) return instr_src;
--	function to_reg (data :std_logic_vector) return reg_dest;
--	
--	function to_regsel (data :reg_dest) return natural;

end conversion;

package body conversion is
  
--	function to_instruction (data :std_logic_vector) return instruction is
--    variable result :natural; 
--      begin 
--       result := to_integer(unsigned(data));
--      return instruction'val(result);
--	end function;
--	
--	function to_mode (data :std_logic_vector) return instr_src is
--    variable result :natural; 
--      begin 
--       result := to_integer(unsigned(data));
--      return instr_src'val(result);
--	end function;
--	
--	function to_reg (data :std_logic_vector) return integer is
--    variable result :integer; 
--      begin 
--       result := to_integer(unsigned(data));
--      return reg_dest'val(result);
--	end function;
--	
--	function to_regsel (data :reg_dest) return natural is
--	 variable result :natural; 
--		begin
--			result := reg_dest'pos(data);
--			return result;
--	end function;
end conversion;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.conversion.all;

entity decoder is port(
	 clk, rst 		: in std_logic;
    instr 			: in std_logic_vector(23 downto 0); 
	 a_mux_sel 		: out std_logic_vector(0 downto 0);	--alu a bus select
	 b_mux_sel 		: out std_logic_vector(0 downto 0);	--alu b bus select
	 cin 				: out std_logic := '0';
--	 reg_sel 		: out std_logic_vector(1 downto 0);			--register select
	 reg_wren 		: out std_logic;							--
	 pc_en 			: out std_logic;
	 pc_ld 			: out std_logic;
	 ram_wren_a		: out std_logic;
	 ram_data_mux	: out std_logic_vector(0 downto 0);	--ram data port a select
	 ram_addr_mux	: out std_logic_vector(1 downto 0);	--ram addrr port a select
	 reg_mux 	   : out std_logic_vector(1 downto 0));--reg data input mux
end decoder;

architecture mp of decoder is
	signal mem_halt : std_logic;
	
	signal cat : natural range 0 to 7  := to_integer(unsigned(instr(23 downto 21)));
	signal dest: natural range 0 to 15 := to_integer(unsigned(instr(11 downto 8)));
	signal src1: natural range 0 to 15 := to_integer(unsigned(instr(7  downto 4)));
	signal src2: natural range 0 to 15 := to_integer(unsigned(instr(3  downto 0)));
	
	signal a_sel : alu_a_sel;
	signal b_sel : alu_b_sel;
			 
	signal reg : reg_sel;
	
	signal ram_data_sel : ram_data;
	
	signal ram_addr_sel : ram_addr;
begin	

--	process(clk, rst)
--	begin
--		if rst = '0' then
--			mem_halt <= '1';
--		elsif rising_edge(clk) then
--			if opcode(7 downto 6) = "11" then
--				mem_halt <= not(mem_halt);
--			end if;
--		end if;
--	end process;
			
	pc_ld		<= '0';
				
	a_sel <= reg_a when cat = instr_cat'pos(imm)-- | instr_cat'pos(dir) | instr_cat'pos(alu),
				--else ram_b when cat = instr_cat'pos(mem)
				else ram_b;	
				
	b_sel <= ram_a when cat = instr_cat'pos(imm)-- | instr_cat'pos(dir) | instr_cat'pos(mem)
				--else reg_b when instr_cat'pos(alu)				
				else reg_b;
				
	reg <= --ram_b when cat = instr_cat'pos(dir),
			 --else ram_a when cat = instr_cat'pos(imm),
			 --else 
			 y when cat = instr_cat'pos(imm)
			 else lo;
				
				reg_wren <= '1' when cat = instr_cat'pos(imm) else '0';
				pc_en <= '1';
				ram_addr_sel <= pc;
		
		a_mux_sel 		<= std_logic_vector(to_unsigned(alu_a_sel'pos(a_sel), 1));
		b_mux_sel 		<= std_logic_vector(to_unsigned(alu_b_sel'pos(b_sel), 1));
		reg_mux 			<= std_logic_vector(to_unsigned(reg_sel'pos(reg), 2));
		ram_addr_mux 	<= std_logic_vector(to_unsigned(ram_addr'pos(ram_addr_sel), 2));

end mp;

--library ieee;
--    use ieee.std_logic_1164.all;
--entity decoder is port (
--    x: in integer range 0 to 2;
--    y1, y2, y3, y4, y5: out bit);
--end decoder;
--
--architecture arch of decoder is
--    type color is (red, green, blue);
--    signal z : color;
--    signal z2, z3 : integer;
--begin
--    z <= red when x = 0 else green when x = 1 else blue;
--    y1 <= '1' when color'val(x)= blue else '0'; 			-- T'Val(s) Base type of T value at position x in T (x is integer)
--    y2 <= '1' when x = color'pos(blue) else '0'; 		-- T'Pos(s) Universal integer Position number of s in T
--    z2 <= color'pos(color'val(x));
----    y3 <= '1' when color'rightof(z)= blue else '0';	-- T'Rightof(s) Base type of T Value at position one to the right of s in T
----    y4 <= '1' when color'pred(z)=green else '0';		-- T'Pred(s) Base type of T Value at position one less than s in T
----    y5 <= '1' when color'pred(green)=z else '0';
--end arch;