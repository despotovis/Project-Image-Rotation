`ifndef VERIF_ENV_SV
`define VERIF_ENV_SV

class verif_env extends uvm_env;

    axil_agent a_agent;
    bram_agent b_agent;
    verif_scoreboard scbd;
    verif_env_cfg cfg;
   
    `uvm_component_utils (verif_env)

    function new(string name = "verif_env", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
      
        a_agent = axil_agent::type_id::create("axil_agent", this);
        b_agent = bram_agent::type_id::create("bram_agent", this);
        scbd = verif_scoreboard::type_id::create("scbd", this);
      
        if(!uvm_config_db#(verif_env_cfg)::get(this, "", "verif_env_cfg", cfg))
            `uvm_fatal("NOCONFIG",{"Config object must be set for: ",get_full_name(),".cfg"})
    
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        a_agent.axil_mon.item_collected_port.connect(scbd.port_axil);
        b_agent.bram_mon.item_collected_port.connect(scbd.port_bram);
      
    endfunction : connect_phase

endclass : verif_env

`endif