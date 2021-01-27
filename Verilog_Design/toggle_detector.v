module toggle_detector
#(
parameter width = 1
)(
clk,
reset,
signal,
toggle_flag
);


input clk;
input reset;
input [width-1:0]signal;

output toggle_flag;

reg [width-1:0]signal_delayed;
reg [width-1:0]toggle;


genvar i;

generate

	for( i=0; i< width; i=i+1 )
		begin: toggle_loop

			always @ (posedge clk or posedge reset)
			begin 
				if(reset)
					signal_delayed[i] <= 1'b0;
				else
					signal_delayed[i]  <= signal[i] ;
			end
			
		end
	
endgenerate

assign toggle_flag = ((signal[width-1:0] != 
		signal_delayed[width-1:0]))? 1'b1 : 1'b0;  .
		
endmodule