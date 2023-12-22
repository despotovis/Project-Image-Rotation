`ifndef AXIL_SEQ_2_SV
`define AXIL_SEQ_2_SV

class axil_seq_2 extends axil_base_seq;
    
    logic [32:0] data_array[11] = {8'b10110101, 8'b10110101, 8'b01010100, 8'b01010100, 
                                   8'b00111100, 8'b00111100, 8'b00101010, 8'b00101010,
                                   8'b00011110, 8'b00011110, 8'b00000001};
    
    int num_of_regs = 13;   
   
    `uvm_object_utils (axil_seq_2)
    
    function new(string name = "axil_seq_2");
        super.new(name);
    endfunction
      
    virtual task body();
        //`uvm_info(get_type_name(), $sformatf("%d registers are being used ", num_of_regs), UVM_NONE)
        
        //`uvm_info(get_type_name(), $sformatf("Writing to a reg %d", 44), UVM_NONE)
        `uvm_do_with(req, {req.wr == 1; req.data == 8'b00000001; req.addr == 44;});
        `uvm_do_with(req, {req.wr == 1; req.data == 8'b00000000; req.addr == 44;});
        
        for(int i = 0; i < num_of_regs; i++)begin
                //`uvm_info(get_type_name(), $sformatf("Writing to a reg %d", i*4), UVM_NONE)
                `uvm_do_with(req, {req.wr == 0; req.data == 1; req.addr == i*4;});
            end
        
        forever begin
            for(int j = 12; j < 14; j++)begin
                //`uvm_info(get_type_name(), $sformatf("Writing to a reg %d", j*4), UVM_NONE)
                `uvm_do_with(req, {req.wr == 0; req.data == 1; req.addr == j*4;});
            end
        end
        
    endtask : body 

endclass : axil_seq_2

`endif