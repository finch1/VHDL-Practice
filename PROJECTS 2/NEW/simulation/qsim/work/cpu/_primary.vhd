library verilog;
use verilog.vl_types.all;
entity cpu is
    port(
        arith_out       : out    vl_logic_vector(7 downto 0);
        CLK_IN          : in     vl_logic;
        RST_IN          : in     vl_logic
    );
end cpu;
