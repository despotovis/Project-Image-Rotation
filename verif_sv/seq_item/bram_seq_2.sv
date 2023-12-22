`ifndef BRAM_SEQ_2_SV
`define BRAM_SEQ_2_SV

class bram_seq_2 extends bram_base_seq;

    logic [15:0] mask3 = 16'b0110000000000000;
    logic [15:0] mask4 = 16'b1000000000000000;
    logic [15:0] mask5 = 16'b1010000000000000;
   
    int num_of_addrs = 7056; 
   
    `uvm_object_utils (bram_seq_2)
    
    function new(string name = "bram_seq_2");
        super.new(name);
    endfunction
      
    virtual task body();
        //`uvm_info(get_type_name(), $sformatf("A bram is being used, %d ", mask3), UVM_NONE)
        //forever begin
        for(int i = 0; i < num_of_addrs; i++)begin
            //`uvm_info(get_type_name(), $sformatf("Writing to A bram, to addr %d", i), UVM_NONE)
            `uvm_do_with(req, {req.wr == 0; req.data == 1; req.addr == 16'(mask3 | i);});
        end
        
        //`uvm_info(get_type_name(), $sformatf("A bram is being used, %d ", mask4), UVM_NONE)
        
        for(int j = 0; j < num_of_addrs; j++)begin
            //`uvm_info(get_type_name(), $sformatf("Writing to A bram, to addr %d", j), UVM_NONE)
            `uvm_do_with(req, {req.wr == 0; req.data == 1; req.addr == 16'(mask4 | j);});
        end
        
        //`uvm_info(get_type_name(), $sformatf("A bram is being used, %d ", mask5), UVM_NONE)
        
        for(int k = 0; k < num_of_addrs; k++)begin
            //`uvm_info(get_type_name(), $sformatf("Writing to A bram, to addr %d", k), UVM_NONE)
            `uvm_do_with(req, {req.wr == 0; req.data == 1; req.addr == 16'(mask5 | k);});
        end
        //end
    endtask : body 

endclass : bram_seq_2

`endif