`ifndef __NET_RESTALL_FPGA_TESTBENCHRUNNER_H_SV
`define __NET_RESTALL_FPGA_TESTBENCHRUNNER_H_SV

`define BEGIN_TEST_SUITE(test_runner) \
	integer __test_number_of_failed_assertions; \
	integer __test_index; \
\
	initial if (`"test_runner`" != {"test", "_runner"}) begin \
		$display({"[COMPILATION ERROR] test_runner must be called 'test", "_runner' because iverilog does not fully support 'alias'"}); \
		$finish_and_return(1); \
	end \
\
	initial __test_run_all(); \
	task __test_run_all(); \
		__test_index = 0;

`define TEST(test) \
		__test_number_of_failed_assertions = 0; \
		test_runner.on_next_test(`"test`"); \
		test(); \
		if (__test_number_of_failed_assertions > 0) \
			test_runner.on_test_failed(); \
		else \
			test_runner.on_test_passed(); \
\
		__test_index += 1;

`define END_TEST_SUITE \
		test_runner.on_all_tests_run(); \
	endtask

`define ASSERT(predicate) \
	assert(predicate) else begin \
		__test_number_of_failed_assertions += 1; \
	end

`define ASSERT_BECAUSE(predicate, reason) \
	assert(predicate) else begin \
		$display("    because ", reason); \
		__test_number_of_failed_assertions += 1; \
	end

`endif
