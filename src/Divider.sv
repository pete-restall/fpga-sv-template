`default_nettype none

module Divider #(
	parameter integer DIVISOR
)(
	input bit clock,
	input bit sync_reset,
	output bit toggle
);
	if (DIVISOR < 1) $fatal(1, "Divisor must be at least 1");

	bit[$clog2(DIVISOR):0] counter;
	always @(posedge clock) begin
		if (sync_reset || counter == 0) begin
			toggle <= !sync_reset && !toggle;
			counter <= (DIVISOR - 1);
		end else begin
			counter <= counter - 1;
		end
	end
endmodule
