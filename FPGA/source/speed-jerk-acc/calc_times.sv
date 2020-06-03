module calc_times(	
	input		wire				clk,
	input		wire				reset,
	input		wire				start,	//Сигнал начала ускорения
	input		wire	[31:0]	params_x 		[0:4],
	input		wire	[31:0]	params_y 		[0:4],
	input		wire	[31:0]	params_z 		[0:4],
	input		wire	[31:0]	params_e0		[0:4],
	input		wire	[31:0]	params_e1		[0:4],

	output	reg		[63:0]	timing_x 		[0:3],
	output	reg		[63:0]	timing_y 		[0:3],
	output	reg		[63:0]	timing_z 		[0:3],
	output	reg		[63:0]	timing_e0 	[0:3],
	output	reg		[63:0]	timing_e1 	[0:3],
	output	reg				finish	//Сигнал окончания движения
	);

wire	[63:0]	timing 		[0:3];
reg						start_ct;
reg		[31:0]	params	[0:4];
wire					fin;

reg		[4:0]		fins;
reg		[15:0]	w;

initial
begin
	timing_x[0]  = 'd0;
	timing_x[1]  = 'd0;
	timing_x[2]  = 'd0;
	timing_x[3]  = 'd0;
	timing_y[0]  = 'd0;
	timing_y[1]  = 'd0;
	timing_y[2]  = 'd0;
	timing_y[3]  = 'd0;
	timing_z[0]  = 'd0;
	timing_z[1]  = 'd0;
	timing_z[2]  = 'd0;
	timing_z[3]  = 'd0;
	timing_e0[0] = 'd0;
	timing_e0[1] = 'd0;
	timing_e0[2] = 'd0;
	timing_e0[3] = 'd0;
	timing_e1[0] = 'd0;
	timing_e1[1] = 'd0;
	timing_e1[2] = 'd0;
	timing_e1[3] = 'd0;

	fins = 'd0;
	w = 'd0;
end

assign finish = fins[0] & fins[1] & fins[2] & fins[3] & fins[4];

calc_time ct(
	.clk(clk),
	.reset(reset),
	.start(start_ct),
	.params(params),
	
	.timing(timing),
	.finish(fin));

always @(posedge clk)
begin
	if (reset)
	begin
		fins <= 5'b0;
		start_ct <= 1'b0;
		params[0] <= 'd0;
		params[1] <= 'd0;
		params[2] <= 'd0;
		params[3] <= 'd0;
		params[4] <= 'd0;
		w = 'd0;

		timing_x[0]  = 'd0;
		timing_x[1]  = 'd0;
		timing_x[2]  = 'd0;
		timing_x[3]  = 'd0;
		timing_y[0]  = 'd0;
		timing_y[1]  = 'd0;
		timing_y[2]  = 'd0;
		timing_y[3]  = 'd0;
		timing_z[0]  = 'd0;
		timing_z[1]  = 'd0;
		timing_z[2]  = 'd0;
		timing_z[3]  = 'd0;
		timing_e0[0] = 'd0;
		timing_e0[1] = 'd0;
		timing_e0[2] = 'd0;
		timing_e0[3] = 'd0;
		timing_e1[0] = 'd0;
		timing_e1[1] = 'd0;
		timing_e1[2] = 'd0;
		timing_e1[3] = 'd0;
	end
	else
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
						start_ct = 1'b1;
					end
					else
					begin
						if (fins[1] == 1'b0)
						begin
							params = params_y;
							start_ct = 1'b1;
						end
						else
						begin
							if (fins[2] == 1'b0)
							begin
								params = params_z;
								start_ct = 1'b1;
							end
							else
							begin
								if (fins[3] == 1'b0)
								begin
									params = params_e0;
									start_ct = 1'b1;
								end
								else
								begin
									if (fins[4] == 1'b0)
									begin
										params = params_e1;
										start_ct = 1'b1;
									end
									else
									begin
										start_ct = 1'b0;
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
						0: timing_x = timing; 
						1: timing_y = timing; 
						2: timing_z = timing; 
						3: timing_e0 = timing; 
						4: timing_e1 = timing; 
						default : start_ct = 1'b0;
					endcase
					fins = fins << 1;
					fins[0] = 1'b1;
					start_ct = 1'b0;
					`ifdef DEBUG_cts
						w = 'd1;
					`else 
						w = 'd20;
					`endif
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
				start_ct <= 1'b0;
			end
		end
		else
		begin
			w = w - 1;
		end
	end
end

endmodule
