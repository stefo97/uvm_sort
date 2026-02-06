`include "sort_package.sv"
`include "my_ram_if.sv"
//`include "sort_if.sv"
import sort_package_sv::*;
module sort#
  (
   parameter integer WIDTH = WIDTH,
   parameter integer ADDRESS = ADDRESS
   )
   (
    //clock, reset
    input logic 		 clk,
    input logic 		 reset,
   
    //input axi logic
    
    output logic 		 tready,
    input logic 		 tvalid,
    input logic 		 tlast,
    input logic [WIDTH - 1 : 0]  tdata,
    // output axi logic
    output logic [WIDTH - 1 : 0] odata,
    input logic 		 oready,
    output logic 		 ovalid,
    output logic 		 olast
    // bram control
    );
   // FSM states

   
   logic [ADDRESS : 0] 		 i_reg, i_next;
   logic [ADDRESS : 0] 		 j_reg, j_next;
   logic [WIDTH - 1 : 0] 	 buble_num_reg, buble_num_next;
   logic [WIDTH - 1 : 0] 	 comp_num_reg, comp_num_next;
   logic [ADDRESS : 0] 		 sort_length_reg, sort_length_next;
   logic 			 olast_l;
   
   //debug logic
   logic [WIDTH - 1 : 0] 	 odata_l_reg;
   //*******************************************
   
   

   // RAM_MEM logic
   my_ram_if #(.WIDTH(WIDTH), .ADDRESS(ADDRESS)) ram_mem(clk, reset);
   
   

   // State reg
   states state_reg, state_next = idle;
   always @(posedge clk)begin
      if (reset)begin
         j_reg <= 0;
         i_reg <= 0;
         state_reg <= idle;
         comp_num_reg <= 0;
         buble_num_reg <= 0;
         sort_length_reg <= 0;
	 odata_l_reg <= 0;
      end
      else begin
         state_reg <= state_next;
         j_reg <= j_next;
         i_reg <= i_next;
         comp_num_reg <= comp_num_next;
         buble_num_reg <= buble_num_next;
         sort_length_reg <= sort_length_next;
	 odata_l_reg <= odata;	 
      end
   end   

   // procedure modeling comb logic
   always@(*)begin
      ram_mem.en1 = 1'b0;
      ram_mem.w_en1 = 1'b0;
      i_next = i_reg;
      j_next = j_reg;
      comp_num_next = comp_num_reg;
      buble_num_next = buble_num_reg;
      tready = 1'b0;
      ovalid = 1'b0;
      odata = 0;
      olast = 1'b0;
      state_next = state_reg;
      ram_mem.addr1 = 0;
      ram_mem.addr2 = 0;
      sort_length_next = sort_length_reg;      
      ram_mem.w_data1 = 0;
      olast_l = 0;            
      case(state_reg)
        idle:begin
           j_next = 0;
           i_next = 0;
           state_next = idle;
           comp_num_next = 0;
           buble_num_next = 0;
           tready = 1'b1;
           if (tvalid == 1'b1)begin              
	      ram_mem.en1 = 1'b1;
	      ram_mem.w_en1 = 1'b1;
	      ram_mem.addr1 = sort_length_reg;              
	      ram_mem.w_data1 = tdata;
	      sort_length_next = sort_length_reg + 1'b1;
	      state_next = mem_store;
	      if (tlast )begin
		 state_next = sort_p1;
	      end		
           end
        end // case: idle
        mem_store:begin
           if (sort_length_reg < 2**ADDRESS)begin
	      tready = 1'b1;
	      if (tvalid == 1'b1)begin
		 ram_mem.en1 = 1'b1;
		 ram_mem.w_en1 = 1'b1;
		 ram_mem.addr1 = sort_length_reg;              
		 ram_mem.w_data1 = tdata;
		 sort_length_next = sort_length_reg + 1'b1;
		 if (tlast )begin
		    state_next = sort_p1;
		 end		
	      end // if (tvalid == 1'b1)
	   end // if (sorth_length_reg == 2^ADDRESS)
	   else begin
	      state_next = sort_p1;
	      tready = 1'b0;	       
	   end
        end
        sort_p1:begin
	   tready = 1'b0;	      
           ram_mem.en1 = 1'b1;
           ram_mem.addr1 = i_reg;
           ram_mem.addr2 = j_reg;
           state_next = sort_p2;
        end
        sort_p2: begin
           if(ram_mem.r_data1 < ram_mem.r_data2)begin
              buble_num_next = ram_mem.r_data1;
              comp_num_next = ram_mem.r_data2;
              state_next = sort_switch_p_1;
           end
           else begin
              j_next = j_reg + 1'b1;
              state_next = sort_p1;
              if (j_next == sort_length_reg)begin
                 state_next = sort_p1;
                 j_next = 0;
                 i_next = i_reg + 1'b1;
                 if (i_next == sort_length_reg)begin
                    state_next = sort_finished_1;
                    i_next = 0;
                 end
              end
           end
           
        end // case: sort_p2
        sort_switch_p_1:begin
           state_next = sort_switch_p_2;
           ram_mem.en1 = 1'b1;
           ram_mem.w_en1 = 1'b1;
           ram_mem.addr1 = i_reg; 
           ram_mem.w_data1 = comp_num_reg;
           
        end // case: sort_switch_p_1
        sort_switch_p_2:begin
           state_next = sort_p1;
           ram_mem.en1 = 1'b1;
           ram_mem.w_en1 = 1'b1;
           ram_mem.addr1 = j_reg;  
           ram_mem.w_data1 = buble_num_reg;
           if (i_next == sort_length_reg)begin
              state_next = sort_finished_1;
              i_next = 0;
           end
           j_next = j_reg + 1'b1;
           if (j_next == sort_length_reg)begin
              state_next = sort_p1;
              j_next = 0;
              i_next = i_reg + 1'b1;
              if (i_next == sort_length_reg)begin
                 state_next = sort_finished_1;
                 ram_mem.en1 = 1'b1;
                 ram_mem.addr1 = i_reg;
                 i_next = 0;
              end
           end                      
        end // case: sort_switch_p_2
        
        sort_finished_1:begin
           if (oready == 1'b1)begin
              state_next = sort_finished_2;
              ram_mem.en1 = 1'b1;
              ram_mem.addr1 = i_reg;
              i_next = i_reg + 1'b1;
           end
        end // case: sort_finished	
        sort_finished_2:begin
	   if (oready == 1'b1)begin
              ovalid = 1'b1;
              odata = ram_mem.r_data1;
              ram_mem.en1 = 1'b1;
              ram_mem.addr1 = i_reg;
              state_next = sort_finished_2;
              i_next = i_reg + 1'b1;
              if (i_reg == sort_length_reg)begin
		 olast = 1'b1;
		 olast_l = 1'b1; 		
		 state_next = idle;
		 sort_length_next = 0;
              end
	   end
        end
        default:
          state_next = idle;
      endcase // case (state)
      
   end // always@ (*)


   /*procedure modeling ram_mem_memory*/
   always @(posedge clk) begin 
      if (ram_mem.en1) begin
     	 if (ram_mem.w_en1) begin
            ram_mem.ram[ram_mem.addr1] <= ram_mem.w_data1;
     	 end
     	 else begin
            ram_mem.r_data1 <= ram_mem.ram[ram_mem.addr1];
            ram_mem.r_data2 <= ram_mem.ram[ram_mem.addr2];
         end
      end
   end

   /*Checker instantiation*/
   
//   sort_checker s1 (state_reg, tvalid, tlast, tready, tdata, oready, odata, olast, ovalid, odata_l_reg, posedge clk, reset, WIDTH);
   
endmodule










