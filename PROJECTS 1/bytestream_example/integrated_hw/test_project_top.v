module test_project_top (

    input clk,
    input reset_n
);

test_sys_sopc test_sys_sopc_inst (
    // 1) global signals:
    .clk        (clk),
    .fast_clk   (),
    .reset_n    (reset_n),
    .slow_clk   (),

    // the_console_stream
    .resetrequest_from_the_console_stream   ()
);

endmodule
