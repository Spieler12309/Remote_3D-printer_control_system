module find_max_timing(	
	input		wire					clk,
	input		wire					reset,
	input		wire					start,
	input		wire	[31:0]	params_x 		[0:4],
	input		wire	[31:0]	params_y 		[0:4],
	input		wire	[31:0]	params_z 		[0:4],
	input		wire	[31:0]	params_e0		[0:4],
	input		wire	[31:0]	params_e1		[0:4],
	input		wire	[63:0]	timing_x		[0:3],
	input		wire	[63:0]	timing_y		[0:3],
	input		wire	[63:0]	timing_z		[0:3],
	input		wire	[63:0]	timing_e0		[0:3],
	input		wire	[63:0]	timing_e1		[0:3],

	output	reg		[63:0]	max_timing 	[0:3],
	output	reg		[31:0]	max_params 	[0:4],		
	output	reg						finish	
	);

initial
begin
	max_timing[0] <= 'd0;
	max_timing[1] <= 'd0;
	max_timing[2] <= 'd0;
	max_timing[3] <= 'd0;

	max_params[0] <= 'd0;
	max_params[1] <= 'd0;
	max_params[2] <= 'd0;
	max_params[3] <= 'd0;
	max_params[4] <= 'd0;
	finish		  <= 'b0;
end

always @(posedge clk)
begin
	if (reset)
	begin
		max_timing[0] <= 'd0;
		max_timing[1] <= 'd0;
		max_timing[2] <= 'd0;
		max_timing[3] <= 'd0;

		max_params[0] <= 'd0;
		max_params[1] <= 'd0;
		max_params[2] <= 'd0;
		max_params[3] <= 'd0;
		max_params[4] <= 'd0;
		finish		  	<= 'b0;
	end
	else
	begin
		if (start)
		begin
			if (~finish)
			begin
				if (timing_x[3] >= timing_y[3] && timing_x[3] >= timing_z[3] && timing_x[3] >= timing_e0[3] && timing_x[3] >= timing_e1[3])
				begin
					max_params <= params_x;
					max_timing <= timing_x;
				end
				else
				begin
					if (timing_y[3] >= timing_x[3] && timing_y[3] >= timing_z[3] && timing_y[3] >= timing_e0[3] && timing_y[3] >= timing_e1[3])
					begin
						max_params <= params_y;
						max_timing <= timing_y;
					end
					else
					begin
						if (timing_z[3] >= timing_x[3] && timing_z[3] >= timing_y[3] && timing_z[3] >= timing_e0[3] && timing_z[3] >= timing_e1[3])
						begin
							max_params <= params_z;
							max_timing <= timing_z;
						end
						else
						begin
							if (timing_e0[3] >= timing_x[3] && timing_e0[3] >= timing_y[3] && timing_e0[3] >= timing_z[3] && timing_e0[3] >= timing_e1[3])
							begin
								max_params <= params_e0;
								max_timing <= timing_e0;
							end
							else
							begin
								max_params <= params_e1;
								max_timing <= timing_e1;
							end
						end
					end
				end
				finish		  	<= 'b1;
			end
		end
		else
		begin
			max_timing[0] <= 'd0;
			max_timing[1] <= 'd0;
			max_timing[2] <= 'd0;
			max_timing[3] <= 'd0;

			max_params[0] <= 'd0;
			max_params[1] <= 'd0;
			max_params[2] <= 'd0;
			max_params[3] <= 'd0;
			max_params[4] <= 'd0;
			finish		  	<= 'b0;
		end
	end
end
	
endmodule
