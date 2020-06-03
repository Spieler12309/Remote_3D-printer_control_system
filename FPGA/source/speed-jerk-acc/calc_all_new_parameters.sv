module calc_all_new_parameters(
	input		wire					clk,
	input		wire					reset,
	input		wire					start,	//Разрешение для вычисления
	input		wire					const_speed,
	input		wire	[31:0]	max_params 	[0:4],
	input		wire	[31:0]	params_x 		[0:4],
	input		wire	[31:0]	params_y 		[0:4],
	input		wire	[31:0]	params_z 		[0:4],
	input		wire	[31:0]	params_e0		[0:4],
	input		wire	[31:0]	params_e1		[0:4],
	input		wire	[63:0]	max_timing 	[0:3],	

	output	reg	[31:0]	new_par_x		[0:4],
	output	reg	[31:0]	new_par_y		[0:4],
	output	reg	[31:0]	new_par_z		[0:4],
	output	reg	[31:0]	new_par_e0	[0:4],
	output	reg	[31:0]	new_par_e1	[0:4],
	output	wire				finish
	);

reg						start_cnp;
reg		[31:0]	params			[0:4];
wire	[31:0]	new_params	[0:4];
wire					fin;

reg		[4:0]		fins;
reg		[15:0]	w;

assign finish = fins[0] & fins[1] & fins[2] & fins[3] & fins[4];

calc_new_parameters cnp(
	.clk(clk),
	.reset(reset),
	.start(start_cnp),
	.const_speed(const_speed),
	.max_params(max_params),
	.params(params),
	.max_timing(max_timing),
	
	.new_par(new_params),
	.finish(fin)
	);

initial
begin
	new_par_x[0] <= 'd0;
	new_par_x[1] <= 'd0;
	new_par_x[2] <= 'd0;
	new_par_x[3] <= 'd0;
	new_par_x[4] <= 'd0;

	new_par_y[0] <= 'd0;
	new_par_y[1] <= 'd0;
	new_par_y[2] <= 'd0;
	new_par_y[3] <= 'd0;
	new_par_y[4] <= 'd0;

	new_par_z[0] <= 'd0;
	new_par_z[1] <= 'd0;
	new_par_z[2] <= 'd0;
	new_par_z[3] <= 'd0;
	new_par_z[4] <= 'd0;

	new_par_e0[0] <= 'd0;
	new_par_e0[1] <= 'd0;
	new_par_e0[2] <= 'd0;
	new_par_e0[3] <= 'd0;
	new_par_e0[4] <= 'd0;

	new_par_e1[0] <= 'd0;
	new_par_e1[1] <= 'd0;
	new_par_e1[2] <= 'd0;
	new_par_e1[3] <= 'd0;
	new_par_e1[4] <= 'd0;

	params[0] <= 'd0;
	params[1] <= 'd0;
	params[2] <= 'd0;
	params[3] <= 'd0;
	params[4] <= 'd0;

	w <= 'd0;
	start_cnp <= 1'b0;
	fins <= 'd0;
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
					params <= params_x;
					start_cnp <= 1'b1;
				end
				else
				begin
					if (fins[1] == 1'b0)
					begin
						params <= params_y;
						start_cnp <= 1'b1;
					end
					else
					begin
						if (fins[2] == 1'b0)
						begin
							params <= params_z;
							start_cnp <= 1'b1;
						end
						else
						begin
							if (fins[3] == 1'b0)
							begin
								params <= params_e0;
								start_cnp <= 1'b1;
							end
							else
							begin
								if (fins[4] == 1'b0)
								begin
									params <= params_e1;
									start_cnp <= 1'b1;
								end
								else
								begin
									start_cnp <= 1'b0;
									w <= 'd0;
								end
							end
						end
					end
				end
			end
			else
			begin		
				case (fins[0] + fins[1] + fins[2] + fins[3] + fins[4])
					0: new_par_x <= new_params; 
					1: new_par_y <= new_params;
					2: new_par_z <= new_params;
					3: new_par_e0 <= new_params;
					4: new_par_e1 <= new_params;
					default : start_cnp <= 1'b0;
				endcase
				fins <= fins << 1;
				fins[0] <= 1'b1;
				start_cnp <= 1'b0;
				w <= 'd20;
			end
		end
		else
		begin
			fins <= 5'b0;
			params[0] <= 'd0;
			params[1] <= 'd0;
			params[2] <= 'd0;
			params[3] <= 'd0;
			params[4] <= 'd0;
			w <= 'd0;
			start_cnp <= 1'b0;
		end
	end
	else
	begin
		w <= w - 1;
	end
end

endmodule
