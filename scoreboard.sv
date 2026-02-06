
`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV


`uvm_analysis_imp_decl(_slave)
`uvm_analysis_imp_decl(_master)


class scoreboard extends uvm_scoreboard;
// control fileds
    bit checks_enable = 1;
    bit coverage_enable = 1;
// This TLM port is used to connect the scoreboard to the monitor

    //`uvm_component_utils(scorborad)

    uvm_analysis_imp_slave #(seq_item_slave, scoreboard) port_slave;
    uvm_analysis_imp_master #(seq_item_master, scoreboard) port_master;

int num_of_tr = 0;
int i = 0;
//int j = 0;
int temp[];
int cnt = 0;


//seq_item_master pkt_qu1[$];
int q_s [$];
//int array_m [];


//array_s = new[10];
//array_m = new[10];

//temp = new[1];


`uvm_component_utils_begin(scoreboard)
    `uvm_field_int(checks_enable, UVM_DEFAULT)
    `uvm_field_int(coverage_enable, UVM_DEFAULT)
`uvm_component_utils_end

function new(string name = "scoreboard", uvm_component parent = null);
    super.new(name,parent);
   
    port_slave = new("slave_mon", this);
    port_master = new("master_mon", this);

endfunction : new

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
   
endfunction: build_phase


function write_slave (seq_item_slave tr);

    seq_item_slave tr_clone;
    $cast(tr_clone, tr.clone());

    q_s.push_back(tr_clone.tdata);    
    

    if (tr_clone.tlast) begin
       
        `uvm_info("scorobroad_slave", $sformatf(" tdata = %0d\n",  tr_clone.tdata.size()), UVM_LOW);
    
    end

   // `uvm_info("scorobroad_slave_array", $sformatf(" tdata = %0d\n",  push_back(tr_clone.tdata)), UVM_LOW);
/*
   if(tr_clone.tlast) begin
    for ( int i = 0 ; i < 6 ; i++ ) begin
        for (int j = i + 1 ; j < 6 ; i++) 
            begin
            if (array_s[i] > array_s [j]) begin
                temp = array_s[i];
                array_s[i] = array_s[j];
                array_s = temp;
            end 
        end 
     end 


   // `uvm_info(get_type_name(), $sformatf(" scoreboard examined: %0d transactions", num_of_tr), UVM_LOW); 
    
   // `uvm_info("scorobroad_slave", $sformatf("scoreboard data :%0d\n", tr_clone.tdata), UVM_LOW);
endfunction


//ref_model
/*
for ( int i = 0 ; i < 10 ; i++ ) begin
    for (int j = i + 1 ; j < 10 ; i++) 
        begin
        if (array_s[i] > array_s [j]) begin
            temp = array_s[i];
            array_s[i] = array_s[j];
            array_s = temp;
        end 
    end 
    
    for ( i = 0 ; i < 10 ; i++ ) begin
        `uvm_info("scorobroad_slave_array", $sformatf(" array[%d] = %0d\n", i, tr_clone.tdata), UVM_LOW);
    end 
end 

*/

function write_master (seq_item_master tr);
    seq_item_master tr_clone;
    $cast(tr_clone, tr.clone());


    //array_m[i++] = tr_clone.odata;



    /*
    for ( int i = 0 ; i < 10 ; i++ ) begin
        for (int j = i + 1 ; j < 10 ; i++) 
            begin
            if (array_s[i] > array_s [j]) begin
                temp[i] = array_s[i];
                array_s[i] = array_s[j];
                array_s[i] = temp[i];
            end 
        end 
        
    end */
 
    //basic ref model 

    /*
     
    for (int i = 0 ; i < 6 ; i++) begin    
     
        if (array_s[i] == array_m[i - 1]) begin
    
        `uvm_info("SCORBORAD-> ",$sformatf(" test_passed =%d s=%d m=%d",  cnt, array_s[i], array_m[i] ) , UVM_LOW);
    
     end
        
end */

    //`uvm_info("scorobroad_slave_array", $sformatf(" array[%d] = %0d\n", i, tr_clone.odata), UVM_LOW);

endfunction 


function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf(" scoreboard examined: %0d transactions", num_of_tr), UVM_LOW);
endfunction : report_phase


endclass : scoreboard

`endif