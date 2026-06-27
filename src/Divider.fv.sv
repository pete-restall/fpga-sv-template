`default_nettype none

`include "ProofRunner.h.sv"

module DividerProof #(
	parameter integer DIVISOR = 1
);
	`BEGIN_PROOF

	bit dut_clock;
	assign dut_clock = __proof_clock;

	bit dut_sync_reset;
	assign dut_sync_reset = __proof_sync_reset;

	bit dut_toggle;
	initial assume(dut_toggle == 0);

	Divider #(
		.DIVISOR(DIVISOR)
	) dut (
		.clock(dut_clock),
		.sync_reset(dut_sync_reset),
		.toggle(dut_toggle)
	);

	`ALWAYS_PROOF_TIMESTEP begin
		//expect_toggle_only_changes_on_rising_edge_of_clock:
			assert(__proof_past_after_reset == 0 || $rose(dut_clock) || $stable(dut_toggle));

		//expect_toggle_is_always_zero_whilst_held_in_reset:
			assert(!dut_sync_reset || !dut_toggle);
	end

	integer high_count;
	initial assume(high_count == 0);

	integer low_count;
	initial assume(low_count == 0);

	always @(posedge dut_clock) begin
		if (!dut_sync_reset) begin
			if (dut_toggle) begin
				high_count <= high_count + 1;
				low_count <= 0;
			end else begin
				high_count <= 0;
				low_count <= low_count + 1;
			end
		end else begin
			high_count <= 0;
			low_count <= 0;
		end

		assert(high_count >= 0 && high_count <= DIVISOR);
		assert(low_count >= 0 && low_count <= DIVISOR);
	end

	always @(posedge dut_clock) begin
		if (!dut_sync_reset) begin
			if ($rose(dut_toggle)) begin
				/*expect_toggle_goes_high_on_count_of_divisor:*/ assert(low_count == DIVISOR);
			end else if ($fell(dut_toggle)) begin
				/*expect_toggle_goes_low_on_count_of_divisor:*/ assert(high_count == DIVISOR);
			end
		end else begin
			assert(high_count == 0 && low_count == 0);
		end
	end

	always @(posedge dut_clock) begin
		/*expect_reset_is_covered:*/ cover(dut_sync_reset);
		/*expect_non_reset_is_covered:*/ cover(!dut_sync_reset);

		/*expect_at_least_one_low_to_high_toggle_is_covered:*/ cover(__proof_past_after_reset && $rose(dut_toggle));
		/*expect_at_least_one_high_to_low_toggle_is_covered:*/ cover(__proof_past_after_reset && $fell(dut_toggle));
	end
endmodule
