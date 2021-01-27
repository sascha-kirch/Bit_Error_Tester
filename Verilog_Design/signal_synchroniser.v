module signal_synchroniser
#(
parameter width = 1
)
(
clk,
reset,
asynchron_signal_in,
synchron_signal_out
);

input clk;
input reset;
input [width-1:0]asynchron_signal_in;

output [width-1:0]synchron_signal_out;

reg [1:0] sychronise_register[width-1:0];

genvar i;

generate

for( i=0; i< width; i=i+1 )
	begin: synchroniser_loop
		always @ (posedge clk or posedge reset)
		begin
			if(reset)
				sychronise_register [i] [1:0] <= 2'b00;
			else
				sychronise_register[i][1:0] <= {sychronise_register [i] [0],asynchron_signal_in[i]};
		end

		assign synchron_signal_out[i] = sychronise_register[i][1];
	end
	
endgenerate


endmodule