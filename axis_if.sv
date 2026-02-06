`ifndef AXIS_IF_SV
 `define AXIS_IF_SV
 
  
interface slave_if (input clk, input reset);

   // input axi logic -- slave
   logic tready;
   logic tvalid;
   logic tlast;
   logic [15 : 0] tdata;
   
endinterface : slave_if


interface master_if (input clk, input reset);
   
   // output axi logic -- master
   logic oready;
   logic ovalid;
   logic olast;
   logic [15: 0] odata;
 
endinterface : master_if
`endif
