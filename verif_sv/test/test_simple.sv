`ifndef TEST_SIMPLE_SV
`define TEST_SIMPLE_SV

class test_simple extends test_base;

    `uvm_component_utils(test_simple)

    axil_seq_1 a_seq_1;
    bram_seq_1 b_seq_1;
     
    axil_seq_2 a_seq_2; 
    bram_seq_2 b_seq_2;   
   

    function new(string name = "test_simple", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new
   
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        a_seq_1 = axil_seq_1::type_id::create("a_seq_1");
        b_seq_1 = bram_seq_1::type_id::create("b_seq_1");
        
        a_seq_2 = axil_seq_2::type_id::create("a_seq_2");
        b_seq_2 = bram_seq_2::type_id::create("b_seq_2");

    endfunction : build_phase

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        phase.phase_done.set_drain_time(this, 1000);
        
        //if(cfg.is_active == UVM_ACTIVE) begin
            fork 
                a_seq_1.start(env.a_agent.axil_seqr);	         	            
	            b_seq_1.start(env.b_agent.bram_seqr);
	        join
		
		    fork 
		        begin
		          a_seq_2.start(env.a_agent.axil_seqr);
	            end   
	          	begin 
	              #7500000;         	            
	              b_seq_2.start(env.b_agent.bram_seqr);	         
	            end
	        join_any
		//end   
      
        phase.drop_objection(this);
    endtask : run_phase

endclass : test_simple

`endif