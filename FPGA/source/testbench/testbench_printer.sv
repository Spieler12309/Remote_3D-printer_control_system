`include "../configuration.vh"
`timescale 1ns/1ns

module testbench_printer();

integer motor_x;
integer motor_y;
integer motor_z;
integer motor_e0;
integer motor_e1;
integer main_data;

wire	[1:0]		KEY;
wire	[7:0]		LED;
wire	[3:0]		SW;


//Декларация основных сигнальных кабелей
wire	[0:2]		heaters;
wire	[0:2]		motors	[0:4]; //{enable, step, dir}
reg		[0:5]		endstops;
reg						bar_end;
reg		[11:0]	temp		[0:2];
wire	[11:0]	temp_0;
wire	[11:0]	temp_1;
wire	[11:0]	temp_2;
reg	[31:0]	command_type;
reg	signed [31:0]	command_x;
reg	signed [31:0]	command_y;
reg	signed [31:0]	command_z;
reg	signed [31:0]	command_e0;
reg	signed [31:0]	command_e1;
wire	[31:0]	new_command_x;
wire	[31:0]	new_command_y;
wire	[31:0]	new_command_z;
wire	[31:0]	new_command_e0;
wire	[31:0]	new_command_e1;
reg	[31:0]	command_f_x;
reg	[31:0]	command_f_y;
reg	[31:0]	command_f_z;
reg	[31:0]	command_f_e0;
reg	[31:0]	command_f_e1;
reg	[11:0]	command_t;
reg	[11:0]	command_dt;
reg	[31:0]	settings_max_speed_e1;
reg	[31:0]	settings_max_speed_e0;
reg	[31:0]	settings_max_speed_z;
reg	[31:0]	settings_max_speed_y;
reg	[31:0]	settings_max_speed_x;
reg	[31:0]	settings_acceleration_x;
reg	[31:0]	settings_acceleration_y;
reg	[31:0]	settings_acceleration_z;
reg	[31:0]	settings_acceleration_e0;
reg	[31:0]	settings_acceleration_e1;
reg	[31:0]	settings_jerk_x;
reg	[31:0]	settings_jerk_e1;
reg	[31:0]	settings_jerk_e0;
reg	[31:0]	settings_jerk_z;
reg	[31:0]	settings_jerk_y;
reg	[11:0]	settings_max_temp_e0;
reg	[11:0]	settings_max_temp_e1;
reg	[11:0]	settings_max_temp_bed;

wire	[31:0]	flags_in;
reg 	[31:0] 	flags_out;

wire	signed	[31:0]	pos_x;
wire	signed	[31:0]	pos_y;
wire	signed	[31:0]	pos_z;
wire	signed	[31:0]	pos_e0;
wire	signed	[31:0]	pos_e1;
//Clocks
reg 	CLK_100MHz;
reg 	CLK_50MHz;
reg 	CLK_10MHz;
reg 	CLK_5MHz;
reg 	CLK_1MHz;
reg		reset;


wire					finish_driving;
wire					start_move;
wire					change_position;
wire	[0:2]		heaters_finish;
wire	[0:2]		start_heat;
wire	[0:2]		start_heat_long;
wire					enable_steppers;
wire					disable_steppers;
wire					cooling;

wire					is_related;
wire					is_related_extruder;


assign flags_in[0] = endstops[0];
assign flags_in[1] = endstops[1];
assign flags_in[2] = endstops[2];
assign flags_in[3] = endstops[3];
assign flags_in[4] = endstops[4];
assign flags_in[5] = endstops[5];
assign flags_in[6] = bar_end;

adctemp_temp att0(.clk(CLK_50MHz),
					.adc_temp(temp[0]),
					.res(100000),
					.voltage(33), //Напряжение, умноженное на k
					.k(10),
					.temp(temp_0));
adctemp_temp att1(.clk(CLK_50MHz),
					.adc_temp(temp[1]),
					.res(100000),
					.voltage(33), //Напряжение, умноженное на k
					.k(10),
					.temp(temp_1));
adctemp_temp att2(.clk(CLK_50MHz),
					.adc_temp(temp[2]),
					.res(100000),
					.voltage(33), //Напряжение, умноженное на k
					.k(10),
					.temp(temp_2));

assign flags_in[12] = heaters[0];
assign flags_in[13] = heaters[1];
assign flags_in[14] = heaters[2];
assign flags_in[15] = ~KEY[0];
assign flags_in[16] = ~KEY[1];
assign flags_in[17] = SW[0];
assign flags_in[18] = SW[1];
assign flags_in[19] = SW[2];
assign flags_in[20] = SW[3];

assign LED[0] = heaters[0];			//Идет нагрев 0
assign LED[1] = heaters[1];			//Идет нагрев 1
assign LED[2] = heaters[2];			//Идет нагрев 2
assign LED[3] = flags_out[0];	//run_command
assign LED[4] = flags_in[7];		//command_finish
assign LED[5] = flags_in[21];		//command_error
assign LED[6] = finish_driving;	//finish_driving
assign LED[7] = flags_in[22];		//driving_error

control_unit cu0(
	.clk(CLK_50MHz),
	.reset(reset),
	.start(flags_out[0]),
	.command_type(command_type),
	.command_x(command_x),
	.command_y(command_y),
	.command_z(command_z),
	.command_e0(command_e0),
	.command_e1(command_e1),
	.pos_x(pos_x),
	.pos_y(pos_y),
	.pos_z(pos_z),
	.pos_e0(pos_e0),
	.pos_e1(pos_e1),
	.finish_driving(finish_driving),	
	.heaters_finish(heaters_finish),
	
	.new_command_x(new_command_x),
	.new_command_y(new_command_y),
	.new_command_z(new_command_z),
	.new_command_e0(new_command_e0),
	.new_command_e1(new_command_e1),
	.is_realative(is_related),
	.is_realative_extruder(is_related_extruder),
	.start_move(start_move),
	.start_heat(start_heat),
	.start_heat_long(start_heat_long),
	//.change_position(),
	.enable_steppers(enable_steppers),
	.disable_steppers(disable_steppers),
	.start_cooling(cooling),
	.finish(flags_in[7]),
	.error(flags_in[21])
	);

positioning p0(
	.reset(reset),


	//Управляющие сигналы двигателей
	//Двигатель a
	.stepper_x_enable(motors[0][0]),
	.stepper_x_step(motors[0][1]),
	.stepper_x_direction(motors[0][2]),	
	
	//Двигатель b
	.stepper_y_enable(motors[1][0]),
	.stepper_y_step(motors[1][1]),
	.stepper_y_direction(motors[1][2]),	
	
	//Двигатель оси z
	.stepper_z_enable(motors[2][0]),
	.stepper_z_step(motors[2][1]),
	.stepper_z_direction(motors[2][2]),	
	
	//Двигатель экструдера 0 (подачи пластика)
	.stepper_e0_enable(motors[3][0]),
	.stepper_e0_step(motors[3][1]),
	.stepper_e0_direction(motors[3][2]),
	
	//Двигатель экструдера 1 (подачи пластика)
	.stepper_e1_enable(motors[4][0]),
	.stepper_e1_step(motors[4][1]),
	.stepper_e1_direction(motors[4][2]),
	
	//Сигналы для установки новых координат
	.stepper_x_set_new_coordinates(flags_out[13]),
	.stepper_y_set_new_coordinates(flags_out[14]),
	.stepper_z_set_new_coordinates(flags_out[15]),
	.stepper_e0_set_new_coordinates(flags_out[16]),
	.stepper_e1_set_new_coordinates(flags_out[17]),
	//Значения новых координат
	.new_pos_x(command_x),
	.new_pos_y(command_y),
	.new_pos_z(command_z),
	.new_pos_e0(command_e0),
	.new_pos_e1(command_e1),
		
	//Текущая позиция
	.pos_x(pos_x),
	.pos_y(pos_y),
	.pos_z(pos_z),
	.pos_e0(pos_e0),
	.pos_e1(pos_e1));

//Подключение модуля управления движением каретки
jerk_acc_speed jas0( 	
	.clk(CLK_50MHz),
	.reset(reset),	
	.max_speed_x(settings_max_speed_x), //микрошагов/сек
	.max_speed_y(settings_max_speed_y), //микрошагов/сек
	.max_speed_z(settings_max_speed_z), //микрошагов/сек
	.max_speed_e0(settings_max_speed_e0), //микрошагов/сек
	.max_speed_e1(settings_max_speed_e1), //микрошагов/сек
	.acceleration_x(settings_acceleration_x), //микрошагов/сек^2
	.acceleration_y(settings_acceleration_y), //микрошагов/сек^2
	.acceleration_z(settings_acceleration_z), //микрошагов/сек^2
	.acceleration_e0(settings_acceleration_e0), //микрошагов/сек^2
	.acceleration_e1(settings_acceleration_e1), //микрошагов/сек^2
	.jerk_x(settings_jerk_x), //микрошагов/сек
	.jerk_y(settings_jerk_y), //микрошагов/сек
	.jerk_z(settings_jerk_z), //микрошагов/сек
	.jerk_e0(settings_jerk_e0), //микрошагов/сек
	.jerk_e1(settings_jerk_e1), //микрошагов/сек
	.stepper_x_inversion(flags_out[1]),
	.stepper_y_inversion(flags_out[2]),
	.stepper_z_inversion(flags_out[3]),
	.stepper_e0_inversion(flags_out[4]),
	.stepper_e1_inversion(flags_out[5]),
	.speed_x_main(command_f_x), //микрошагов/сек
	.speed_y_main(command_f_y), //микрошагов/сек
	.speed_z_main(command_f_z), //микрошагов/сек
	.speed_e0_main(command_f_e0), //микрошагов/сек
	.speed_e1_main(command_f_e1), //микрошагов/сек
	.num_x_m(new_command_x), //микрошагов
	.num_y_m(new_command_y), //микрошагов
	.num_z_m(new_command_z), //микрошагов
	.num_e0_m(new_command_e0), //микрошагов
	.num_e1_m(new_command_e1), //микрошагов
	.start_driving_main(start_move),
	.endstops_nf(endstops),
	.bar_end_nf(bar_end),
	.enable_steppers(enable_steppers),
	.disable_steppers(disable_steppers),
	.stepper_x_enable(motors[0][0]),
	.stepper_x_step(motors[0][1]),
	.stepper_x_direction(motors[0][2]),	
	.stepper_y_enable(motors[1][0]),
	.stepper_y_step(motors[1][1]),
	.stepper_y_direction(motors[1][2]),	
	.stepper_z_enable(motors[2][0]),
	.stepper_z_step(motors[2][1]),
	.stepper_z_direction(motors[2][2]),
	.stepper_e0_enable(motors[3][0]),
	.stepper_e0_step(motors[3][1]),
	.stepper_e0_direction(motors[3][2]),
	.stepper_e1_enable(motors[4][0]),
	.stepper_e1_step(motors[4][1]),
	.stepper_e1_direction(motors[4][2]),
	.finish(finish_driving),
	.error(flags_in[22])
	);

heater_control hc0(	
	.clk(CLK_50MHz),
	.temp(temp[0]),
	.t(command_t),
	.dt(command_dt),
	.max_temp(settings_max_temp_e0),
	.heat(start_heat[0]),
	.heat_long(start_heat_long[0]),

	.enable_heater(heaters[0]),
	.f(heaters_finish[0]));

heater_control hc1(	
	.clk(CLK_50MHz),
	.temp(temp[1]),
	.t(command_t),
	.dt(command_dt),
	.max_temp(settings_max_temp_e1),
	.heat(start_heat[1]),
	.heat_long(start_heat_long[1]),

	.enable_heater(heaters[1]),
	.f(heaters_finish[1]));

heater_control hc2(	
	.clk(CLK_50MHz),
	.temp(temp[2]),
	.t(command_t),
	.dt(command_dt),
	.max_temp(settings_max_temp_bed),
	.heat(start_heat[2]),
	.heat_long(start_heat_long[2]),

	.enable_heater(heaters[2]),
	.f(heaters_finish[2]));

always
	#(10/2) CLK_100MHz = ~CLK_100MHz;
always
	#(20/2) CLK_50MHz = ~CLK_50MHz;
always
	#(100/2) CLK_10MHz = ~CLK_10MHz;
always
	#(200/2) CLK_5MHz = ~CLK_5MHz;
always
	#(1000/2) CLK_1MHz = ~CLK_1MHz;

initial
begin
	motor_x	 = $fopen("motor_x.txt");
	motor_y	 = $fopen("motor_y.txt");
	motor_z	 = $fopen("motor_z.txt");
	motor_e0 = $fopen("motor_e0.txt");
	motor_e1 = $fopen("motor_e1.txt");
	main_data = $fopen("main_data.txt");

	$fclose(motor_x	);
	$fclose(motor_y	);
	$fclose(motor_z	);
	$fclose(motor_e0);
	$fclose(motor_e1);
	$fclose(main_data);


	CLK_100MHz	= 1'b0;
	CLK_50MHz 	= 1'b0;
	CLK_10MHz 	= 1'b0;
	CLK_5MHz 		= 1'b0;
	CLK_1MHz 		= 1'b0;

	

	reset											= 'd0;
	#50;
	reset = 'd1;
	#100;
	reset = 'd0;
		
	settings_max_temp_e0			= 'd300;
	settings_max_temp_e1			= 'd300;
	settings_max_temp_bed 		= 'd300;

	settings_max_speed_x = 8000;
	settings_max_speed_y = 8000;
	settings_max_speed_z = 133333;
	settings_max_speed_e0 = 2666;
	settings_max_speed_e1 = 2666;

	settings_acceleration_x = 8000;
	settings_acceleration_y = 160000;
	settings_acceleration_z = 0;
	settings_acceleration_e0 = 80000;
	settings_acceleration_e1 = 80000;

	settings_jerk_x = 8000;
	settings_jerk_y = 8000;
	settings_jerk_z = 1333;
	settings_jerk_e0 = 2666;
	settings_jerk_e1 = 2666;

	#50;

	command_type = `GCODE_G91;
	#50;
	flags_out = 'd1;

	wait(flags_in[7]);
	#50;
	flags_out = 'd0;
	#1000;

	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "command GCODE_G91 finished\n");
	$fclose(main_data);

	command_type	= `GCODE_G1;
	command_x  = 240;
	command_y  = 80;
	command_z  = 0;
	command_e0 = 0;
	command_e1 = 0;

	command_f_x  = 8000;
	command_f_y  = 8000;
	command_f_z  = 1333;
	command_f_e0 = 2666;
	command_f_e1 = 2666;

	command_t			= 'd0;
	command_dt		= 'd1;

	#5;
	flags_out = 'd1;

	wait(flags_in[7]);
	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "command GCODE_G1 finished\n");
	$fclose(main_data);
	#100;
	flags_out = 'd0;
	#1000;

	command_type	= `GCODE_G1;
	command_x  = 400;
	command_y  = -240;
	command_z  = 0;
	command_e0 = 0;
	command_e1 = 0;

	command_f_x  = 8000;
	command_f_y  = 8000;
	command_f_z  = 1333;
	command_f_e0 = 2666;
	command_f_e1 = 2666;

	command_t			= 'd0;
	command_dt		= 'd1;

	#5;
	flags_out = 'd1;

	wait(flags_in[7]);
	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "command GCODE_G1 finished\n");
	$fclose(main_data);
	#100;
	flags_out = 'd0;
	#1000;

	command_type	= `GCODE_G1;
	command_x  = 0;
	command_y  = 0;
	command_z  = 0;
	command_e0 = 0;
	command_e1 = 0;

	command_f_x  = 8000;
	command_f_y  = 8000;
	command_f_z  = 1333;
	command_f_e0 = 2666;
	command_f_e1 = 2666;

	command_t			= 'd0;
	command_dt		= 'd1;

	#500;
	flags_out = 'd1;

	wait(flags_in[7]);
	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "command GCODE_G1 finished");
	$fclose(main_data);
	#100;
	flags_out = 'd0;
	#1000;

	$stop;
end

always @(posedge flags_in[7])
begin
	#100;
	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "time = %8d. Positions: X = %5d; Y = %5d; Z = %5d; E0 = %5d; E1 = %5d.", 
						$time, pos_x, pos_y, pos_z, pos_e0, pos_e1);
	$fclose(main_data);
end

always @(posedge motors[0][1])
begin
	#2;
	motor_x	= $fopen("motor_x.txt", "a");
	$fdisplay(motor_x, "time = %8d, X:  en = %1b, step = %1b, dir = %1b, delta = %6d, x = %5d", 
		$time, motors[0][0],  motors[0][1],  motors[0][2], jas0.jc_x.wait_step, pos_x);
	$fclose(motor_x);
end

always @(posedge motors[1][1])
begin
	#2;
	motor_y	= $fopen("motor_y.txt", "a");
	$fdisplay(motor_y, "time = %8d, Y:  en = %1b, step = %1b, dir = %1b, delta = %6d, y = %5d", 
		$time, motors[1][0],  motors[1][1],  motors[1][2], jas0.jc_y.wait_step, pos_y);
	$fclose(motor_y);
end

always @(posedge motors[2][1])
begin
	#2;
	motor_z	= $fopen("motor_z.txt", "a");
	$fdisplay(motor_z, "time = %8d, Z:  en = %1b, step = %1b, dir = %1b, delta = %6d, z = %5d", 
		$time, motors[2][0],  motors[2][1],  motors[2][2], jas0.jc_z.wait_step, pos_z);
	$fclose(motor_z);
end

always @(posedge motors[3][1])
begin
	#2;
	motor_e0	= $fopen("motor_e0.txt", "a");
	$fdisplay(motor_e0, "time = %8d, E0:  en = %1b, step = %1b, dir = %1b, delta = %6d, e0 = %5d", 
		$time, motors[3][0], motors[3][1], motors[3][2], jas0.jc_e0.wait_step, pos_e0);
	$fclose(motor_e0);
end

always @(posedge motors[4][1])
begin
	#2;
	motor_e1	= $fopen("motor_e1.txt", "a");
	$fdisplay(motor_e1, "time = %8d, E1:  en = %1b, step = %1b, dir = %1b, delta = %6d, e1 = %5d", 
		$time, motors[4][0], motors[4][1], motors[4][2], jas0.jc_e1.wait_step, pos_e1);
	$fclose(motor_e1);
end

always @(posedge jas0.fin_stt)
begin
	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "%10d \t jas0.fin_stt", $time);
	$display("%10d \t jas0.fin_stt", $time);
	$fdisplay(main_data, "X:  N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
		jas0.params_x[0],  jas0.params_x[1],  jas0.params_x[2],  jas0.params_x[3],  jas0.params_x[4]);
	$fdisplay(main_data, "Y:  N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
		jas0.params_y[0],  jas0.params_y[1],  jas0.params_y[2],  jas0.params_y[3],  jas0.params_y[4]);
	$fdisplay(main_data, "Z:  N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
		jas0.params_z[0],  jas0.params_z[1],  jas0.params_z[2],  jas0.params_z[3],  jas0.params_z[4]);
	$fdisplay(main_data, "E0: N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
		jas0.params_e0[0], jas0.params_e0[1], jas0.params_e0[2], jas0.params_e0[3], jas0.params_e0[4]);
	$fdisplay(main_data, "E1: N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
		jas0.params_e1[0], jas0.params_e1[1], jas0.params_e1[2], jas0.params_e1[3], jas0.params_e1[4]);
	$fclose(main_data);
end

always @(posedge jas0.fin_ct)
begin
	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "%10d \t jas0.fin_ct", $time);
	$display("%10d \t jas0.fin_ct", $time);
	$fdisplay(main_data, "X:  t1 = %10d, t2 = %10d, t30 = %10d, tt = %10d", 
		jas0.timing_x[0],  jas0.timing_x[1],  jas0.timing_x[2],  jas0.timing_x[3]);
	$fdisplay(main_data, "Y:  t1 = %10d, t2 = %10d, t30 = %10d, tt = %10d", 
		jas0.timing_y[0],  jas0.timing_y[1],  jas0.timing_y[2],  jas0.timing_y[3]);
	$fdisplay(main_data, "Z:  t1 = %10d, t2 = %10d, t30 = %10d, tt = %10d", 
		jas0.timing_z[0],  jas0.timing_z[1],  jas0.timing_z[2],  jas0.timing_z[3]);
	$fdisplay(main_data, "E0: t1 = %10d, t2 = %10d, t30 = %10d, tt = %10d", 
		jas0.timing_e0[0], jas0.timing_e0[1], jas0.timing_e0[2], jas0.timing_e0[3]);
	$fdisplay(main_data, "E1: t1 = %10d, t2 = %10d, t30 = %10d, tt = %10d", 
		jas0.timing_e1[0], jas0.timing_e1[1], jas0.timing_e1[2], jas0.timing_e1[3]);
	$fclose(main_data);
end

always @(posedge jas0.fin_fmt)
begin
	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "%10d \t jas0.fin_fmt", $time);
	$display("%10d \t jas0.fin_fmt", $time);
	$fdisplay(main_data, "max_params: N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
		jas0.max_params[0], jas0.max_params[1], jas0.max_params[2], jas0.max_params[3], jas0.max_params[4]);
	$fdisplay(main_data, "max_timing: t1 = %10d, t2 = %10d, t30 = %10d, tt = %10d", 
		jas0.max_timing[0],  jas0.max_timing[1],  jas0.max_timing[2],  jas0.max_timing[3]);
	$fclose(main_data);
end

always @(posedge jas0.fin_canp)
begin
	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "%10d \t jas0.fin_canp", $time);
	$fdisplay(main_data, "X:  N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
		jas0.new_params_x[0],  jas0.new_params_x[1],  jas0.new_params_x[2],  jas0.new_params_x[3],  jas0.new_params_x[4]);
	$fdisplay(main_data, "Y:  N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
		jas0.new_params_y[0],  jas0.new_params_y[1],  jas0.new_params_y[2],  jas0.new_params_y[3],  jas0.new_params_y[4]);
	$fdisplay(main_data, "Z:  N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
		jas0.new_params_z[0],  jas0.new_params_z[1],  jas0.new_params_z[2],  jas0.new_params_z[3],  jas0.new_params_z[4]);
	$fdisplay(main_data, "E0: N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
		jas0.new_params_e0[0], jas0.new_params_e0[1], jas0.new_params_e0[2], jas0.new_params_e0[3], jas0.new_params_e0[4]);
	$fdisplay(main_data, "E1: N = %10d, nn = %10d, t0 = %10d, tna = %10d, delta = %10d", 
		jas0.new_params_e1[0], jas0.new_params_e1[1], jas0.new_params_e1[2], jas0.new_params_e1[3], jas0.new_params_e1[4]);
	$fclose(main_data);

	$display("%10d \t jas0.fin_canp", $time);
end

always @(posedge jas0.fin_jc_x)
begin
	//$fdisplay(main_data, "%10d \t jas0.fin_jc_x", $time);
	$display("%10d \t jas0.fin_jc_x", $time);
end

always @(posedge jas0.fin_jc_y)
begin
	//$fdisplay(main_data, "%10d \t jas0.fin_jc_y", $time);
	$display("%10d \t jas0.fin_jc_y", $time);
end

always @(posedge jas0.fin_jc_z)
begin
	//$fdisplay(main_data, "%10d \t jas0.fin_jc_z", $time);
	$display("%10d \t jas0.fin_jc_z", $time);
end

always @(posedge jas0.fin_jc_e0)
begin
	//$fdisplay(main_data, "%10d \t jas0.fin_jc_e0", $time);
	$display("%10d \t jas0.fin_jc_e0", $time);
end

always @(posedge jas0.fin_jc_e1)
begin
	//$fdisplay(main_data, "%10d \t jas0.fin_jc_e1", $time);
	$display("%10d \t jas0.fin_jc_e1", $time);
end

endmodule
