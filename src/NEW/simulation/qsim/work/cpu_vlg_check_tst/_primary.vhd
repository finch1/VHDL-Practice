library verilog;
use verilog.vl_types.all;
entity cpu_vlg_check_tst is
    port(
        arith_out       : in     vl_logic_vector(7 downto 0);
        sampler_rx      : in     vl_logic
    );
end cpu_vlg_check_tst;
