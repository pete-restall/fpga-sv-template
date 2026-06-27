`default_nettype none

`define STRINGIFY(x) `"`x`"

module TestbenchRunner #(
	parameter integer TIMEOUT_CLOCKS = 1024
)(
	output bit clock,
	output bit sync_reset
);
	string test_name;
	integer number_of_tests;
	integer number_of_failed_tests;
	bit all_tests_run;

	initial begin
		sync_reset <= 1;
		clock <= 0;

		test_name = "<none>";
		number_of_tests = 0;
		number_of_failed_tests = 0;
		all_tests_run = 0;

		`ifdef _DUMP_FILENAME
			$dumpfile(`STRINGIFY(_DUMP_FILENAME));
			$dumpvars(0);
		`endif
	end

	initial clock_stimuli(TIMEOUT_CLOCKS, 10ns);

	task clock_stimuli(integer timeout_clocks, time clock_period);
		integer i;

		fail_if(clock_period < 1, "'clock_period' has an invalid value; missing `timespec, perhaps (sv2v removes these) ?");
		for (i = 0; !all_tests_run && i <= timeout_clocks; i += 1) begin
			clock <= 1;
			#(clock_period / 2ns);
			clock <= 0;
			#(clock_period - clock_period / 2ns);
		end
		fail_if(!all_tests_run, "testbench ran for too long (infinite loop protection in 'clock_stimuli')");
	endtask

	task fail_if(bit has_failed, string reason);
		if (has_failed) begin
			$display("Failing because ", reason);
			$finish_and_return(1);
		end
	endtask

	task on_next_test(string name);
		test_name = name;
		number_of_tests += 1;
		$display("[TEST    ] %3d => %s", number_of_tests, test_name);
		reset();
	endtask

	task reset();
		sync_reset <= 1;
		@(posedge clock);
		@(negedge clock);
		sync_reset <= 0;
	endtask

	task on_test_passed();
		$display("[PASSED  ] ", test_name);
	endtask

	task on_test_failed();
		number_of_failed_tests += 1;
		$display("[FAILED  ] ", test_name);
	endtask

	task on_all_tests_run();
		all_tests_run = 1;
		$display(
			"[OUTCOME ] %0d tests run; %0d passed, %0d failed",
			test_runner.number_of_tests,
			(test_runner.number_of_tests - test_runner.number_of_failed_tests),
			test_runner.number_of_failed_tests);

		$finish_and_return(test_runner.number_of_failed_tests > 0 ? 1 : 0);
	endtask
endmodule
