`timescale 1ns / 1ps


module dual_port_ram #(
	parameter Data_Width = 8,
	parameter Addr_Width = 6)
  (
    input [Data_Width-1:0] data_in_1, data_in_2, //data lineAC
    input [Addr_Width-1:0] addr_1, addr_2, //address line
    input wr_1, wr_2, //0->read ; 1->write
    input clk, //clock
    output reg [Data_Width-1:0] data_out_1,data_out_2, //output
    output reg write_collision //flag; set high in case of write collision
);
  
  reg [Data_Width-1:0] ram [0:(1<<Addr_Width)-1]; //64 X 8-bit registers  
  always @ (posedge clk) begin 
    write_collision <= 1'b0;
    
    //Both ports perform READ
    if (!wr_1 && !wr_2) begin
      data_out_1 <= ram[addr_1];
      data_out_2 <= ram[addr_2];
    end
    
    //Port 1: Write and Port 2: Read
    else if (wr_1 && !wr_2) begin
      ram[addr_1] <= data_in_1; //write new data to addr_1 
      
      if (addr_1 == addr_2) 
     	 data_out_2 <= data_in_1; // If both ports access the same address, forward the new write data directly to the read output (WRITE-FIRST behavior)
      else 
        data_out_2 <= ram[addr_2]; // If the ports access different addresses, read the data from memory
    end
    
    
    //Port 1: Read and Port 2: Write
    else if (!wr_1 && wr_2) begin
      ram[addr_2] <= data_in_2; //write new data into addr_1 
      
      if (addr_1 == addr_2) 
     	 data_out_1 <= data_in_2; // If both ports access the same address, forward the new write data directly to the read output (WRITE-FIRST behavior)
      else 
        data_out_1 <= ram[addr_1]; // If the ports access different addresses, read the data from memory
    end
    
    
    // Both Port perform WRITE
    else begin
      if (addr_1 == addr_2) begin
        write_collision <= 1'b1; // If both ports try to write to the same address, assert the collision flag
        ram[addr_1] <= data_in_1; // Port 1 is given priority (arbitrary design choice)
      end
      else begin
        write_collision <= 1'b0;
        ram[addr_1] <= data_in_1;
        ram[addr_2] <= data_in_2;
      end 
    end
  end
endmodule
    
    
  