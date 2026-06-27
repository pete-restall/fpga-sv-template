`default_nettype none

module InternalReset #(
	parameter integer NUMBER_OF_BITS = 3
)(
	input bit clock,
	output bit sync_reset
);
	if (NUMBER_OF_BITS < 1 || NUMBER_OF_BITS > 16) $fatal(1, "Reset counter must be [1, 16] bits");

	bit[NUMBER_OF_BITS:0] counter;
	initial counter <= 0;
	always @(posedge clock) begin
		if (!counter[NUMBER_OF_BITS])
			counter <= counter + 1;
	end

	assign sync_reset = !counter[NUMBER_OF_BITS];
endmodule
