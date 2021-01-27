module signal_generator_testbackplane(
error_led,
enable,   
reset,
delay_select,
half_period,
noise_1,
noise_2,
noise_3,
noise_4,
noise_5,
noise_6,
hex0,
hex1,
hex2,
hex3,
data_pattern_tx,
data_pattern_rx,
data_pattern_rx_oszi,
data_pattern_tx_oszi,
clock_pattern_tx,
clock_pattern_rx,
clk
);

input clk;
input [4:0] enable;
input reset;
input data_pattern_rx;
input clock_pattern_rx;
input [1:0]delay_select;
input half_period;


output error_led;
output noise_1;
output noise_2;
output noise_3;
output noise_4;
output noise_5;
output noise_6;
output data_pattern_tx;
output data_pattern_rx_oszi;
output data_pattern_tx_oszi;
output clock_pattern_tx;
output wire [6:0] hex0;
output wire [6:0] hex1;
output wire [6:0] hex2;
output wire [6:0] hex3;

wire [15:0]errors;
wire data_pattern_tx_delayed;  // tx prbs data pattern after the delay module
wire sync_data_pattern_rx;
wire async_data_pattern_rx;

reg [1:0] data_pattern_rx_register;

assign data_pattern_tx_oszi = data_pattern_tx_delayed; //reference signal for oscilloscope messerement. gpio0[11]
assign data_pattern_rx_oszi = sync_data_pattern_rx; //recieved data is layed on the output. gpio0[27]


// module for producing Data_Pattern_tx_PRBS... parameter has to be between 10 and 20
PRBS #(14) Data_Pattern_tx_PRBS(.clock(clk),.reset(reset),.enable(enable[1]),.prbs(data_pattern_tx));


//uncomment for clock signal at data_tx and comment the line above

//assign data_pattern_tx = enable[1]? clk : 1'bz;



//module for clock signal tx... if not enabled clock pattern driver is set to tristate
assign clock_pattern_tx = enable[0]? clk : 1'bz;



//module for producing Noise PRBS... parameter has to be between 10 and 20
PRBS #(10) Noise_1_PRBS(.clock(clk),.reset(reset),.enable(enable[2]),.prbs(noise_1));
PRBS #(11) Noise_2_PRBS(.clock(clk),.reset(reset),.enable(enable[3]),.prbs(noise_2));
PRBS #(12) Noise_3_PRBS(.clock(clk),.reset(reset),.enable(enable[3]),.prbs(noise_3));
PRBS #(13) Noise_4_PRBS(.clock(clk),.reset(reset),.enable(enable[2]),.prbs(noise_4));
PRBS #(15) Noise_5_PRBS(.clock(clk),.reset(reset),.enable(enable[4]),.prbs(noise_5));
PRBS #(16) Noise_6_PRBS(.clock(clk),.reset(reset),.enable(enable[4]),.prbs(noise_6));



//delay for the clock tx and data tx
delay delay_instance (
.delay_select(delay_select[1:0]),
.signal_in(data_pattern_tx),
.signal_out(data_pattern_tx_delayed),
.clk(clk),
.reset(reset),
.enable(enable[1])
);


//module error counter for data pattern
error_counter data_error_counter_instance(
.pattern1(sync_data_pattern_rx),
.pattern2(data_pattern_tx_delayed),
.clock(clk),
.reset(reset),
.enable(enable[1]),		//enabled by the data tx enable
.errors(errors[15:0]),		// number of errors
.error_flag(error_led)	//is set when error counter is full
);


//7-Segment HEX display
HEX_display hex_display1(
.digit0(hex0),
.digit1(hex1),
.digit2(hex2),
.digit3(hex3),
.data(errors[15:0])
);

//handle the input signal

//input signal 
signal_synchroniser #(.width(1)) data_rx_synchroniser(
.clk(clk),
.reset(reset),
.asynchron_signal_in(async_data_pattern_rx),
.synchron_signal_out(sync_data_pattern_rx)
);


always @ (posedge clk or posedge reset)
begin
	if (reset)
		begin
		data_pattern_rx_register[0]<= 1'b0;
		end
	else
		begin
		data_pattern_rx_register[0]<= data_pattern_rx;
		end
end

always @ (negedge clk or posedge reset)
begin
	if (reset)
		begin
		data_pattern_rx_register[1]<= 1'b0;
		end
	else
		begin
		data_pattern_rx_register[1] <= data_pattern_rx;
		end
end

assign async_data_pattern_rx = half_period? data_pattern_rx_register[0] : data_pattern_rx_register[1];

endmodule