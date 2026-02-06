`ifndef TEST_SIMPLE_SV
`define TEST_SIMPLE_SV

class test_simple extends test_base;

   `uvm_component_utils(test_simple)
	
	simple_seq_slave sort_simple_seq_slave;
	simple_seq_master sort_simple_seq_master;
	
   function new(string name = "test_simple", uvm_component parent = null);
      super.new(name,parent);
   endfunction : new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
	sort_simple_seq_slave = simple_seq_slave::type_id::create("simple_seq_slave");
	sort_simple_seq_master = simple_seq_master::type_id::create("simple_seq_master");
	
	//sort_simple_seq_slave.connect(sort_env.sort_agent_slave.seq_item_port);
    //sort_simple_seq_master.connect(sort_env.sort_agent_master.seq_item_port);

   endfunction : build_phase

   task main_phase(uvm_phase phase);
      
      phase.raise_objection(this);
      fork
		
		sort_simple_seq_slave.start(sort_env.sort_agent_slave.seqr);
		sort_simple_seq_master.start(sort_env.sort_agent_master.seqr);
		
	  join_any
      phase.drop_objection(this);
   endtask : main_phase

endclass

`endif