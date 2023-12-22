`ifndef VERIF_ENV_CFG_SV
`define VERIF_ENV_CFG_SV

class verif_env_cfg extends uvm_object;
   
    uvm_active_passive_enum is_active = UVM_ACTIVE;
    bit has_checks;
    bit has_coverage;
  
    // registration macro
    `uvm_object_utils_begin(verif_env_cfg)
        `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_object_utils_end
    
    // constructor
    extern function new(string name = "verif_env_cfg");
  
endclass : verif_env_cfg

// constructor
function verif_env_cfg::new(string name = "verif_env_cfg");
    
    super.new(name);
  
endfunction : new

`endif // VERIF_ENV_CFG_SV