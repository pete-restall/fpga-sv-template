`default_nettype none

`include "TestbenchRunner.h.sv"

module DividerTestbench #(
	parameter integer DIVISOR = 1
);
	bit clock;
	bit sync_reset;

	TestbenchRunner test_runner (
		.clock(clock),
		.sync_reset(sync_reset)
	);

	bit toggle;

	Divider #(
		.DIVISOR(DIVISOR)
	) dut (
		.clock(clock),
		.sync_reset(sync_reset),
		.toggle(toggle)
	);

	`BEGIN_TEST_SUITE(test_runner)
		`TEST(toggle__after_reset_when_fewer_clocks_than_divisor__expect_0)
		`TEST(toggle__after_reset_when_clocks_equal_to_divisor__expect_1)
		`TEST(toggle__after_first_toggle_when_fewer_clocks_than_divisor__expect_1)
		`TEST(toggle__after_first_toggle_when_clocks_equal_to_divisor__expect_0)
	`END_TEST_SUITE

	task toggle__after_reset_when_fewer_clocks_than_divisor__expect_0();
		repeat (DIVISOR) begin
			@(posedge clock) `ASSERT(toggle == 0);
		end
	endtask

	task toggle__after_reset_when_clocks_equal_to_divisor__expect_1();
		repeat (DIVISOR) @(posedge clock);
		@(posedge clock) `ASSERT(toggle == 1);
	endtask

	task toggle__after_first_toggle_when_fewer_clocks_than_divisor__expect_1();
		wait_for_toggle();
		repeat (DIVISOR - 1) begin
			@(posedge clock) `ASSERT(toggle == 1);
		end
	endtask

	task wait_for_toggle();
		bit initial_value;
		initial_value = toggle;
		do
			@(posedge clock);
		while (toggle == initial_value);
	endtask

	task toggle__after_first_toggle_when_clocks_equal_to_divisor__expect_0();
		wait_for_toggle();
		repeat (DIVISOR - 1) @(posedge clock);
		@(posedge clock) `ASSERT(toggle == 0);
	endtask
endmodule
