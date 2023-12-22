`ifndef VERIF_TOP_SV
`define VERIF_TOP_SV

// define timescale
//`timescale 1ns/1na

module verif_top;
  
    `include "uvm_macros.svh"  
    import uvm_pkg::*;
  
    // import test package
    import verif_pkg::*;
    
    // signals
    logic rst, rstn;
    logic clk;
  
    // UVC interface instance
    axil_if axil_vif(clk, rst);
    bram_if   bram_vif(clk, rst);
  	
    // DUT instance
    axi_point_rotation_v1_0 dut(
        .s00_axi_aresetn (rst),
        .s00_axi_aclk    (clk),
        .s00_axi_awaddr  (axil_vif.s00_axi_awaddr),
        .s00_axi_awprot  (axil_vif.s00_axi_awprot),
        .s00_axi_awvalid (axil_vif.s00_axi_awvalid),
        .s00_axi_awready (axil_vif.s00_axi_awready),
        .s00_axi_wdata   (axil_vif.s00_axi_wdata),
        .s00_axi_wstrb   (axil_vif.s00_axi_wstrb),
        .s00_axi_wvalid  (axil_vif.s00_axi_wvalid),
        .s00_axi_wready  (axil_vif.s00_axi_wready),
        .s00_axi_bresp   (axil_vif.s00_axi_bresp),
        .s00_axi_bvalid  (axil_vif.s00_axi_bvalid),
        .s00_axi_bready  (axil_vif.s00_axi_bready),
        .s00_axi_araddr  (axil_vif.s00_axi_araddr),
        .s00_axi_arprot  (axil_vif.s00_axi_arprot),
        .s00_axi_arvalid (axil_vif.s00_axi_arvalid),
        .s00_axi_arready (axil_vif.s00_axi_arready),
        .s00_axi_rdata   (axil_vif.s00_axi_rdata),
        .s00_axi_rresp   (axil_vif.s00_axi_rresp),
        .s00_axi_rvalid  (axil_vif.s00_axi_rvalid),
        .s00_axi_rready  (axil_vif.s00_axi_rready),
        .mem_addr_i_top  (bram_vif.addr_o),
        .mem_data_o_top  (bram_vif.data_i),
        .mem_wr_top      (bram_vif.wr_o),
        .mem_data_i_top  (bram_vif.data_o)
    );
  

    // configure UVC's virtual interface in DB
    initial begin : config_if_block
	set_global_timeout(10s/1ps);
        uvm_config_db#(virtual axil_if)::set(null, "*", "axil_if", axil_vif);
        uvm_config_db#(virtual bram_if)::set(null, "*", "bram_if", bram_vif);
	run_test();
    end
    
    // define initial clock value and generate reset
    initial begin : clock_and_rst_init_block
        rst <= 0;
        rstn <= 1;
        clk <= 0;
        #100 rst <= 1; 
        #100 rstn <= 0;
    end
  
    // generate clock
    always #50 clk <= ~clk;
  
    //initial begin : timeformat
        //$timeformat(-9,0,"ns",5);
    //end
  
endmodule : verif_top

`endif // VERIF_TOP_SV