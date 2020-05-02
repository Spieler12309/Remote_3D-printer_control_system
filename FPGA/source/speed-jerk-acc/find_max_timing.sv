module find_max_timing(	
	input		wire					clk,
	input		wire					reset,
	input		wire					start,
`ifdef DEBUG
	input		wire	[31:0]	params_x_0,
	input		wire	[31:0]	params_x_1,
	input		wire	[31:0]	params_x_2,
	input		wire	[31:0]	params_x_3,
	input		wire	[31:0]	params_x_4,

	input		wire	[31:0]	params_y_0,
	input		wire	[31:0]	params_y_1,
	input		wire	[31:0]	params_y_2,
	input		wire	[31:0]	params_y_3,
	input		wire	[31:0]	params_y_4,

	input		wire	[31:0]	params_z_0,
	input		wire	[31:0]	params_z_1,
	input		wire	[31:0]	params_z_2,
	input		wire	[31:0]	params_z_3,
	input		wire	[31:0]	params_z_4,

	input		wire	[31:0]	params_e0_0,
	input		wire	[31:0]	params_e0_1,
	input		wire	[31:0]	params_e0_2,
	input		wire	[31:0]	params_e0_3,
	input		wire	[31:0]	params_e0_4,

	input		wire	[31:0]	params_e1_0,
	input		wire	[31:0]	params_e1_1,
	input		wire	[31:0]	params_e1_2,
	input		wire	[31:0]	params_e1_3,
	input		wire	[31:0]	params_e1_4,
`else
	input		wire	[31:0]	params_x 		[0:4],
	input		wire	[31:0]	params_y 		[0:4],
	input		wire	[31:0]	params_z 		[0:4],
	input		wire	[31:0]	params_e0		[0:4],
	input		wire	[31:0]	params_e1		[0:4],
`endif
`ifdef DEBUG
	input		wire	[63:0]	timing_x_0,
	input		wire	[63:0]	timing_x_1,
	input		wire	[63:0]	timing_x_2,
	input		wire	[63:0]	timing_x_3,

	input		wire	[63:0]	timing_y_0,
	input		wire	[63:0]	timing_y_1,
	input		wire	[63:0]	timing_y_2,
	input		wire	[63:0]	timing_y_3,

	input		wire	[63:0]	timing_z_0,
	input		wire	[63:0]	timing_z_1,
	input		wire	[63:0]	timing_z_2,
	input		wire	[63:0]	timing_z_3,

	input		wire	[63:0]	timing_e0_0,
	input		wire	[63:0]	timing_e0_1,
	input		wire	[63:0]	timing_e0_2,
	input		wire	[63:0]	timing_e0_3,

	input		wire	[63:0]	timing_e1_0,
	input		wire	[63:0]	timing_e1_1,
	input		wire	[63:0]	timing_e1_2,
	input		wire	[63:0]	timing_e1_3,
`else
	input		wire	[63:0]	timing_x		[0:3],
	input		wire	[63:0]	timing_y		[0:3],
	input		wire	[63:0]	timing_z		[0:3],
	input		wire	[63:0]	timing_e0		[0:3],
	input		wire	[63:0]	timing_e1		[0:3],
`endif
	
`ifdef DEBUG
	output	wire	[63:0]	max_timing_0,
	output	wire	[63:0]	max_timing_1,
	output	wire	[63:0]	max_timing_2,
	output	wire	[63:0]	max_timing_3,

	output	wire	[31:0]	max_params_0,
	output	wire	[31:0]	max_params_1,
	output	wire	[31:0]	max_params_2,
	output	wire	[31:0]	max_params_3,
	output	wire	[31:0]	max_params_4,
`else
	output	reg		[63:0]	max_timing 	[0:3],
	output	reg		[31:0]	max_params 	[0:4],	
`endif	
	output	reg						finish	
	);

`ifdef DEBUG
	wire	[31:0]	params_x 		[0:4];
	wire	[31:0]	params_y 		[0:4];
	wire	[31:0]	params_z 		[0:4];
	wire	[31:0]	params_e0		[0:4];
	wire	[31:0]	params_e1		[0:4];

	assign params_x[0] = params_x_0;
	assign params_x[1] = params_x_1;
	assign params_x[2] = params_x_2;
	assign params_x[3] = params_x_3;
	assign params_x[4] = params_x_4;

	assign params_y[0] = params_y_0;
	assign params_y[1] = params_y_1;
	assign params_y[2] = params_y_2;
	assign params_y[3] = params_y_3;
	assign params_y[4] = params_y_4;

	assign params_z[0] = params_z_0;
	assign params_z[1] = params_z_1;
	assign params_z[2] = params_z_2;
	assign params_z[3] = params_z_3;
	assign params_z[4] = params_z_4;

	assign params_e0[0] = params_e0_0;
	assign params_e0[1] = params_e0_1;
	assign params_e0[2] = params_e0_2;
	assign params_e0[3] = params_e0_3;
	assign params_e0[4] = params_e0_4;

	assign params_e1[0] = params_e1_0;
	assign params_e1[1] = params_e1_1;
	assign params_e1[2] = params_e1_2;
	assign params_e1[3] = params_e1_3;
	assign params_e1[4] = params_e1_4;


	wire	[63:0]	timing_x 		[0:3];
	wire	[63:0]	timing_y 		[0:3];
	wire	[63:0]	timing_z 		[0:3];
	wire	[63:0]	timing_e0 	[0:3];
	wire	[63:0]	timing_e1 	[0:3];

	assign timing_x[0]  = timing_x_0;
	assign timing_x[1]  = timing_x_1;
	assign timing_x[2]  = timing_x_2;
	assign timing_x[3]  = timing_x_3;
	assign timing_y[0]  = timing_y_0;
	assign timing_y[1]  = timing_y_1;
	assign timing_y[2]  = timing_y_2;
	assign timing_y[3]  = timing_y_3;
	assign timing_z[0]  = timing_z_0;
	assign timing_z[1]  = timing_z_1;
	assign timing_z[2]  = timing_z_2;
	assign timing_z[3]  = timing_z_3;
	assign timing_e0[0] = timing_e0_0;
	assign timing_e0[1] = timing_e0_1;
	assign timing_e0[2] = timing_e0_2;
	assign timing_e0[3] = timing_e0_3;
	assign timing_e1[0] = timing_e1_0;
	assign timing_e1[1] = timing_e1_1;
	assign timing_e1[2] = timing_e1_2;
	assign timing_e1[3] = timing_e1_3;

	reg		[31:0]	max_params 	[0:4];
	reg		[63:0]	max_timing 	[0:3];
	assign max_params_0 = max_params[0];
	assign max_params_1 = max_params[1];
	assign max_params_2 = max_params[2];
	assign max_params_3 = max_params[3];
	assign max_params_4 = max_params[4];

	assign max_timing_0 = max_timing[0];
	assign max_timing_1 = max_timing[1];
	assign max_timing_2 = max_timing[2];
	assign max_timing_3 = max_timing[3];
`endif

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
				if (timing_x[3] > timing_y[3] && timing_x[3] > timing_z[3] && timing_x[3] > timing_e0[3] && timing_x[3] > timing_e1[3])
				begin
					max_params <= params_x;
					max_timing <= timing_x;
				end
				else
				begin
					if (timing_y[3] > timing_x[3] && timing_y[3] > timing_z[3] && timing_y[3] > timing_e0[3] && timing_y[3] > timing_e1[3])
					begin
						max_params <= params_y;
						max_timing <= timing_y;
					end
					else
					begin
						if (timing_z[3] > timing_x[3] && timing_z[3] > timing_y[3] && timing_z[3] > timing_e0[3] && timing_z[3] > timing_e1[3])
						begin
							max_params <= params_z;
							max_timing <= timing_z;
						end
						else
						begin
							if (timing_e0[3] > timing_x[3] && timing_e0[3] > timing_y[3] && timing_e0[3] > timing_z[3] && timing_e0[3] > timing_e1[3])
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
