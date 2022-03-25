// A D-Flip Flop with an enable and reset to the value 0
module DFFs #(parameter WIDTH=24) (clk, reset, en, D, Q);
	input logic clk, reset, en;
	input logic [WIDTH-1:0] D;
	output logic [WIDTH-1:0] Q;
	
	always_ff @(posedge clk) begin
		if (reset) 
			Q <= '0;
		else if (en)
			Q <= D;
		else
			Q <= Q;
	end
	
endmodule
