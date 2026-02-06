`ifndef MY_RAM_IF_SV
 `define MY_RAM_IF_SV

interface my_ram_if (input clk, input reset);
   
   parameter WIDTH = 16; 
   parameter ADDRESS = 4;   

   //signals for comunicating with RAM 
   logic          en1;
   logic          w_en1;
   logic [WIDTH - 1 : 0] w_data1;
   logic [WIDTH - 1 : 0] r_data1;
   logic [ADDRESS - 1 : 0] addr1;
   
   logic [WIDTH - 1 : 0]   r_data2;
   logic [ADDRESS - 1 : 0] addr2;

   localparam RAM_DEPTH = 2**ADDRESS;
   reg [WIDTH - 1: 0]      ram [0:RAM_DEPTH-1];
   
endinterface : my_ram_if
`endif
