module error_counter(
pattern1,
pattern2,
clock,
reset,
enable,		//enabled by the tx enable
errors,		// number of errors
error_flag	//is set when errorcount is full
);

input pattern1;
input pattern2;
input clock;
input reset;
input enable;

output reg [15:0] errors;   // 16 bit because 4 digit Hex Display
output reg error_flag;


always @ (posedge clock or posedge reset)
	begin
		if(reset)
			begin
				errors [15:0] <= 16'b0;
				error_flag <= 1'b0;
			end	
				else if (enable)
					begin
					 // because then the display shows FFFF when 2 edges later
						if(errors[15:0] == 16'b1-2'b10)
							begin
								error_flag <= 1'b1;
							end	
						else
							if (pattern1 != pattern2)
								errors[15:0] <= errors[15:0] + 1'b1;
					end
end

endmodule