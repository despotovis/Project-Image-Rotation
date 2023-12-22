`ifndef VERIF_PKG_SV
`define VERIF_PKG_SV

package verif_pkg;

 import uvm_pkg::*;            // import the UVM library
 `include "uvm_macros.svh"     // Include the UVM macros
   
 `include "verif_env_cfg.sv"

   //seq_item
 `include "seq_item/axil_seq_item.sv"
 `include "seq_item/bram_seq_item.sv"

 //driver
 `include "axil_driver.sv"
 `include "bram_driver.sv"

   //sequencer
 `include "sequencer/axil_sequencer.sv" 
 `include "sequencer/bram_sequencer.sv"

   //monitor
 `include "axil_monitor.sv"
 `include "bram_monitor.sv"

 //agent
 `include "axil_agent.sv"
 `include "bram_agent.sv"

 //env
 `include "verif_scoreboard.sv"
 `include "verif_env.sv"

 `include "sequence/seq_lib.sv"
 `include "test/test_lib.sv"

endpackage : verif_pkg

 `include "verif_if.sv"

`endif