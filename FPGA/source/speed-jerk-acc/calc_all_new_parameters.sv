//`define DEBUG //Расскомментировать для тестирования

module calc_all_new_parameters(
	input		wire					clk,
	input		wire					reset,
	input		wire					start,	//Разрешение для вычисления

`ifdef DEBUG
	input		wire	[31:0]	max_params_0,
	input		wire	[31:0]	max_params_1,
	input		wire	[31:0]	max_params_2,
	input		wire	[31:0]	max_params_3,
	input		wire	[31:0]	max_params_4,

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

	input		wire	[31:0]	max_timing_0,
	input		wire	[31:0]	max_timing_1,
	input		wire	[31:0]	max_timing_2,
	input		wire	[31:0]	max_timing_3,
`else
	input		wire	[31:0]	max_params 	[0:4],
	input		wire	[31:0]	params_x 		[0:4],
	input		wire	[31:0]	params_y 		[0:4],
	input		wire	[31:0]	params_z 		[0:4],
	input		wire	[31:0]	params_e0		[0:4],
	input		wire	[31:0]	params_e1		[0:4],
	input		wire	[63:0]	max_timing 	[0:3],	
`endif
	
`ifdef DEBUG
	output	wire	[31:0]	new_par_x_0,
	output	wire	[31:0]	new_par_x_1,
	output	wire	[31:0]	new_par_x_2,
	output	wire	[31:0]	new_par_x_3,
	output	wire	[31:0]	new_par_x_4,

	output	wire	[31:0]	new_par_y_0,
	output	wire	[31:0]	new_par_y_1,
	output	wire	[31:0]	new_par_y_2,
	output	wire	[31:0]	new_par_y_3,
	output	wire	[31:0]	new_par_y_4,

	output	wire	[31:0]	new_par_z_0,
	output	wire	[31:0]	new_par_z_1,
	output	wire	[31:0]	new_par_z_2,
	output	wire	[31:0]	new_par_z_3,
	output	wire	[31:0]	new_par_z_4,

	output	wire	[31:0]	new_par_e0_0,
	output	wire	[31:0]	new_par_e0_1,
	output	wire	[31:0]	new_par_e0_2,
	output	wire	[31:0]	new_par_e0_3,
	output	wire	[31:0]	new_par_e0_4,

	output	wire	[31:0]	new_par_e1_0,
	output	wire	[31:0]	new_par_e1_1,
	output	wire	[31:0]	new_par_e1_2,
	output	wire	[31:0]	new_par_e1_3,
	output	wire	[31:0]	new_par_e1_4,
`else
	output	reg	[31:0]	new_par_x		[0:4],
	output	reg	[31:0]	new_par_y		[0:4],
	output	reg	[31:0]	new_par_z		[0:4],
	output	reg	[31:0]	new_par_e0	[0:4],
	output	reg	[31:0]	new_par_e1	[0:4],
`endif
	output	wire				finish
	);

`ifdef DEBUG
	wire	[31:0]	max_params 	[0:4];
	wire	[31:0]	params_x 		[0:4];
	wire	[31:0]	params_y 		[0:4];
	wire	[31:0]	params_z 		[0:4];
	wire	[31:0]	params_e0		[0:4];
	wire	[31:0]	params_e1		[0:4];
	wire	[63:0]	max_timing 	[0:3];

	assign max_params[0] = max_params_0;
	assign max_params[1] = max_params_1;
	assign max_params[2] = max_params_2;
	assign max_params[3] = max_params_3;
	assign max_params[4] = max_params_4;

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

	assign max_timing[0] = max_timing_0;
	assign max_timing[1] = max_timing_1;
	assign max_timing[2] = max_timing_2;
	assign max_timing[3] = max_timing_3;


	reg	[31:0]	new_par_x		[0:4];
	reg	[31:0]	new_par_y		[0:4];
	reg	[31:0]	new_par_z		[0:4];
	reg	[31:0]	new_par_e0	[0:4];
	reg	[31:0]	new_par_e1	[0:4];

	assign new_par_x_0  = new_par_x[0];
	assign new_par_x_1  = new_par_x[1];
	assign new_par_x_2  = new_par_x[2];
	assign new_par_x_3  = new_par_x[3];
	assign new_par_x_4  = new_par_x[4];
 
	assign new_par_y_0  = new_par_y[0];
	assign new_par_y_1  = new_par_y[1];
	assign new_par_y_2  = new_par_y[2];
	assign new_par_y_3  = new_par_y[3];
	assign new_par_y_4  = new_par_y[4];
 
	assign new_par_z_0  = new_par_z[0];
	assign new_par_z_1  = new_par_z[1];
	assign new_par_z_2  = new_par_z[2];
	assign new_par_z_3  = new_par_z[3];
	assign new_par_z_4  = new_par_z[4];

	assign new_par_e0_0 = new_par_e0[0];
	assign new_par_e0_1 = new_par_e0[1];
	assign new_par_e0_2 = new_par_e0[2];
	assign new_par_e0_3 = new_par_e0[3];
	assign new_par_e0_4 = new_par_e0[4];

	assign new_par_e1_0 = new_par_e1[0];
	assign new_par_e1_1 = new_par_e1[1];
	assign new_par_e1_2 = new_par_e1[2];
	assign new_par_e1_3 = new_par_e1[3];
	assign new_par_e1_4 = new_par_e1[4];
`endif

reg						start_cnp;
reg		[31:0]	params			[0:4];
wire	[31:0]	new_params	[0:4];
wire					fin;

reg		[4:0]		fins;
reg		[15:0]	w;

initial
begin
	new_par_x[0]  = 'd0;
	new_par_x[1]  = 'd0;
	new_par_x[2]  = 'd0;
	new_par_x[3]  = 'd0;
	new_par_x[4]  = 'd0;
	new_par_y[0]  = 'd0;
	new_par_y[1]  = 'd0;
	new_par_y[2]  = 'd0;
	new_par_y[3]  = 'd0;
	new_par_y[4]  = 'd0;
	new_par_z[0]  = 'd0;
	new_par_z[1]  = 'd0;
	new_par_z[2]  = 'd0;
	new_par_z[3]  = 'd0;
	new_par_z[4]  = 'd0;
	new_par_e0[0] = 'd0;
	new_par_e0[1] = 'd0;
	new_par_e0[2] = 'd0;
	new_par_e0[3] = 'd0;
	new_par_e0[4] = 'd0;
	new_par_e1[0] = 'd0;
	new_par_e1[1] = 'd0;
	new_par_e1[2] = 'd0;
	new_par_e1[3] = 'd0;
	new_par_e1[4] = 'd0;

	fins = 'd0;
	w = 'd0;
end

assign finish = fins[0] & fins[1] & fins[2] & fins[3] & fins[4];

calc_new_parameters cnp(
	.clk(clk),
	.reset(reset),
	.start(start_cnp),
	.max_params(max_params),
	.params(params),
	.max_timing(max_timing),
	
	.new_par(new_params),
	.finish(fin)
	);

initial
begin
	new_par_x[0] = 'd0;
	new_par_x[1] = 'd0;
	new_par_x[2] = 'd0;
	new_par_x[3] = 'd0;
	new_par_x[4] = 'd0;

	new_par_y[0] = 'd0;
	new_par_y[1] = 'd0;
	new_par_y[2] = 'd0;
	new_par_y[3] = 'd0;
	new_par_y[4] = 'd0;

	new_par_z[0] = 'd0;
	new_par_z[1] = 'd0;
	new_par_z[2] = 'd0;
	new_par_z[3] = 'd0;
	new_par_z[4] = 'd0;

	new_par_e0[0] = 'd0;
	new_par_e0[1] = 'd0;
	new_par_e0[2] = 'd0;
	new_par_e0[3] = 'd0;
	new_par_e0[4] = 'd0;

	new_par_e1[0] = 'd0;
	new_par_e1[1] = 'd0;
	new_par_e1[2] = 'd0;
	new_par_e1[3] = 'd0;
	new_par_e1[4] = 'd0;

	params[0] = 'd0;
	params[1] = 'd0;
	params[2] = 'd0;
	params[3] = 'd0;
	params[4] = 'd0;

	w = 'd0;
	start_cnp = 1'b0;
	fins = 'd0;
end

always @(posedge clk)
begin
	if (w <= 0)
	begin
		if (start)
		begin
			if (~fin)
			begin
				if (fins[0] == 1'b0)
				begin
					params = params_x;
					start_cnp = 1'b1;
				end
				else
				begin
					if (fins[1] == 1'b0)
					begin
						params = params_y;
						start_cnp = 1'b1;
					end
					else
					begin
						if (fins[2] == 1'b0)
						begin
							params = params_z;
							start_cnp = 1'b1;
						end
						else
						begin
							if (fins[3] == 1'b0)
							begin
								params = params_e0;
								start_cnp = 1'b1;
							end
							else
							begin
								if (fins[4] == 1'b0)
								begin
									params = params_e1;
									start_cnp = 1'b1;
								end
								else
								begin
									start_cnp = 1'b0;
									w = 'd0;
								end
							end
						end
					end
				end
			end
			else
			begin		
				case (fins[0] + fins[1] + fins[2] + fins[3] + fins[4])
					0: new_par_x = new_params; 
					1: new_par_y = new_params;
					2: new_par_z = new_params;
					3: new_par_e0 = new_params;
					4: new_par_e1 = new_params;
					default : start_cnp = 1'b0;
				endcase
				fins = fins << 1;
				fins[0] = 1'b1;
				start_cnp = 1'b0;
				w = 'd20;
			end
		end
		else
		begin
			fins = 5'b0;
			params[0] = 'd0;
			params[1] = 'd0;
			params[2] = 'd0;
			params[3] = 'd0;
			params[4] = 'd0;
			w = 'd0;
			start_cnp = 1'b0;
		end
	end
	else
	begin
		w = w - 1;
	end
end

endmodule
