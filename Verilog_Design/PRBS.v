module PRBS
#(
parameter LFSR_WIDTH = 16
)
(
clock,
reset,
enable,
prbs
);

input clock;
input reset;
input enable;

output prbs;

reg [LFSR_WIDTH-1:0] start_state 
	 = {LFSR_WIDTH{1'b1}}  &  20'b1010_0000_0101_1010_1100;
reg [LFSR_WIDTH-1:0] lfsr;
wire next_bit;

//generate the PRBS-Signal
always @ (posedge clock or posedge reset)
	begin
		if(reset)
			lfsr[LFSR_WIDTH-1:0] <= start_state[LFSR_WIDTH-1:0];
		else
			if(enable)
				lfsr[LFSR_WIDTH-1:0] <= {lfsr[LFSR_WIDTH-2:0],next_bit};

	end

	assign prbs = next_bit;
	
//Selection of the feedback Polynom. Depends on Parameter of the module
generate
	case(LFSR_WIDTH)
		10:
			begin
			assign next_bit = lfsr[9]^lfsr[6];
			end
		11:
			begin
			assign next_bit = lfsr[10]^lfsr[8];
			end

		12:
			begin
			assign next_bit = ((lfsr[11]^lfsr[10])^lfsr[7])^lfsr[5];
			end

		13:
			begin
			assign next_bit = ((lfsr[12]^lfsr[11])^lfsr[9])^lfsr[5];
			end

		14:	
			begin
			assign next_bit = ((lfsr[8]^lfsr[10])^lfsr[12])^lfsr[13];
			end

		15:	
			begin
			assign next_bit = lfsr[14]^lfsr[13];
			end

		16:	
			begin
			assign next_bit = ((lfsr[15]^lfsr[13])^lfsr[12])^lfsr[10];
			end

		17:	
			begin
			assign next_bit = lfsr[16]^lfsr[13];
			end

		18:	
			begin
			assign next_bit = lfsr[17]^lfsr[10];
			end

		19:	
			begin
			assign next_bit = ((lfsr[13]^lfsr[16])^lfsr[17])^lfsr[18];
			end

		20:	
			begin
			assign next_bit = lfsr[19]^lfsr[16];
			end
			
		default:
			begin
				 LFSR_WIDTH_must_be_between_10_and_20 illegal_parameter_value();
			end

	endcase
endgenerate

endmodule
