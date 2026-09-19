`timescale 1ns / 1ps

module tb_dual_port_ram;

    // Parameters
    parameter Data_Width = 8;
    parameter Addr_Width = 6;

    // Testbench signals
    reg [Data_Width-1:0] data_in_1, data_in_2;
    reg [Addr_Width-1:0] addr_1, addr_2;
    reg wr_1, wr_2;
    reg clk;

    wire [Data_Width-1:0] data_out_1, data_out_2;
    wire write_collision;

   
    dual_port_ram #(
        .Data_Width(Data_Width),
        .Addr_Width(Addr_Width)
    ) DUT (
        .data_in_1(data_in_1),
        .data_in_2(data_in_2),
        .addr_1(addr_1),
        .addr_2(addr_2),
        .wr_1(wr_1),
        .wr_2(wr_2),
        .clk(clk),
        .data_out_1(data_out_1),
        .data_out_2(data_out_2),
        .write_collision(write_collision)
    );

   //clk
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end


  
  initial begin

        // Initial values
        data_in_1 = 0;
        data_in_2 = 0;
        addr_1 = 0;
        addr_2 = 0;
        wr_1 = 0;
        wr_2 = 0;

        $dumpfile("dual_port_ram.vcd");
        $dumpvars(0, tb_dual_port_ram);

        #10;
		// Adding some data to memory locations- write only
	
        @(negedge clk);

        wr_1 = 1;
        wr_2 = 1;

        addr_1 = 6'd01;
        data_in_1 = 8'hAA;

        addr_2 = 6'd02;
        data_in_2 = 8'h12;
    
        @(posedge clk);
        #1;
    	$display("Collision Flag = %b", write_collision);
        
    
		@(negedge clk);

        wr_1 = 1;
        wr_2 = 1;

        addr_1 = 6'd03;
        data_in_1 = 8'h23;

        addr_2 = 6'd04;
        data_in_2 = 8'h08;
    
        @(posedge clk);
        #1;
  		$display("Collision Flag = %b", write_collision);
    
    
    	@(negedge clk);

        wr_1 = 1;
        wr_2 = 1;

        addr_1 = 6'd05;
        data_in_1 = 8'h08;

        addr_2 = 6'd06;
        data_in_2 = 8'h11;
   
    
        @(posedge clk);
        #1;
    	$display("Collision Flag = %b", write_collision);
    
    
    // performing read and write both

        @(negedge clk);

        wr_1 = 0;
        wr_2 = 1;

        addr_1 = 6'd02;
        addr_2 = 6'd03;
        data_in_2 = 8'h12;

        @(posedge clk);
        #1;
    	$display("Port 1 Output = %h", data_out_1);      
    
    
    

        @(negedge clk);

        wr_1 = 0;
        wr_2 = 0;

        addr_1 = 6'd01;
        addr_2 = 6'd06;

        @(posedge clk);
        #1;
        $display("Port 1 Output = %h", data_out_1);
        $display("Port 2 Output = %h", data_out_2);

  
  
    

        @(negedge clk);

        wr_1 = 1;
        wr_2 = 0;

        addr_1 = 6'd04;
    	data_in_1 = 8'h13;
        
    
    	addr_2 = 6'd05;


        @(posedge clk);
        #1;
        $display("Port 2 Output = %h", data_out_2);
    

    
    
//creating collision situation
        @(negedge clk);

        wr_1 = 1;
        wr_2 = 1;

        addr_1 = 6'd03;
        addr_2 = 6'd03;

        data_in_1 = 8'h23;
        data_in_2 = 8'h08;

        @(posedge clk);
        #1;
        $display("Collision Flag = %b", write_collision);
   		$display("Port 1 Data = %h", data_in_1); 					$display("Port 2 Data = %h", data_in_2); 
    

//checking the result of collision
    
        @(negedge clk);

        wr_1 = 0;
        wr_2 = 0;

        addr_1 = 6'd03;
        addr_2 = 6'd03;

        @(posedge clk);
        #1;

    $display("Port 1 and 2 Output = %h", data_out_1);

        #10;

        $finish;

    end

endmodule