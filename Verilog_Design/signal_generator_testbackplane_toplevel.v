module signal_generator_testbackplane_toplevel(
ledr,
ledg,
hex0,
hex1,
hex2,
hex3,
key,
sw,						
gpio1,
gpio0,
clk_50
);

inout [35:0]gpio1;

output [35:0]gpio0;


input wire [3:0] key; 	 
input wire [9:0] sw; 	
input clk_50;			// 50MHz CLK offered by quarz

output wire [9:0] ledr;
output wire [7:0] ledg;
output wire [6:0] hex0;
output wire [6:0] hex1;
output wire [6:0] hex2;
output wire [6:0] hex3;

wire clk_66;
wire clk_133;
wire clk_160;
wire global_clk;

wire sync_reset;
wire [3:0]sync_key;
wire [9:0]sync_sw;
wire [1:0]sync_frequency_select;
wire frequency_multiplex_reset;
wire toggle_flag;
wire [35:0]gpio1;

reg [1:0] sync_reset_register;


//PLL to increase frequency
 PLL PLL_instance(
	.areset(~key[0]),
	.inclk0(clk_50),
	.c0(clk_66),
	.c1(clk_133),
	.c2(clk_160),
	.locked()
	);
	

//Frequncy multiplexer which choose between 50MHz, 66,667MHz, 133,334MHz and 160MHz
assign global_clk = (sync_frequency_select[1:0] == 2'b00)?  clk_50 :
		((sync_frequency_select[1:0] == 2'b01) ? clk_66 :
		((sync_frequency_select[1:0] == 2'b10)? clk_133 :  clk_160 ));


//signal_generator_testbackplane module
signal_generator_testbackplane signal_generator_testbackplane_instance(
.error_led(ledg[7]),
.enable(sync_sw[4:0]), 
.reset(sync_reset),
.delay_select(sync_sw[6:5]),
.half_period(sync_sw[7]),
.noise_1(gpio1[13]),
.noise_2(gpio1[15]),
.noise_3(gpio1[19]),
.noise_4(gpio1[21]),
.noise_5(gpio1[29]),
.noise_6(gpio1[33]),
.hex0(hex0),
.hex1(hex1),
.hex2(hex2),
.hex3(hex3),
.data_pattern_tx(gpio1[17]),
.data_pattern_rx(gpio1[23]),
.data_pattern_rx_oszi(gpio0[27]),
.data_pattern_tx_oszi(gpio0[11]),
.clock_pattern_tx(gpio1[31]),
.clock_pattern_rx(gpio1[35]),
.clk(global_clk)
);

//modules for synchronise asynchronous signals

//switches
signal_synchroniser #(.width(10)) switch_synchroniser(
.clk(global_clk),
.reset(sync_reset),
.asynchron_signal_in(sw[9:0]),
.synchron_signal_out(sync_sw[9:0])
);

//keys
signal_synchroniser #(.width(4)) key_synchroniser(
.clk(global_clk),
.reset(sync_reset),
.asynchron_signal_in(key[3:0]),
.synchron_signal_out(sync_key[3:0])
);

//frequency select for multiplexer
signal_synchroniser #(.width(2)) frequency_select_synchroniser(
.clk(clk_50),
.reset(frequency_multiplex_reset),
.asynchron_signal_in(sw[9:8]),
.synchron_signal_out(sync_frequency_select[1:0])
);

//sychronise asynchronous reset for the frequency multiplexer
reset_synchroniser frequency_multiplex_reset_synchroniser(
.clk(clk_50),
.async_reset(~key[0]),
.sync_reset(frequency_multiplex_reset)
);

//sychronise asynchronous reset for the test_backpane_instance
reset_synchroniser global_reset_synchroniser(
.clk(global_clk),
.async_reset( ~key[0] | toggle_flag ),
.sync_reset(sync_reset)
);

//toggle_detector to see if the state of a switch got change to produce a reset
toggle_detector #(.width(2)) toggle_detector_instance (
.clk(clk_50),
.reset(frequency_multiplex_reset),
.signal(sync_frequency_select[1:0]), 
.toggle_flag(toggle_flag)		    
);

//assignments of the leds
assign ledg[2] = sync_sw[1] | sync_sw[0];
assign ledr[9:0] = sync_sw[9:0];
assign ledg[0] = sync_reset;


endmodule