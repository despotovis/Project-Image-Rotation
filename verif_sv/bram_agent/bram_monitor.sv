`ifndef BRAM_MONITOR_SV
`define BRAM_MONITOR_SV

class bram_monitor extends uvm_monitor;

   // control fileds
   bit checks_enable = 1;
   bit coverage_enable = 1;
   int address = 0;
   logic [31 : 0] in_data;   
   
   uvm_analysis_port #(bram_seq_item) item_collected_port;

   `uvm_component_utils_begin(bram_monitor)
      `uvm_field_int(checks_enable, UVM_DEFAULT)
      `uvm_field_int(coverage_enable, UVM_DEFAULT)
   `uvm_component_utils_end

   // The virtual interface used to drive and view HDL signals.
   virtual interface bram_if vif;
   
   // current transaction
   bram_seq_item seq_item;

   function new(string name = "bram_monitor", uvm_component parent = null);
      super.new(name,parent);
      item_collected_port = new("item_collected_port", this);
   endfunction

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if (!uvm_config_db#(virtual bram_if)::get(this, "*", "bram_if", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
   endfunction : connect_phase

    task run_phase(uvm_phase phase);
        seq_item = bram_seq_item::type_id::create("seq_item", this);      
      
        forever begin
            //if(vif.wr_o)begin
                @(posedge vif.clk)begin
                    if(vif.data_o)begin
                        //if(!vif.wr_o)
                        @(posedge vif.clk)  
                        //`uvm_info("BRAM MONITOR", $sformatf("Command: %d", vif.wr), UVM_LOW)
                        //`uvm_info("BRAM MONITOR", $sformatf("Data_in: %d", vif.data_i), UVM_LOW)
                        //`uvm_info("BRAM MONITOR", $sformatf("Data_out: %d", vif.data_o), UVM_LOW)
                        //`uvm_info("BRAM MONITOR", $sformatf("Address: %d", vif.addr_o), UVM_LOW)
                        seq_item.wr = vif.wr_o;
                        seq_item.data = vif.data_i;
                        seq_item.addr = vif.addr_o;
                        item_collected_port.write(seq_item);    
	               end   
	           end // @ (negedge vif.clk)
	        //end	  
        end // forever begin     
   endtask : run_phase
   
endclass : bram_monitor

`endif