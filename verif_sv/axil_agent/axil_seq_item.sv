`ifndef AXIL_SEQ_ITEM_SV
`define AXIL_SEQ_ITEM_SV

class axil_seq_item extends uvm_sequence_item;
  
    // item fields
    rand bit [5:0] addr;
    rand bit [31:0] data;
    rand bit wr;
    //rand bit write; 
    //rand bit read; 

    //registration macro    
    `uvm_object_utils_begin(axil_seq_item)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(wr, UVM_ALL_ON)
        //`uvm_field_int(read, UVM_ALL_ON)
        //`uvm_field_int(write, UVM_ALL_ON)
    `uvm_object_utils_end

    // constraints
    constraint c_data { soft data < 255; data >= 0; }
    constraint c_addr { addr inside {0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52};}

    // constructor  
    extern function new(string name = "axil_seq_item");
  
endclass : axil_seq_item

// constructor
function axil_seq_item::new(string name = "axil_seq_item");
    super.new(name);
endfunction : new

`endif // AXIL_SEQ_ITEM_SV