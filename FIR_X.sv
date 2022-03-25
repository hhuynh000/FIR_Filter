module FIR_X #(parameter n=3) (clk, reset, read, data_in, data_out);
	input logic clk, reset, read;
	input logic [23:0] data_in;
	output logic [23:0] data_out;
	logic [23:0] w [(n**2)-1:0];
	logic [23:0] accumulatorOut, sub, divideIn;
	
	
	// use the replication operator and concatenation to divide 24-bit data by n^3 
	assign divideIn = {{n{data_in[23]}}, data_in[23:n]};
	
	// Nx24 bit shift register (Buffer)
	genvar y;
	
	DFFs DFF1 (.clk, .reset, .en(read), .D(divideIn), .Q(w[0]));
	generate
		for (y=1; y<(n**2); y++) begin : eachDFF
			DFFs DFF (.clk, .reset, .en(read), .D(w[y-1]), .Q(w[y]));
		end
	endgenerate
	
	// Subtract oldest sample from buffer
	assign sub = divideIn - w[(n**2)-1];
	
	// Accumulator 
	DFFs Accumulator (.clk, .reset, .en(read), .D(data_out), .Q(accumulatorOut));
	
	// data out is data in subtract by oldest sample from buffer and previous data out
	assign data_out = sub + accumulatorOut;
	
endmodule

module FIR_X_testbench ();
	logic clk, reset, read;
	logic [23:0] data_in, data_out;
	
	FIR_X #(.n(4)) dut (.clk, .reset, .read, .data_in, .data_out);
	
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
