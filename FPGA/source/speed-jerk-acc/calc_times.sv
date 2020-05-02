//`define DEBUG //Расскомментировать для тестирования

module calc_times(	
	input		wire				clk,
	input		wire				reset,
	input		wire				start,	//Сигнал начала ускорения

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
	output	wire	[63:0]	timing_x_0,
	output	wire	[63:0]	timing_x_1,
	output	wire	[63:0]	timing_x_2,
	output	wire	[63:0]	timing_x_3,

	output	wire	[63:0]	timing_y_0,
	output	wire	[63:0]	timing_y_1,
	output	wire	[63:0]	timing_y_2,
	output	wire	[63:0]	timing_y_3,

	output	wire	[63:0]	timing_z_0,
	output	wire	[63:0]	timing_z_1,
	output	wire	[63:0]	timing_z_2,
	output	wire	[63:0]	timing_z_3,

	output	wire	[63:0]	timing_e0_0,
	output	wire	[63:0]	timing_e0_1,
	output	wire	[63:0]	timing_e0_2,
	output	wire	[63:0]	timing_e0_3,

	output	wire	[63:0]	timing_e1_0,
	output	wire	[63:0]	timing_e1_1,
	output	wire	[63:0]	timing_e1_2,
	output	wire	[63:0]	timing_e1_3,
`else
	output	reg		[63:0]	timing_x 		[0:3],
	output	reg		[63:0]	timing_y 		[0:3],
	output	reg		[63:0]	timing_z 		[0:3],
	output	reg		[63:0]	timing_e0 	[0:3],
	output	reg		[63:0]	timing_e1 	[0:3],
`endif
	output	reg				finish	//Сигнал окончания движения
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


	reg	[63:0]	timing_x 		[0:3];
	reg	[63:0]	timing_y 		[0:3];
	reg	[63:0]	timing_z 		[0:3];
	reg	[63:0]	timing_e0 	[0:3];
	reg	[63:0]	timing_e1 	[0:3];

	assign timing_x_0  = timing_x[0];
	assign timing_x_1  = timing_x[1];
	assign timing_x_2  = timing_x[2];
	assign timing_x_3  = timing_x[3];
 
	assign timing_y_0  = timing_y[0];
	assign timing_y_1  = timing_y[1];
	assign timing_y_2  = timing_y[2];
	assign timing_y_3  = timing_y[3];
 
	assign timing_z_0  = timing_z[0];
	assign timing_z_1  = timing_z[1];
	assign timing_z_2  = timing_z[2];
	assign timing_z_3  = timing_z[3];

	assign timing_e0_0 = timing_e0[0];
	assign timing_e0_1 = timing_e0[1];
	assign timing_e0_2 = timing_e0[2];
	assign timing_e0_3 = timing_e0[3];

	assign timing_e1_0 = timing_e1[0];
	assign timing_e1_1 = timing_e1[1];
	assign timing_e1_2 = timing_e1[2];
	assign timing_e1_3 = timing_e1[3];
`endif

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
				w = 'd20;
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

endmodule
