module reset_synchroniser(
clk,
async_reset,
sync_reset
);

input clk;
input async_reset;

output sync_reset;


reg [1:0]sync_reset_register;


always @ (posedge clk or posedge async_reset)
begin 
	if(async_reset)
		sync_reset_register [1:0] <= 2'b11;
	else
		sync_reset_register [1:0] <= {sync_reset_register [0],1'b0};
end
assign sync_reset = sync_reset_register[1];


endmodule