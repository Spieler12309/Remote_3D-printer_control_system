`include "../configuration.vh"
`timescale 1ns/1ns

module testbench_jerk_acc_speed();

localparam PERIOD = 100;
integer motor_x;
integer motor_y;
integer motor_z;
integer motor_e0;
integer motor_e1;
integer main_data;

reg										clk										= 'd0;
reg										reset									= 'd0;
reg						[31:0]	max_speed_x						= 'd0;
reg						[31:0]	max_speed_y						= 'd0;
reg						[31:0]	max_speed_z						= 'd0;
reg						[31:0]	max_speed_e0					= 'd0;
reg						[31:0]	max_speed_e1					= 'd0;
reg						[31:0]	acceleration_x				= 'd0;
reg						[31:0]	acceleration_y				= 'd0;
reg						[31:0]	acceleration_z				= 'd0;
reg						[31:0]	acceleration_e0				= 'd0;
reg						[31:0]	acceleration_e1				= 'd0;
reg						[31:0]	jerk_x								= 'd0;
reg						[31:0]	jerk_y								= 'd0;
reg						[31:0]	jerk_z								= 'd0;
reg						[31:0]	jerk_e0								= 'd0;
reg						[31:0]	jerk_e1								= 'd0;
reg										stepper_x_inversion		= 'd0;
reg										stepper_y_inversion		= 'd0;
reg										stepper_z_inversion		= 'd0;
reg										stepper_e0_inversion	= 'd0;
reg										stepper_e1_inversion	= 'd0;
reg						[31:0]	speed_x_main					= 'd0;
reg						[31:0]	speed_y_main					= 'd0;
reg						[31:0]	speed_z_main					= 'd0;
reg						[31:0]	speed_e0_main					= 'd0;
reg						[31:0]	speed_e1_main					= 'd0;
reg		signed	[31:0]	num_x_m								= 'd0;
reg		signed	[31:0]	num_y_m								= 'd0;
reg		signed	[31:0]	num_z_m								= 'd0;
reg		signed	[31:0]	num_e0_m							= 'd0;
reg		signed	[31:0]	num_e1_m							= 'd0;
reg										start_driving_main		= 'd0;
reg						[0:5]		endstops_nf						= 'd0;
reg										bar_end_nf						= 'd0;
reg										enable_steppers				= 'd0;
reg										disable_steppers			= 'd0;



wire	stepper_x_enable;
wire	stepper_x_step;
wire	stepper_x_direction;
wire	stepper_y_enable;
wire	stepper_y_step;
wire	stepper_y_direction;
wire	stepper_z_enable;
wire	stepper_z_step;
wire	stepper_z_direction;
wire	stepper_e0_enable;
wire	stepper_e0_step;
wire	stepper_e0_direction;
wire	stepper_e1_enable;
wire	stepper_e1_step;
wire	stepper_e1_direction;
wire	finish;
wire	error;
wire	signed	[31:0]	pos_x;
wire	signed	[31:0]	pos_y;
wire	signed	[31:0]	pos_z;
wire	signed	[31:0]	pos_e0;
wire	signed	[31:0]	pos_e1;

jerk_acc_speed jas1(
	.clk(clk),
	.reset(reset),
	.max_speed_x(max_speed_x),
	.max_speed_y(max_speed_y),
	.max_speed_z(max_speed_z),
	.max_speed_e0(max_speed_e0),
	.max_speed_e1(max_speed_e1),
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
	.stepper_x_inversion(stepper_x_inversion),
	.stepper_y_inversion(stepper_y_inversion),
	.stepper_z_inversion(stepper_z_inversion),
	.stepper_e0_inversion(stepper_e0_inversion),
	.stepper_e1_inversion(stepper_e1_inversion),
	.speed_x_main(speed_x_main),
	.speed_y_main(speed_y_main),
	.speed_z_main(speed_z_main),
	.speed_e0_main(speed_e0_main),
	.speed_e1_main(speed_e1_main),
	.num_x_m(num_x_m),
	.num_y_m(num_y_m),
	.num_z_m(num_z_m),
	.num_e0_m(num_e0_m),
	.num_e1_m(num_e1_m),
	.start_driving_main(start_driving_main),
	.endstops_nf(endstops_nf),
	.bar_end_nf(bar_end_nf),
	.enable_steppers(enable_steppers),
	.disable_steppers(disable_steppers),

	.stepper_x_enable(stepper_x_enable),
	.stepper_x_step(stepper_x_step),
	.stepper_x_direction(stepper_x_direction),
	.stepper_y_enable(stepper_y_enable),
	.stepper_y_step(stepper_y_step),
	.stepper_y_direction(stepper_y_direction),
	.stepper_z_enable(stepper_z_enable),
	.stepper_z_step(stepper_z_step),
	.stepper_z_direction(stepper_z_direction),
	.stepper_e0_enable(stepper_e0_enable),
	.stepper_e0_step(stepper_e0_step),
	.stepper_e0_direction(stepper_e0_direction),
	.stepper_e1_enable(stepper_e1_enable),
	.stepper_e1_step(stepper_e1_step),
	.stepper_e1_direction(stepper_e1_direction),
	.finish(finish),
	.error(error)
	);

positioning p1(
	.reset(reset),

	.stepper_x_enable(stepper_x_enable),
	.stepper_x_step(stepper_x_step),
	.stepper_x_direction(stepper_x_direction),
	.stepper_y_enable(stepper_y_enable),
	.stepper_y_step(stepper_y_step),
	.stepper_y_direction(stepper_y_direction),
	.stepper_z_enable(stepper_z_enable),
	.stepper_z_step(stepper_z_step),
	.stepper_z_direction(stepper_z_direction),
	.stepper_e0_enable(stepper_e0_enable),
	.stepper_e0_step(stepper_e0_step),
	.stepper_e0_direction(stepper_e0_direction),
	.stepper_e1_enable(stepper_e1_enable),
	.stepper_e1_step(stepper_e1_step),
	.stepper_e1_direction(stepper_e1_direction),

	.stepper_x_set_new_coordinates(1'b0),
	.stepper_y_set_new_coordinates(1'b0),
	.stepper_z_set_new_coordinates(1'b0),
	.stepper_e0_set_new_coordinates(1'b0),
	.stepper_e1_set_new_coordinates(1'b0),

	.new_pos_x('d00),
	.new_pos_y('d00),
	.new_pos_z('d00),
	.new_pos_e0('d00),
	.new_pos_e1('d00),
		
	.pos_x(pos_x),
	.pos_y(pos_y),
	.pos_z(pos_z),
	.pos_e0(pos_e0),
	.pos_e1(pos_e1)
);

always
	#(PERIOD/2) clk = ~clk;

initial
begin
	motor_x		= $fopen("motor_x.txt");
	motor_y		= $fopen("motor_y.txt");
	motor_z		= $fopen("motor_z.txt");
	motor_e0	= $fopen("motor_e0.txt");
	motor_e1	= $fopen("motor_e1.txt");
	main_data	= $fopen("main_data.txt");

	reset									= 'd0;
	max_speed_x						= 'd10000000;
	max_speed_y						= 'd10000000;
	max_speed_z						= 'd10000000;
	max_speed_e0					= 'd0;
	max_speed_e1					= 'd0;
	acceleration_x				= 'd0;
	acceleration_y				= 'd30555;
	acceleration_z				= 'd37500;
	acceleration_e0				= 'd0;
	acceleration_e1				= 'd0;
	jerk_x								= 'd1666;
	jerk_y								= 'd166;
	jerk_z								= 'd1666;
	jerk_e0								= 'd0;
	jerk_e1								= 'd0;
	stepper_x_inversion		= 'd0;
	stepper_y_inversion		= 'd0;
	stepper_z_inversion		= 'd0;
	stepper_e0_inversion	= 'd0;
	stepper_e1_inversion	= 'd0;
	speed_x_main					= 'd10000;
	speed_y_main					= 'd8333;
	speed_z_main					= 'd7500;
	speed_e0_main					= 'd0;
	speed_e1_main					= 'd0;
	num_x_m								= 'd81515;
	num_y_m								= 'd98466;
	num_z_m								= 'd78678;
	num_e0_m							= 'd0;
	num_e1_m							= 'd0;
	endstops_nf						= 'd0;
	bar_end_nf						= 'd0;
	enable_steppers				= 'd0;
	disable_steppers			= 'd0;

	#10;

	start_driving_main		= 1'b1;	

	wait(finish);
	$display("finished");
	$fclose(motor_x);
	$fclose(motor_y);
	$fclose(motor_z);
	$fclose(motor_e0);
	$fclose(motor_e1);
	$fclose(main_data);
	$stop;
end

always @(*)
begin
	$fdisplay(motor_x, "time = %8d, X:  en = %1b, step = %1b, dir = %1b, delta = %6d, x = %5d", 
		$time, stepper_x_enable,  stepper_x_step,  stepper_x_direction, jas1.jc_x.wait_step, pos_x);
end

always @(*)
begin
	$fdisplay(motor_y, "time = %8d, Y:  en = %1b, step = %1b, dir = %1b, delta = %6d, y = %5d", 
		$time, stepper_y_enable,  stepper_y_step,  stepper_y_direction, jas1.jc_y.wait_step, pos_y);
end

always @(*)
begin
	$fdisplay(motor_z, "time = %8d, Z:  en = %1b, step = %1b, dir = %1b, delta = %6d, z = %5d", 
		$time, stepper_z_enable,  stepper_z_step,  stepper_z_direction, jas1.jc_z.wait_step, pos_z);
end

always @(*)
begin
	$fdisplay(motor_e0, "time = %8d, E0:  en = %1b, step = %1b, dir = %1b, delta = %6d, e0 = %5d", 
		$time, stepper_e0_enable, stepper_e0_step, stepper_e0_direction, jas1.jc_e0.wait_step, pos_e0);
end

always @(*)
begin
	$fdisplay(motor_e1, "time = %8d, E1:  en = %1b, step = %1b, dir = %1b, delta = %6d, e1 = %5d", 
		$time, stepper_e1_enable, stepper_e1_step, stepper_e1_direction, jas1.jc_e1.wait_step, pos_e1);
end

always @(*)
begin
	$fdisplay(main_data, "const_speed: %1b", jas1.const_speed);
	$display("const_speed: %1b", jas1.const_speed);
end

always @(posedge jas1.fin_stt)
begin
	$fdisplay(main_data, "%10d \t jas1.fin_stt", $time);
	$display("%10d \t jas1.fin_stt", $time);
	$fdisplay(main_data, "X:  N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
		jas1.params_x[0],  jas1.params_x[1],  jas1.params_x[2],  jas1.params_x[3],  jas1.params_x[4]);
	$fdisplay(main_data, "Y:  N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
		jas1.params_y[0],  jas1.params_y[1],  jas1.params_y[2],  jas1.params_y[3],  jas1.params_y[4]);
	$fdisplay(main_data, "Z:  N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
		jas1.params_z[0],  jas1.params_z[1],  jas1.params_z[2],  jas1.params_z[3],  jas1.params_z[4]);
	$fdisplay(main_data, "E0: N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
		jas1.params_e0[0], jas1.params_e0[1], jas1.params_e0[2], jas1.params_e0[3], jas1.params_e0[4]);
	$fdisplay(main_data, "E1: N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
		jas1.params_e1[0], jas1.params_e1[1], jas1.params_e1[2], jas1.params_e1[3], jas1.params_e1[4]);
end

always @(posedge jas1.fin_ct)
begin
	$fdisplay(main_data, "%10d \t jas1.fin_ct", $time);
	$display("%10d \t jas1.fin_ct", $time);
	$fdisplay(main_data, "X:  t1 = %10d, t2 = %10d, t30 = %10d, tt = %10d", 
		jas1.timing_x[0],  jas1.timing_x[1],  jas1.timing_x[2],  jas1.timing_x[3]);
	$fdisplay(main_data, "Y:  t1 = %10d, t2 = %10d, t30 = %10d, tt = %10d", 
		jas1.timing_y[0],  jas1.timing_y[1],  jas1.timing_y[2],  jas1.timing_y[3]);
	$fdisplay(main_data, "Z:  t1 = %10d, t2 = %10d, t30 = %10d, tt = %10d", 
		jas1.timing_z[0],  jas1.timing_z[1],  jas1.timing_z[2],  jas1.timing_z[3]);
	$fdisplay(main_data, "E0: t1 = %10d, t2 = %10d, t30 = %10d, tt = %10d", 
		jas1.timing_e0[0], jas1.timing_e0[1], jas1.timing_e0[2], jas1.timing_e0[3]);
	$fdisplay(main_data, "E1: t1 = %10d, t2 = %10d, t30 = %10d, tt = %10d", 
		jas1.timing_e1[0], jas1.timing_e1[1], jas1.timing_e1[2], jas1.timing_e1[3]);
end

always @(posedge jas1.fin_fmt)
begin
	$fdisplay(main_data, "%10d \t jas1.fin_fmt", $time);
	$display("%10d \t jas1.fin_fmt", $time);
	$fdisplay(main_data, "max_params: N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
		jas1.max_params[0], jas1.max_params[1], jas1.max_params[2], jas1.max_params[3], jas1.max_params[4]);
	$fdisplay(main_data, "max_timing: t1 = %10d, t2 = %10d, t30 = %10d, tt = %10d", 
		jas1.max_timing[0],  jas1.max_timing[1],  jas1.max_timing[2],  jas1.max_timing[3]);
end

always @(posedge jas1.fin_canp)
begin
	$fdisplay(main_data, "%10d \t jas1.fin_canp", $time);
	$fdisplay(main_data, "X:  N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
		jas1.new_params_x[0],  jas1.new_params_x[1],  jas1.new_params_x[2],  jas1.new_params_x[3],  jas1.new_params_x[4]);
	$fdisplay(main_data, "Y:  N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
		jas1.new_params_y[0],  jas1.new_params_y[1],  jas1.new_params_y[2],  jas1.new_params_y[3],  jas1.new_params_y[4]);
	$fdisplay(main_data, "Z:  N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
		jas1.new_params_z[0],  jas1.new_params_z[1],  jas1.new_params_z[2],  jas1.new_params_z[3],  jas1.new_params_z[4]);
	$fdisplay(main_data, "E0: N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
		jas1.new_params_e0[0], jas1.new_params_e0[1], jas1.new_params_e0[2], jas1.new_params_e0[3], jas1.new_params_e0[4]);
	$fdisplay(main_data, "E1: N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
		jas1.new_params_e1[0], jas1.new_params_e1[1], jas1.new_params_e1[2], jas1.new_params_e1[3], jas1.new_params_e1[4]);

	$display("%10d \t jas1.fin_canp", $time);
end

always @(posedge jas1.fin_jc_x)
begin
	//$fdisplay(main_data, "%10d \t jas1.fin_jc_x", $time);
	$display("%10d \t jas1.fin_jc_x", $time);
end

always @(posedge jas1.fin_jc_y)
begin
	//$fdisplay(main_data, "%10d \t jas1.fin_jc_y", $time);
	$display("%10d \t jas1.fin_jc_y", $time);
end

always @(posedge jas1.fin_jc_z)
begin
	//$fdisplay(main_data, "%10d \t jas1.fin_jc_z", $time);
	$display("%10d \t jas1.fin_jc_z", $time);
end

always @(posedge jas1.fin_jc_e0)
begin
	//$fdisplay(main_data, "%10d \t jas1.fin_jc_e0", $time);
	$display("%10d \t jas1.fin_jc_e0", $time);
end

always @(posedge jas1.fin_jc_e1)
begin
	//$fdisplay(main_data, "%10d \t jas1.fin_jc_e1", $time);
	$display("%10d \t jas1.fin_jc_e1", $time);
end

endmodule
