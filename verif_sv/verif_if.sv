`ifndef VERIF_IF_SV
`define VERIF_IF_SV

interface axil_if(input clk, logic rst);      
        
        //logic s00_axi_aclk;//
		//logic s00_axi_aresetn;//
		logic [5:0] s00_axi_awaddr;//
		logic [2:0] s00_axi_awprot;//
		logic s00_axi_awvalid;//
		logic s00_axi_awready;//
		logic [31:0] s00_axi_wdata;//
		logic [3:0] s00_axi_wstrb;//
		logic s00_axi_wvalid;//
		logic s00_axi_wready;//
		logic [1:0] s00_axi_bresp;//
		logic s00_axi_bvalid;	//
		logic s00_axi_bready;//
		logic [5:0] s00_axi_araddr;//	
		logic [2:0] s00_axi_arprot;	
		logic s00_axi_arvalid;	//
		logic s00_axi_arready;	//
		logic [31:0] s00_axi_rdata;	//
		logic [1:0] s00_axi_rresp;	//
		logic s00_axi_rvalid;	//
		logic s00_axi_rready;//
		
endinterface : axil_if

interface bram_if(input clk, logic rst);
    //logic rstn;
    logic [15:0] addr_o;
    logic [31:0] data_o;
    logic [31:0] data_i;
    logic wr_o;
    
endinterface : bram_if

`endif // VERIF_IF_SV