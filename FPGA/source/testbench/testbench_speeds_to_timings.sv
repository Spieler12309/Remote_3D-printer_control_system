module testbench_speeds_to_timings();
localparam PERIOD = 10;

reg 								clk 						= 1'b0;
reg 								reset 					= 1'b0;
reg 								start 					= 1'b0;
reg	signed	[31:0]	num_x 					= 'd0;
reg	signed	[31:0]	num_y 					= 'd0;
reg	signed	[31:0]	num_z 					= 'd0;
reg	signed	[31:0]	num_e0 					= 'd0;
reg	signed	[31:0]	num_e1 					= 'd0;
reg					[31:0]	speed_x 				= 'd0;
reg					[31:0]	speed_y 				= 'd0;
reg					[31:0]	speed_z 				= 'd0;
reg					[31:0]	speed_e0 				= 'd0;
reg					[31:0]	speed_e1 				= 'd0;
reg					[31:0]	acceleration_x 	= 'd0;
reg					[31:0]	acceleration_y 	= 'd0;
reg					[31:0]	acceleration_z 	= 'd0;
reg					[31:0]	acceleration_e0 = 'd0;
reg					[31:0]	acceleration_e1 = 'd0;
reg					[31:0]	jerk_x 					= 'd0;
reg					[31:0]	jerk_y 					= 'd0;
reg					[31:0]	jerk_z 					= 'd0;
reg					[31:0]	jerk_e0 				= 'd0;
reg					[31:0]	jerk_e1 				= 'd0;

wire				[31:0]	params_x 	[0:4];
wire				[31:0]	params_y 	[0:4];
wire				[31:0]	params_z 	[0:4];
wire				[31:0]	params_e0 [0:4];
wire				[31:0]	params_e1 [0:4];
wire								finish;

speeds_to_timings stt1(
	.clk(clk),
	.reset(reset),
	.start(start),
	.num_x(num_x),
	.num_y(num_y),
	.num_z(num_z),
	.num_e0(num_e0),
	.num_e1(num_e1),
	.speed_x(speed_x),
	.speed_y(speed_y),
	.speed_z(speed_z),
	.speed_e0(speed_e0),
	.speed_e1(speed_e1),
	.acceleration_x(acceleration_x),
	.acceleration_y(acceleration_y),
	.acceleration_z(acceleration_z),
	.acceleration_e0(acceleration_e0),
	.acceleration_e1(acceleration_e1),
	.jerk_x(jerk_x),
	.jerk_y(jerk_y),
	.jerk_z(jerk_z),
	.jerk_e0(jerk_e0),
	.jerk_e1(jerk_e1),

	.params_x(params_x),
	.params_y(params_y),
	.params_z(params_z),
	.params_e0(params_e0),
	.params_e1(params_e1),
	.finish(finish)
	);

always
	#(PERIOD/2) clk = ~clk;

initial
begin
	num_x						= 2200;
	num_y						= 123;
	num_z						= 200;
	num_e0					= 532;
	num_e1					= 453;

	speed_x					= 100;
	speed_y					= 100;
	speed_z					= 100;
	speed_e0				= 100;
	speed_e1				= 100;

	acceleration_x	= 100;
	acceleration_y	= 100;
	acceleration_z	= 100;
	acceleration_e0	= 100;
	acceleration_e1	= 100;

	jerk_x					= 10;
	jerk_y					= 10;
	jerk_z					= 10;
	jerk_e0					= 10;
	jerk_e1					= 10;
	#10;

	start = 1;

	wait(finish);
	$display("calculating");
	$display("%0d \t %b X : N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
					$time, finish, params_x[0], params_x[1], params_x[2], params_x[3], params_x[4]);
	$display("%0d \t %b Y : N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
					$time, finish, params_y[0], params_y[1], params_y[2], params_y[3], params_y[4]);
	$display("%0d \t %b Z : N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
					$time, finish, params_z[0], params_z[1], params_z[2], params_z[3], params_z[4]);
	$display("%0d \t %b E0: N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
					$time, finish, params_e0[0], params_e0[1], params_e0[2], params_e0[3], params_e0[4]);
	$display("%0d \t %b E1: N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
							$time, finish, params_e1[0], params_e1[1], params_e1[2], params_e1[3], params_e1[4]);
	start = 0;
	#10;
	reset = 1;

	#10;
	$display("reset");
	$display("%0d \t %b X : N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
					$time, finish, params_x[0], params_x[1], params_x[2], params_x[3], params_x[4]);
	$display("%0d \t %b Y : N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
					$time, finish, params_y[0], params_y[1], params_y[2], params_y[3], params_y[4]);
	$display("%0d \t %b Z : N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
					$time, finish, params_z[0], params_z[1], params_z[2], params_z[3], params_z[4]);
	$display("%0d \t %b E0: N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
					$time, finish, params_e0[0], params_e0[1], params_e0[2], params_e0[3], params_e0[4]);
	$display("%0d \t %b E1: N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
							$time, finish, params_e1[0], params_e1[1], params_e1[2], params_e1[3], params_e1[4]);

	$stop;
end

endmodule
