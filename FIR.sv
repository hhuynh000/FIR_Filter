module FIR (clk, reset, read, data_in, data_out);
	input logic clk, reset, read;
	input logic [23:0] data_in;
	output logic [23:0] data_out;
	logic [23:0] w1, w2, w3, w4, w5, w6, w7;
	logic [23:0] divide0, divide1, divide2, divide3, divide4, divide5, divide6, divide7;
	
	// 7x24 bit shift register
	DFFs DFF1 (.clk, .reset, .en(read), .D(data_in), .Q(w1));
	DFFs DFF2 (.clk, .reset, .en(read), .D(w1), .Q(w2));
	DFFs DFF3 (.clk, .reset, .en(read), .D(w2), .Q(w3));
	DFFs DFF4 (.clk, .reset, .en(read), .D(w3), .Q(w4));
	DFFs DFF5 (.clk, .reset, .en(read), .D(w4), .Q(w5));
	DFFs DFF6 (.clk, .reset, .en(read), .D(w5), .Q(w6));
	DFFs DFF7 (.clk, .reset, .en(read), .D(w6), .Q(w7));
	
	// use the replication operator and concatenation to divide N-bit data by 2^3 (8)
	assign divide0 = {{3{data_in[23]}}, data_in[23:3]};
	assign divide1 = {{3{w1[23]}}, w1[23:3]};
	assign divide2 = {{3{w2[23]}}, w2[23:3]};
	assign divide3 = {{3{w3[23]}}, w3[23:3]};
	assign divide4 = {{3{w4[23]}}, w4[23:3]};
	assign divide5 = {{3{w5[23]}}, w5[23:3]};
	assign divide6 = {{3{w6[23]}}, w6[23:3]};
	assign divide7 = {{3{w7[23]}}, w7[23:3]};

	assign data_out = divide0 + divide1 + divide2 + divide3 + divide4 + divide5 + 
							divide6 + divide7;
	
	
endmodule

module FIR_testbench ();
	logic clk, reset, read;
	logic [23:0] data_in, data_out;
	
	FIR dut (.clk, .reset, .read, .data_in, .data_out);
	
	// setup simulation clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1;	data_in <= 20;
		read <= 0;								@(posedge clk);
		reset <= 0;								@(posedge clk); 					
		read <= 1;								@(posedge clk);
		read <= 0;								@(posedge clk);
		
		data_in <= 40;							
		read <= 1;								@(posedge clk);
		read <= 0;								@(posedge clk);
		
		data_in <= 10;							
		read <= 1;								@(posedge clk);
		read <= 0;								@(posedge clk);
		
		data_in <= 20;							
		read <= 1;								@(posedge clk);
		read <= 0;								@(posedge clk);
		
		data_in <= 60;							
		read <= 1;								@(posedge clk);
		read <= 0;								@(posedge clk);
		
		data_in <= 80;							
		read <= 1;								@(posedge clk);
		read <= 0;								@(posedge clk);
		
		data_in <= 100;						
		read <= 1;								@(posedge clk);
		read <= 0;								@(posedge clk);
		
		data_in <= 40;							
		read <= 1;								@(posedge clk);
		read <= 0;								@(posedge clk);
		
		data_in <= 20;							
		read <= 1;								@(posedge clk);
		read <= 0;								@(posedge clk);
		
		data_in <= 120;						
		read <= 1;								@(posedge clk);
		read <= 0;								@(posedge clk);
		
		data_in <= 60;							
		read <= 1;								@(posedge clk);
		read <= 0;								@(posedge clk);
		
		data_in <= 10;							
		read <= 1;								@(posedge clk);
		read <= 0;								@(posedge clk);
		
		$stop;
	end
endmodule
