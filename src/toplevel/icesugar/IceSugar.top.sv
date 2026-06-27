`default_nettype none

`define ICE_CLK_HZ 12_000_000

module IceSugar #(
	parameter integer DIVISOR_R = `ICE_CLK_HZ / 2,
	parameter integer DIVISOR_G = `ICE_CLK_HZ / 2,
	parameter integer DIVISOR_B = `ICE_CLK_HZ / 2
)(
	input bit ICE_CLK,

	output bit LED_G,
	output bit LED_R,
	output bit LED_B
);
	bit sync_reset;
	InternalReset reset_generator(
		.clock(ICE_CLK),
		.sync_reset(sync_reset)
	);

	Divider #(.DIVISOR(DIVISOR_R)) blink_r (.clock(ICE_CLK), .sync_reset(sync_reset), .toggle(LED_R));
	Divider #(.DIVISOR(DIVISOR_G)) blink_g (.clock(ICE_CLK), .sync_reset(sync_reset), .toggle(LED_G));
	Divider #(.DIVISOR(DIVISOR_B)) blink_b (.clock(ICE_CLK), .sync_reset(sync_reset), .toggle(LED_B));

endmodule
