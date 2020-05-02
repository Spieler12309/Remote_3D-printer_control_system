//`define DEBUG //Расскомментировать для тестирования

module calc_new_parameters(
	input		wire					clk,
	input		wire					reset,
	input		wire					start,	//Разрешение для вычисления

`ifdef DEBUG
	input		wire	[31:0]	max_params_0,
	input		wire	[31:0]	max_params_1,
	input		wire	[31:0]	max_params_2,
	input		wire	[31:0]	max_params_3,
	input		wire	[31:0]	max_params_4,

	input		wire	[31:0]	params_0,
	input		wire	[31:0]	params_1,
	input		wire	[31:0]	params_2,
	input		wire	[31:0]	params_3,
	input		wire	[31:0]	params_4,

	input		wire	[63:0]	max_timing_0,
	input		wire	[63:0]	max_timing_1,
	input		wire	[63:0]	max_timing_2,
	input		wire	[63:0]	max_timing_3,
`else
	input		wire	[31:0]	max_params 	[0:4],
	input		wire	[31:0]	params 		[0:4],
	input		wire	[63:0]	max_timing 	[0:3],
`endif
	
`ifdef DEBUG
	output	wire	[31:0]	new_par_0,
	output	wire	[31:0]	new_par_1,
	output	wire	[31:0]	new_par_2,
	output	wire	[31:0]	new_par_3,
	output	wire	[31:0]	new_par_4,
`else
	output	reg		[31:0]	new_par		[0:4],
`endif
	output	reg						finish
	);

`ifdef DEBUG
	wire	[31:0]	max_params 	[0:4];
	wire	[31:0]	params 		[0:4];
	wire	[63:0]	max_timing 	[0:3];
	assign max_params[0] = max_params_0;
	assign max_params[1] = max_params_1;
	assign max_params[2] = max_params_2;
	assign max_params[3] = max_params_3;
	assign max_params[4] = max_params_4;

	assign params[0] = params_0;
	assign params[1] = params_1;
	assign params[2] = params_2;
	assign params[3] = params_3;
	assign params[4] = params_4;

	assign max_timing[0] = max_timing_0;
	assign max_timing[1] = max_timing_1;
	assign max_timing[2] = max_timing_2;
	assign max_timing[3] = max_timing_3;

	reg	[31:0]	new_par		[0:4];
	assign new_par_0 = new_par[0];
	assign new_par_1 = new_par[1];
	assign new_par_2 = new_par[2];
	assign new_par_3 = new_par[3];
	assign new_par_4 = new_par[4];
`endif

reg	[63:0]	t1;
reg	[63:0]	t2;
reg	[63:0]	t3;
reg	[63:0]	tt;
reg	[31:0]	nn;
	
initial
begin
	new_par[0]  = 'd0;
	new_par[1]  = 'd0;
	new_par[2]  = 'd0;
	new_par[3]  = 'd0;
	new_par[4]  = 'd0;

	t1 = 0;
	t2 = 0;
	t3 = 0;
	tt = 0;
	nn = 0;
end

always @(posedge clk)
begin
	if (reset)
	begin
		new_par[0]	= 'd0;
		new_par[1]	= 'd0;
		new_par[2]	= 'd0;
		new_par[3]	= 'd0;
		new_par[4]	= 'd0;
		finish 			= 'b0;
	end
	else
	begin
		if (start)
		begin
			if (~finish)
			begin
				new_par[0] = params[0];
				new_par[1] = params[1];
				new_par[2] = params[2];
				new_par[3] = params[3];
				new_par[4] = params[4];

				//0   1   2   3     4
				//N, nn, t0, tna, delta
				
				// 0   1   2   3
				//t1, t2, t3, tt		

				t1 = max_timing[0];
				t2 = max_timing[1];
				t3 = max_timing[2];
				tt = max_timing[3];
				nn = max_params[1];
				if (max_params[0] >= ((nn << 1) + 'd2))
				begin
					if (new_par[0] == 'd0)
					begin
						new_par[1] = 'd0;
						new_par[3] = 'd0;
						new_par[2] = 'd0;
						new_par[4] = 'd0;
					end
					else
					begin
						if (new_par[0] == 1)
						begin
							new_par[1] = 'd1;
							new_par[3] = max_params[2];
							new_par[2] = tt;
							new_par[4] = max_params[3];
						end
						else
						begin
							if (new_par[0] == 2)
							begin
								 new_par[1] = 'd1;
								 new_par[3] = max_params[2];
								 new_par[2] = tt >> 1;
								 new_par[4] = new_par[1] - new_par[2];
							end
							else
							begin
								 new_par[1] = max_params[1] * new_par[0] / max_params[0];
								 if (new_par[1] == 0)
									  new_par[1] = 'd1;
								 
								 if ((new_par[0] - (new_par[1] << 1)) == 0)
									  new_par[3] = max_params[3];
								 else
									  new_par[3] = t2 / (new_par[0] - (new_par[1] << 1));
									  
								 new_par[2] = ((t1 << 1) - new_par[3] * (new_par[1] - 'd1)) / (new_par[1] + 'd1);
								 new_par[4] = (new_par[3] - new_par[2]) / new_par[1];
							end
						end
					end
				end
				else
				begin
					t1 = tt << 1;
					if (new_par[0] == 0)
					begin
						new_par[1] = 0;
						new_par[2] = 0;
						new_par[3] = 0;
						new_par[4] = 0;
					end
					else
					begin
						if (new_par[0] == 1)
						begin
							new_par[1] = 'd1;
							new_par[3] = max_params[2];
							new_par[2] = tt;
							new_par[4] = max_params[3];
						end
						else
						begin
							if (new_par[0] == 2)
							begin
								new_par[1] = 'd1;
								new_par[3] = max_params[2];
								new_par[2] = tt << 1;
								new_par[4] = new_par[1] - new_par[2];
							end
							else
							begin
								 new_par[1] = new_par[0] << 1;
								 if (new_par[1] == 0)
									  new_par[1] = 'd1;
									  
								 new_par[3] = max_params[2] + max_params[4] * (max_params[0] << 1);
								 new_par[2] = ((t1 << 1) - new_par[3] * (new_par[1] - 1)) / (new_par[1] + 1);
								 new_par[4] = (new_par[3] - new_par[2]) / new_par[1];
							end
						end
					end
				end
				finish	= 'b1;
			end
		end
		else
		begin
			new_par[0]	= 'd0;
			new_par[1]	= 'd0;
			new_par[2]	= 'd0;
			new_par[3]	= 'd0;
			new_par[4]	= 'd0;
			finish 			= 'b0;
		end
	end
end

endmodule
