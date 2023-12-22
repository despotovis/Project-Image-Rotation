`ifndef BRAM_SEQ_ITEM_SV
`define BRAM_SEQ_ITEM_SV

class bram_seq_item extends uvm_sequence_item;
  
    rand bit [31:0] data;
    rand bit [15:0] addr;
    rand bit wr;
  
    // registration macro    
    `uvm_object_utils_begin(bram_seq_item)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(wr, UVM_ALL_ON)
    `uvm_object_utils_end
  
    // constraints
    constraint c_data { soft data < 255; data >= 0; }
    
    //*************************c_addr********************************//
    
    // constructor  
    extern function new(string name = "bram_seq_item");
  
endclass : bram_seq_item

// constructor
function bram_seq_item::new(string name = "bram_seq_item");
    super.new(name);
endfunction : new

`endif // BRAM_SEQ_ITEM_SV