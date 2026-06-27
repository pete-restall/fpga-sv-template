`ifndef __NET_RESTALL_FPGA_PROOFRUNNER_H_SV
`define __NET_RESTALL_FPGA_PROOFRUNNER_H_SV

`define BEGIN_PROOF \
	bit __yosys_global_clock; \
	bit __proof_sync_reset; \
	bit __proof_clock; \
	bit[31:0] __proof_past; \
	bit[31:0] __proof_past_after_reset; \
\
	ProofRunner __proof_runner ( \
		.proof_clock(__proof_clock), \
		.sync_reset(__proof_sync_reset), \
		.past(__proof_past), \
		.past_after_reset(__proof_past_after_reset) \
	);

`define ALWAYS_PROOF_TIMESTEP (* __yosys_always_$global_clock *) always @(__yosys_global_clock)

`endif
