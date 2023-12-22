`ifndef BRAM_DRIVER_SV
`define BRAM_DRIVER_SV

class bram_driver extends uvm_driver#(bram_seq_item);

    `uvm_component_utils(bram_driver)
    
    virtual interface bram_if vif;
   
    function new(string name = "bram_driver", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (!uvm_config_db#(virtual bram_if)::get(this, "*", "bram_if", vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
    endfunction : connect_phase

    task run_phase(uvm_phase phase);
        
        forever begin
            seq_item_port.get_next_item(req);
            //`uvm_info(get_type_name(), $sformatf("Driver sending...\n%s", req.sprint()), UVM_LOW)
            
            @(negedge vif.clk)begin 
                if(req.wr)begin//read = 0, write = 1
                    vif.data_o = req.data;
                    vif.addr_o = req.addr;
                    vif.wr_o = req.wr;  
                    @(negedge vif.clk);
                end
                else begin    
                    vif.data_o = req.data;
                    vif.addr_o = req.addr;
                    vif.wr_o = req.wr;  
                    @(negedge vif.clk);                   
                end
	           
	       end 	
	       seq_item_port.item_done();   
        end // forever begin
    endtask : run_phase 

endclass : bram_driver

`endif