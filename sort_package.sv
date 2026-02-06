`ifndef SORT_PACKAGE_SV
 `define SORT_PACKAGE_SV

package sort_package_sv;
   
 
   typedef enum           logic[3:0]{idle, mem_store, sort_p1, sort_p2, sort_switch_p_1, sort_switch_p_2, sort_finished_1, sort_finished_2} states;
   parameter integer 	  ADDRESS = 3;
   parameter integer 	  WIDTH = 16;
   logic [31 : 0] num_of_data = 3;
   
endpackage : sort_package_sv

`endif
