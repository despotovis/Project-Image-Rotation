`ifndef AXIL_MONITOR_SV
`define AXIL_MONITOR_SV

class axil_monitor extends uvm_monitor;

   // control fileds
   bit checks_enable = 1;
   bit coverage_enable = 1;
    bit [5:0] address;
   
    uvm_analysis_port #(axil_seq_item) item_collected_port;

    `uvm_component_utils_begin(axil_monitor)
      `uvm_field_int(checks_enable, UVM_DEFAULT)
      `uvm_field_int(coverage_enable, UVM_DEFAULT)
    `uvm_component_utils_end

    // The virtual interface used to drive and view HDL signals.
    virtual interface axil_if vif;

    // current transaction
    axil_seq_item seq_item;
   
    covergroup write_address;
      option.per_instance = 1;
      write_address: coverpoint vif.s00_axi_awaddr{
         bins write_address_bin_1 = {0};
         bins write_address_bin_2 = {4};
         bins write_address_bin_3 = {8};
         bins write_address_bin_4 = {12};
         bins write_address_bin_5 = {16};
         bins write_address_bin_6 = {20};
         bins write_address_bin_7 = {24};
         bins write_address_bin_8 = {28};
         bins write_address_bin_9 = {32};
         bins write_address_bin_10 = {36};
         bins write_address_bin_11 = {40};
      }
      data_write_cpt: coverpoint vif.s00_axi_wdata {
         bins start_0 = {0};
         bins start_1 = {1};         
      }
   endgroup // write_read_address
   
   covergroup read_address;
      option.per_instance = 1;
      read_address: coverpoint vif.s00_axi_araddr{
         bins read_address_bin_1 = {0};
         bins read_address_bin_2 = {4};
         bins read_address_bin_3 = {8};
         bins read_address_bin_4 = {12};
         bins read_address_bin_5 = {16};
         bins read_address_bin_6 = {20};
         bins read_address_bin_7 = {24};
         bins read_address_bin_8 = {28};
         bins read_address_bin_9 = {32};
         bins read_address_bin_10 = {36};
         bins read_address_bin_11 = {40};
         bins read_address_bin_12 = {44};
         bins read_address_bin_13 = {48};
         bins read_address_bin_14 = {52};          
      }
      data_read_cp: coverpoint vif.s00_axi_rdata{
         bins data_bin_ready = {1};
         bins data_bin_not_ready = {0};
      }
      raw_and_rbw: cross    read_address, data_read_cp;
   endgroup
   
   // ----------------------------------------------
    function new(string name = "axil_monitor", uvm_component parent = null);
        super.new(name,parent);
        item_collected_port = new("item_collected_port", this); 
        write_address = new();
        read_address = new();  
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (!uvm_config_db#(virtual axil_if)::get(this, "*", "axil_if", vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
      
    endfunction : connect_phase

    task run_phase(uvm_phase phase);
        forever begin

            seq_item = axil_seq_item::type_id::create("seq_item", this);
            @(posedge vif.clk)begin
                if(vif.s00_axi_awready )begin
                    //`uvm_info(get_name(), $sformatf("write address: %d", vif.s00_axi_awaddr), UVM_LOW)
                    address = vif.s00_axi_awaddr;               
                    write_address.sample();
                end
                if(vif.s00_axi_arready)
                    address = vif.s00_axi_araddr;
                    read_address.sample();
                if(vif.s00_axi_rvalid)begin
                    //read_address.sample();
                    seq_item.data = vif.s00_axi_rdata;
                    seq_item.addr = address;
                    item_collected_port.write(seq_item);
                    //`uvm_info(get_name(), $sformatf("read address: %d \t read_data: %d", addr, vif.s00_axi_rdata), UVM_LOW)
                end
            end
        end
    endtask : run_phase

endclass : axil_monitor

`endif