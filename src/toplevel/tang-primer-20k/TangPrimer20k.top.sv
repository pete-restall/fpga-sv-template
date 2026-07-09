`default_nettype none

`define H11_IOT27A_OSC_CK_HZ 27_000_000

module TangPrimer20k #(
	parameter integer DIVISOR = `H11_IOT27A_OSC_CK_HZ / 2
)(
	input bit H11_IOT27A_OSC_CK,

	output bit LVDS_RX2_N
);
	bit sync_reset;
	InternalReset reset_generator(
		.clock(H11_IOT27A_OSC_CK),
		.sync_reset(sync_reset)
	);

	Divider #(.DIVISOR(DIVISOR)) blink_orange_led4 (
		.clock(H11_IOT27A_OSC_CK),
		.sync_reset(sync_reset),
		.toggle(LVDS_RX2_N)
	);
endmodule
