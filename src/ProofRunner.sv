`default_nettype none

module ProofRunner #(
	parameter bit[7:0] RESET_COUNTER = 4
)(
	output bit proof_clock,
	output bit sync_reset,
	output bit[31:0] past,
	output bit[31:0] past_after_reset
);
	bit has_sync_reset_done;

	initial begin
		assert(RESET_COUNTER != 0);
		assume(has_sync_reset_done == 0);
		assume(sync_reset == 1);
		assume(proof_clock == 0);
		assume(past == 0);
		assume(past_after_reset == 0);
	end

	bit __yosys_global_clock;
	(* __yosys_always_$global_clock *) always @(__yosys_global_clock) begin
		proof_clock <= !proof_clock;

		has_sync_reset_done <= past != 0 && ($fell(sync_reset) || (!sync_reset && $stable(sync_reset)));

		assert(!has_sync_reset_done || past >= RESET_COUNTER);
		assert(past != RESET_COUNTER || !$rose(sync_reset));
		assert(past_after_reset == 0 || past - past_after_reset == RESET_COUNTER);
		assert(sync_reset || past_after_reset > 0);

		cover(!proof_clock);
		cover(proof_clock);
	end

	always @(posedge proof_clock) begin
		assume(past + 1 != 0);

		past <= past + 1;
		if (past < RESET_COUNTER) begin
			sync_reset <= 1;
			past_after_reset <= 0;
		end else begin
			sync_reset <= 0;
			past_after_reset <= past_after_reset + 1;
		end

		assert(sync_reset || has_sync_reset_done);

		cover(!has_sync_reset_done);
		cover(has_sync_reset_done);

		cover(past == 0);
		cover(past > 0);

		cover(past_after_reset == 0);
		cover(past_after_reset > 0);

		cover(!sync_reset);
		cover(sync_reset);
	end
endmodule
