`default_nettype none

`define CLK_200M_HZ 200_000_000

module PuzhiPa35tStarlite #(
	parameter integer DIVISOR = `CLK_200M_HZ / 2
)(
	input bit CLK_P_200M,
	input bit CLK_N_200M,

	output bit LED1,
	output bit LED2
);
	bit sync_reset;
	InternalReset reset_generator(
		.clock(CLK_P_200M),
		.sync_reset(sync_reset)
	);

	bit led;
	assign {LED1, LED2} = {led, !led};

	Divider #(.DIVISOR(DIVISOR)) blink_led1 (
		.clock(CLK_P_200M),
		.sync_reset(sync_reset),
		.toggle(led)
	);
endmodule
