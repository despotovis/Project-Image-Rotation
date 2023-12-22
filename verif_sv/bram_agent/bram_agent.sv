`ifndef BRAM_AGENT_SV
`define BRA,_AGENT_SV

class bram_agent extends uvm_agent;

    // components
    //bram agent components
    bram_driver bram_drv;
    bram_monitor bram_mon;
    bram_sequencer bram_seqr;

    `uvm_component_utils_begin (bram_agent)
    `uvm_component_utils_end

    function new(string name = "bram_agent", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        bram_drv = bram_driver::type_id::create("bram_drv", this);
        bram_seqr = bram_sequencer::type_id::create("bram_seqr", this);
        bram_mon = bram_monitor::type_id::create("bram_mon", this);
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        bram_drv.seq_item_port.connect(bram_seqr.seq_item_export);      
    endfunction : connect_phase

endclass : bram_agent

`endif