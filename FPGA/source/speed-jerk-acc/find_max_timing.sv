module find_max_timing(	
	input		wire				clk,
	input		wire				reset,
	input		wire				start,
	input		wire	[31:0]	params_a [0:4],
	input		wire	[31:0]	params_b [0:4],
	input		wire	[31:0]	params_z [0:4],
	input		wire	[31:0]	params_e [0:4],
	
	input		wire	[63:0]	timing_a	[0:3],
	input		wire	[63:0]	timing_b	[0:3],
	input		wire	[63:0]	timing_z	[0:3],
	input		wire	[63:0]	timing_e	[0:3],


	output	wire	[63:0]	max_timing 	[0:3],
	output	wire	[31:0]	max_params [0:4],
	output	reg				finish	
	);

always @(posedge clk)
begin
	if (reset)
	begin
		max_timing[0] <= 'd0;
		max_timing[1] <= 'd0;
		max_timing[2] <= 'd0;
		max_timing[3] <= 'd0;
		finish		  <= 'b0;
	end
	else
	begin
		if (timing_a[3] > timing_b[3] && timing_a[3] > timing_z[3] && timing_a[3] > timing_e[3])
		begin
			max_params = params_a;
			max_timing = timing_a;
		end
		else
		begin
			if (timing_b[3] > timing_a[3] && timing_b[3] > timing_z[3] && timing_b[3] > timing_e[3])
			begin
				max_params = params_b;
				max_timing = timing_b;
			end
			else
			begin
				if (timing_z[3] > timing_b[3] && timing_z[3] > timing_a[3] && timing_z[3] > timing_e[3])
				begin
					max_params = params_z;
					max_timing = timing_z;
				end
				else
				begin
					max_params = params_e;
					max_timing = timing_e;
				end
			end
		end
	end
end
	
endmodule
