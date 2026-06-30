`default_nettype none

`define ICE_CLK_HZ 12_000_000

module IceStick #(
	parameter integer DIVISOR_R = `ICE_CLK_HZ / 2,
	parameter integer DIVISOR_G = `ICE_CLK_HZ / 2
)(
	input bit ICE_CLK,

	output bit D1,
	output bit D2,
	output bit D3,
	output bit D4,
	output bit D5
);
	bit sync_reset;
	InternalReset reset_generator(
		.clock(ICE_CLK),
		.sync_reset(sync_reset)
	);

	Divider #(.DIVISOR(DIVISOR_R)) blink_r (.clock(ICE_CLK), .sync_reset(sync_reset), .toggle(D1));
	assign D3 = D1;
	assign D2 = !D1;
	assign D4 = D2;

	Divider #(.DIVISOR(DIVISOR_G)) blink_g (.clock(ICE_CLK), .sync_reset(sync_reset), .toggle(D5));

endmodule
