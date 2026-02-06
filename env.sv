`ifndef ENV_SV
 `define ENV_SV


`include "scoreboard.sv"   


class env extends uvm_env;

   agent_slave sort_agent_slave;
   agent_master sort_agent_master;
   sort_config cfg;
   scoreboard scbd;
   
   //virtual interface axis_if vif;
   `uvm_component_utils (env)

   function new(string name = "env", uvm_component parent = null);
      super.new(name,parent);
   endfunction

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      sort_agent_slave = agent_slave::type_id::create("sort_agent_slave", this);
      sort_agent_master = agent_master::type_id::create("sort_agent_master", this);
	  scbd = scoreboard::type_id::create("scbd", this);
	  
      if(!uvm_config_db#(sort_config)::get(this, "", "sort_config", cfg))
        `uvm_fatal("NOCONFIG",{"Config object must be set for: ",get_full_name(),".cfg"})
		
        /************Setting to configuration database********************/
		uvm_config_db#(sort_config)::set(this, "sort_agent_slave", "sort_config", cfg);
		uvm_config_db#(sort_config)::set(this, "sort_agent_master", "sort_config", cfg);
		uvm_config_db#(sort_config)::set(this, "scbd", "sort_config", cfg);
      /*****************************************************************/
	  
   endfunction : build_phase

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
		
      sort_agent_slave.mon.item_collected_port_slave.connect(scbd.port_slave);
      sort_agent_master.mon1.item_collected_port_master.connect(scbd.port_master);

   endfunction : connect_phase

endclass : env

`endif

