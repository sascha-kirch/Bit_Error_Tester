module delay (
delay_select,
signal_in,
signal_out,
clk,
reset,
enable
);

input clk;
input reset;
input signal_in;
input enable;
input [1:0] delay_select;

output signal_out;

reg [5:0]delay_register;

always @ (posedge clk or posedge reset)
 begin
	 if(reset)
		 delay_register[5] <= 1'b0; 
	 else
		if (enable)
			delay_register[5] <= delay_register[4];
end

always @ (posedge clk or posedge reset)
 begin
	 if(reset)
		 delay_register[4] <= 1'b0; 
	 else
		if (enable)
			delay_register[4] <= delay_register[3];
end


always @ (posedge clk or posedge reset)
 begin
	 if(reset)
		 delay_register[3] <= 1'b0; 
	 else
		if (enable)
			delay_register[3] <= delay_register[2];
end

 always @ (posedge clk or posedge reset)
 begin
	 if(reset)
		 delay_register[2] <= 1'b0; 
	 else
		if (enable)
			delay_register[2] <= delay_register[1];
end

 always @ (posedge clk or posedge reset)
 begin
	 if(reset)
		 delay_register[1] <= 1'b0; 
	 else
		if (enable)
			delay_register[1] <= delay_register[0];
end

 always @ (posedge clk or posedge reset)
 begin
	 if(reset)
		 delay_register[0] <= 1'b0; 
	 else
		if (enable)
			delay_register[0] <= signal_in;
end


assign signal_out = (delay_select[1:0] == 2'b00)?  delay_register[2] : ((delay_select[1:0]==2'b01) ? delay_register[3] : ((delay_select[1:0] == 2'b10)? delay_register[4] : delay_register[5] ));
	
endmodule