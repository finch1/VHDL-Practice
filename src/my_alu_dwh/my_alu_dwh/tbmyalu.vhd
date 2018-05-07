-- ----------------------------------------------------------------
-- tbmyalu.vhd
--
-- 4/16/2017
--
-- Simple ALU testbench.
--
-- ----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Standard library
library std;
use std.textio.all;

-- Logging package
use work.log_pkg.all;

 ----------------------------------------------------------------

entity tbmyalu  is
	generic (
		WIDTH : integer := 4
	);
end entity;

 ----------------------------------------------------------------

architecture tbmyalu_arch of tbmyalu is

	-- ------------------------------------------------------------
	-- Components
	-- ------------------------------------------------------------
	--
	component myalu is
		generic (
			WIDTH : integer
		);
		port (
			a    : in  std_logic_vector(WIDTH-1 downto 0);
			b    : in  std_logic_vector(WIDTH-1 downto 0);
			cin  : in  std_logic;
			sel  : in  std_logic;
			cout : out std_logic;
			y    : out std_logic_vector(WIDTH-1 downto 0)
		);
	end component;

	-- ------------------------------------------------------------
	-- Parameters
	-- ------------------------------------------------------------
	--
	-- Time delay between tests
	constant tDELAY : time := 100 ns;

	-- ------------------------------------------------------------
	-- Internal Signals
	-- ------------------------------------------------------------
	--
	signal sel :  std_logic;
	signal y   :  std_logic_vector(WIDTH-1 downto 0);
	signal a   :  std_logic_vector(WIDTH-1 downto 0);
	signal cin :  std_logic;
	signal b   :  std_logic_vector(WIDTH-1 downto 0);
	signal cout:  std_logic;

begin

	-- ------------------------------------------------------------
	-- Device under test
	-- ------------------------------------------------------------
	--
	u1: myalu
		generic map (
			WIDTH => WIDTH
		)
		port map (
			a    => a,
			b    => b,
			cin  => cin,
			sel  => sel,
			cout => cout,
			y    => y
		);

	-- ------------------------------------------------------------
	-- Stimulus
	-- ------------------------------------------------------------
	--
	-- * Read input and expected outputs from file
	-- * Drive the inputs, and compare the outputs
	--
	process

	   -- Stimulus file
	   constant file_name   : string := "aluinout.txt";
    	variable file_status : file_open_status;
		file     file_handle : text;
		variable file_line   : line;

		-- File read access success
		variable read_ok : boolean;

		-- Integer value read from the line
		variable val    : integer;

		-- Expected outputs
		variable out_exp  : std_logic_vector(WIDTH   downto 0);
		variable y_exp    : std_logic_vector(WIDTH-1 downto 0);
		variable cout_exp : std_logic;

		-- Skip tabs
		variable tab : character;

  begin
		-- --------------------------------------------------------
  		-- Testbench message
		-- --------------------------------------------------------
		--
		log_title("ALU testbench");

		-- --------------------------------------------------------
  		-- Default stimulus
		-- --------------------------------------------------------
		--
  		sel <= '0';
  		cin <= '0';
  		a   <= (others => '0');
  		b   <= (others => '0');

		-- Put a delay between test stimulus
		wait for tDELAY;

		-- --------------------------------------------------------
  		-- Open the stimulus file
		-- --------------------------------------------------------
		--
		log("Open stimulus file '" & file_name & "'");

		-- Open the file
		file_open(file_status, file_handle, file_name, READ_MODE);
		assert file_status = OPEN_OK
			report "Error: failed to open the " &
				"input data file " & file_name
			severity failure;

		-- Skip empty lines and lines that start with #
		while (not endfile(file_handle)) loop
			readline(file_handle, file_line);
			if ( (file_line'length = 0) or
			    ((file_line'length > 0) and
			     (file_line(file_line'left) /= '#')) ) then
				exit;
			end if;
		end loop;

		-- --------------------------------------------------------
  		-- Apply stimulus
		-- --------------------------------------------------------
		--
		log("Apply stimulus");

		-- Loop through all the entries in the stimulus file
		while not endfile(file_handle) loop

			-- Read a line
			readline(file_handle, file_line);

			-- Parse the stimulus entries
			for i in 1 to 5 loop
				read(file_line, val, read_ok);
				assert read_ok
					report "Error: number of packets read failed!"
				severity failure;
				case (i) is
					when 1 =>
						if (val = 0) then
							sel <= '0';
						else
							sel <= '1';
						end if;
					when 2 =>
						if (val = 0) then
							cin <= '0';
						else
							cin <= '1';
						end if;
					when 3 =>
						a <= std_logic_vector(to_signed(val, WIDTH));
					when 4 =>
						b <= std_logic_vector(to_signed(val, WIDTH));
					when 5 =>
						out_exp  := std_logic_vector(to_signed(val, WIDTH+1));
						y_exp    := out_exp(WIDTH-1 downto 0);
						cout_exp := out_exp(WIDTH);
					when others =>
						assert false
							report "Error: invalid stimulus column!"
							severity failure;
				end case;
			end loop;			
			
			-- Put a delay between test stimulus and check
			wait for tDELAY /2;

			-- Check the output vs expected
			assert (y = y_exp)
				report "Error: y output mismatch! Expected " &
					to_hstring(y_exp) & "h, but the output was " &
					to_hstring(y) & "h"
				severity warning;
			assert (cout = cout_exp)
				report "Error: carry output mismatch! Expected " &
					std_logic'image(cout_exp) & ", but the output was " &
					std_logic'image(cout)
				severity warning;
			wait for tDELAY /2;

		end loop;

		log("All stimulus checks passed!");

		-- Close the file
		file_close(file_handle);

		-- --------------------------------------------------------
		-- Simulation complete
		-- --------------------------------------------------------
		--
		log_title("Simulation complete");

		-- --------------------------------------------------------
		-- End simulation
		-- --------------------------------------------------------
		--
		wait;

	end process;
end architecture;


