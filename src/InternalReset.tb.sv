`default_nettype none

`include "TestbenchRunner.h.sv"

module InternalResetTestbench #(
	parameter integer NUMBER_OF_BITS = 3
);
	bit clock;
	bit sync_reset;

	TestbenchRunner test_runner (
		.clock(clock),
		.sync_reset(sync_reset)
	);

	`define NUMBER_OF_DUTS 3
	bit[`NUMBER_OF_DUTS - 1 : 0] dut_sync_resets;

	`BEGIN_TEST_SUITE(test_runner)
		`TEST(sync_reset__when_fewer_clocks_than_power_of_2__expect_1)
		`TEST(sync_reset__when_clocks_equal_to_power_of_2__expect_0)
		`TEST(sync_reset__when_clocks_greater_than_power_of_2__expect_0)
	`END_TEST_SUITE

	genvar i;
	generate
		for (i = 0; i < `NUMBER_OF_DUTS; i += 1) begin
			InternalReset #(
				.NUMBER_OF_BITS(NUMBER_OF_BITS)
			) dut (
				.clock(clock && i == __test_index),
				.sync_reset(dut_sync_resets[i])
			);
		end
	endgenerate

	task sync_reset__when_fewer_clocks_than_power_of_2__expect_1();
		repeat ((2 ** NUMBER_OF_BITS) - 1) begin
			@(posedge clock) `ASSERT(dut_sync_resets[0] == 1);
		end
	endtask

	task sync_reset__when_clocks_equal_to_power_of_2__expect_0();
		repeat ((2 ** NUMBER_OF_BITS) - 1) @(posedge clock);
		@(posedge clock) `ASSERT(dut_sync_resets[1] == 0);
	endtask

	task sync_reset__when_clocks_greater_than_power_of_2__expect_0();
		repeat ((2 ** NUMBER_OF_BITS)) @(posedge clock);
		repeat (2 ** (2 * NUMBER_OF_BITS)) begin
			@(posedge clock) `ASSERT(dut_sync_resets[2] == 0);
		end
	endtask
endmodule
