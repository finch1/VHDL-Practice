module test_project_top (

    input clk,
    input reset_n
);

wire fast_clk;
wire slow_clk;
wire [31:0] avs_s0_readdata_from_the_build_id;
wire reset_n_to_the_build_id;
wire [15:0] asi_in0_data_to_the_dut_in0;
wire reset_to_the_dut_in0;
wire [15:0] aso_out0_data_from_the_dut_out0;

test_sys_sopc test_sys_sopc_inst (
    // 1) global signals:
    .clk                                    (clk),
    .fast_clk                               (fast_clk),
    .reset_n                                (reset_n),
    .slow_clk                               (slow_clk),

    // the_build_id_s0
    .avs_s0_readdata_from_the_build_id      (avs_s0_readdata_from_the_build_id),
    .reset_n_to_the_build_id                (reset_n_to_the_build_id),

    // the_console_stream
    .resetrequest_from_the_console_stream   (),

    // the_dut_in0
    .asi_in0_data_to_the_dut_in0            (asi_in0_data_to_the_dut_in0),
    .reset_to_the_dut_in0                   (reset_to_the_dut_in0),

    // the_dut_out0
    .aso_out0_data_from_the_dut_out0        (aso_out0_data_from_the_dut_out0)
);

my_build_id my_build_id_inst (
    // Clock Interface
    .csi_clock_clk                          (slow_clk),
    .csi_clock_reset                        (reset_n_to_the_build_id),
    
    // MM Slave Interface
    .avs_s0_readdata                        (avs_s0_readdata_from_the_build_id)
);

my_dut my_dut_inst (
    // Clock Interface
    .csi_clock_clk                          (fast_clk),
    .csi_clock_reset                        (reset_to_the_dut_in0),
    
    // ST Sink Interface
    .asi_sink_data                          (asi_in0_data_to_the_dut_in0),
    
    // ST Source Interface
    .aso_source_data                        (aso_out0_data_from_the_dut_out0)
);

endmodule
