library ieee;
use ieee.std_logic_1164.all;

entity aio_shift_reg is port(
    clock        : in std_logic;
    shsel        : in std_logic;
    serial_in    : in std_logic;
    d        	  : in std_logic_vector(3 downto 0);
    serial_out   : out std_logic;
    q            : out std_logic_vector(3 downto 0));
end aio_shift_reg;

architecture rtl of aio_shift_reg is
    signal content: std_logic_vector(3 downto 0);
begin
    process(clock)
    begin
        if(rising_edge(clock))then
            case shsel is
                when '0' => content <= d; --load
                when '1' => content <= serial_in & content(3 downto 1); --shift right, pad with bit from serial_in
                when others => null;
            end case;
        end if;
    end process;

    q <= content;
    serial_out <= content(0);
end rtl;