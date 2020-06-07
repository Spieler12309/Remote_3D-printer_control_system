`include "../configuration.vh"
`timescale 1ns/1ns

module testbench_printer();

integer motor_x;
integer motor_y;
integer motor_z;
integer motor_e0;
integer motor_e1;
integer main_data;
integer heater_0;
integer heater_1;
integer heater_2;

integer i;

reg [11:0] temps [0:159];
initial
begin
	temps[0]  = 1836;
	temps[1]  = 1729;
	temps[2]  = 1616;
	temps[3]  = 1508;
	temps[4]  = 1403;
	temps[5]  = 1297;
	temps[6]  = 1204;
	temps[7]  = 1109;
	temps[8]  = 1022;
	temps[9]  = 940;
	temps[10]  = 860;
	temps[11]  = 744;
	temps[12]  = 642;
	temps[13]  = 553;
	temps[14]  = 476;
	temps[15]  = 410;
	temps[16]  = 353;
	temps[17]  = 304;
	temps[18]  = 263;
	temps[19]  = 227;
	temps[20]  = 197;
	temps[21]  = 171;
	temps[22]  = 149;
	temps[23]  = 130;
	temps[24]  = 114;
	temps[25]  = 100;
	temps[26]  = 87;
	temps[27]  = 77;
	temps[28]  = 68;
	temps[29]  = 60;
	temps[30]  = 53;
	temps[31]  = 50;
	temps[32]  = 46;
	temps[33]  = 43;
	temps[34]  = 40;
	temps[35]  = 38;
	temps[36]  = 35;
	temps[37]  = 33;
	temps[38]  = 31;
	temps[39]  = 29;
	temps[40]  = 27;
	temps[41]  = 26;
	temps[42]  = 26;
	temps[43]  = 25;
	temps[44]  = 25;
	temps[45]  = 24;
	temps[46]  = 24;
	temps[47]  = 23;
	temps[48]  = 23;
	temps[49]  = 22;
	temps[50]  = 22;
	temps[51]  = 21;
	temps[52]  = 21;
	temps[53]  = 21;
	temps[54]  = 20;
	temps[55]  = 20;
	temps[56]  = 19;
	temps[57]  = 19;
	temps[58]  = 19;
	temps[59]  = 18;
	temps[60]  = 18;
	temps[61]  = 18;
	temps[62]  = 18;
	temps[63]  = 17;
	temps[64]  = 17;
	temps[65]  = 17;
	temps[66]  = 17;
	temps[67]  = 17;
	temps[68]  = 17;
	temps[69]  = 17;
	temps[70]  = 17;
	temps[71]  = 17;
	temps[72]  = 17;
	temps[73]  = 17;
	temps[74]  = 17;
	temps[75]  = 17;
	temps[76]  = 17;
	temps[77]  = 17;
	temps[78]  = 18;
	temps[79]  = 18;
	temps[80]  = 18;
	temps[81]  = 18;
	temps[82]  = 19;
	temps[83]  = 19;
	temps[84]  = 19;
	temps[85]  = 20;
	temps[86]  = 20;
	temps[87]  = 21;
	temps[88]  = 21;
	temps[89]  = 21;
	temps[90]  = 22;
	temps[91]  = 21;
	temps[92]  = 21;
	temps[93]  = 20;
	temps[94]  = 19;
	temps[95]  = 19;
	temps[96]  = 18;
	temps[97]  = 18;
	temps[98]  = 17;
	temps[99]  = 17;
	temps[100]  = 16;
	temps[101]  = 16;
	temps[102]  = 16;
	temps[103]  = 17;
	temps[104]  = 17;
	temps[105]  = 17;
	temps[106]  = 17;
	temps[107]  = 17;
	temps[108]  = 17;
	temps[109]  = 18;
	temps[110]  = 18;
	temps[111]  = 18;
	temps[112]  = 19;
	temps[113]  = 19;
	temps[114]  = 19;
	temps[115]  = 20;
	temps[116]  = 20;
	temps[117]  = 21;
	temps[118]  = 21;
	temps[119]  = 21;
	temps[120]  = 22;
	temps[121]  = 21;
	temps[122]  = 21;
	temps[123]  = 21;
	temps[124]  = 20;
	temps[125]  = 20;
	temps[126]  = 19;
	temps[127]  = 19;
	temps[128]  = 19;
	temps[129]  = 18;
	temps[130]  = 18;
	temps[131]  = 19;
	temps[132]  = 19;
	temps[133]  = 20;
	temps[134]  = 21;
	temps[135]  = 22;
	temps[136]  = 23;
	temps[137]  = 24;
	temps[138]  = 25;
	temps[139]  = 26;
	temps[140]  = 27;
	temps[141]  = 29;
	temps[142]  = 31;
	temps[143]  = 33;
	temps[144]  = 35;
	temps[145]  = 38;
	temps[146]  = 40;
	temps[147]  = 43;
	temps[148]  = 46;
	temps[149]  = 50;
	temps[150]  = 53;
	temps[151]  = 60;
	temps[152]  = 68;
	temps[153]  = 77;
	temps[154]  = 87;
	temps[155]  = 100;
	temps[156]  = 114;
	temps[157]  = 130;
	temps[158]  = 149;
	temps[159]  = 171;
end

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
					.reset(reset),
					.adc_temp(temp[0]),
					.temp(temp_0));
adctemp_temp att1(.clk(CLK_50MHz),
					.reset(reset),
					.adc_temp(temp[1]),
					.temp(temp_1));
adctemp_temp att2(.clk(CLK_50MHz),
					.reset(reset),
					.adc_temp(temp[2]),
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
	.reset(reset),
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
	.reset(reset),
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
	.reset(reset),
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

task resetSystem;
begin
	reset	= 'd0;
	#50;
	reset = 'd1;
	#50;
	reset = 'd0;
end
endtask : resetSystem

task setSettings();
begin
	settings_max_temp_e0			= 'd300;
	settings_max_temp_e1			= 'd300;
	settings_max_temp_bed 		= 'd300;

	settings_max_speed_x 			= 8000;
	settings_max_speed_y 			= 8000;
	settings_max_speed_z 			= 133333;
	settings_max_speed_e0 		= 2666;
	settings_max_speed_e1 		= 2666;

	settings_acceleration_x 	= 80000;
	settings_acceleration_y 	= 160000;
	settings_acceleration_z 	= 8000;
	settings_acceleration_e0 	= 80000;
	settings_acceleration_e1 	= 80000;

	settings_jerk_x 					= 1000;
	settings_jerk_y 					= 1000;
	settings_jerk_z 					= 1333;
	settings_jerk_e0 					= 1666;
	settings_jerk_e1 					= 1666;
end
endtask : setSettings

task zeroingInputs();
begin
	command_type	= `GCODE_G1;
	command_x  		= 0;
	command_y  		= 0;
	command_z  		= 0;
	command_e0 		= 0;
	command_e1 		= 0;

	command_f_x  	= 0;
	command_f_y  	= 0;
	command_f_z  	= 0;
	command_f_e0 	= 0;
	command_f_e1 	= 0;

	command_t			= 0;
	command_dt		= 0;
end
endtask : zeroingInputs

task runG1;
input		signed 	[31:0]	x;
input		signed 	[31:0]	y;
input		signed 	[31:0]	z;
input		signed 	[31:0]	e0;
input		signed 	[31:0]	e1;

input						[31:0]	f_x;
input						[31:0]	f_y;
input						[31:0]	f_z;
input						[31:0]	f_e0;
input						[31:0]	f_e1;
begin
	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "command GCODE_G1 started");
	$fdisplay(main_data, "time = %8d. X = %5d; Y = %5d; Z = %5d; E0 = %5d; E1 = %5d.", 
						$time, x, y, z, e0, e1);
	$fclose(main_data);

	command_type	= `GCODE_G1;
	command_x  = x ;
	command_y  = y ;
	command_z  = z ;
	command_e0 = e0;
	command_e1 = e1;

	command_f_x  = f_x ;
	command_f_y  = f_y ;
	command_f_z  = f_z ;
	command_f_e0 = f_e0;
	command_f_e1 = f_e1;
	#20;
	flags_out = 'd1;
	wait(flags_in[7]);
	#200;

	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "command GCODE_G1 finished\n\n");
	$fclose(main_data);
	#100;
	flags_out = 'd0;
	#1000;

	zeroingInputs();
end
endtask : runG1

task runG90();
begin
	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "command GCODE_G90 started");
	$fclose(main_data);

	command_type = `GCODE_G90;
	#20;
	flags_out = 'd1;
	wait(flags_in[7]);
	#200;

	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "command GCODE_G90 finished\n\n");
	$fclose(main_data);
	#100;
	flags_out = 'd0;
	#1000;
end
endtask : runG90

task runG91();
begin
	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "command GCODE_G91 started");
	$fclose(main_data);

	command_type = `GCODE_G91;
	#20;
	flags_out = 'd1;
	wait(flags_in[7]);
	#200;

	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "command GCODE_G91 finished\n\n");
	$fclose(main_data);
	#100;
	flags_out = 'd0;
	#1000;
end
endtask : runG91

task runM17();
begin
	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "command GCODE_M17 started");
	$fclose(main_data);

	command_type = `GCODE_M17;
	#20;
	flags_out = 'd1;
	wait(flags_in[7]);
	#200;

	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "command GCODE_M17 finished\n\n");
	$fclose(main_data);
	#100;
	flags_out = 'd0;
	#1000;
end
endtask : runM17

task runM18();
begin
	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "command GCODE_M18 started");
	$fclose(main_data);

	command_type = `GCODE_M18;
	#20;
	flags_out = 'd1;
	wait(flags_in[7]);
	#200;

	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "command GCODE_M8 finished\n\n");
	$fclose(main_data);
	#100;
	flags_out = 'd0;
	#1000;
end
endtask : runM18

task runM82();
begin
	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "command GCODE_M82 started");
	$fclose(main_data);

	command_type = `GCODE_M82;
	#20;
	flags_out = 'd1;
	wait(flags_in[7]);
	#200;

	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "command GCODE_M82 finished\n\n");
	$fclose(main_data);
	#100;
	flags_out = 'd0;
	#1000;
end
endtask : runM82

task runM83();
begin
	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "command GCODE_M83 started");
	$fclose(main_data);

	command_type = `GCODE_M83;
	#20;
	flags_out = 'd1;
	wait(flags_in[7]);
	#200;

	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "command GCODE_M83 finished\n\n");
	$fclose(main_data);
	#100;
	flags_out = 'd0;
	#1000;
end
endtask : runM83

task runM104;
input		signed 	[31:0]	x;
input 					[11:0]	t;
input 					[11:0]	dt;
begin
	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "command GCODE_M104 started");
	$fdisplay(main_data, "Target temp: %3d. dt = %3d.", t, dt);
	$fclose(main_data);

	command_type = `GCODE_M104;
	command_t = t;
	command_dt = dt;
	#20;
	flags_out = 'd1;

	for (i = 0; i < 160; i = i + 1)
	begin
		#2000 temp[x] = temps[i];
	end

	wait(flags_in[7]);
	#200;

	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "command GCODE_M104 finished\n\n");
	$fclose(main_data);
	#100;
	flags_out = 'd0;
	#1000;
end
endtask : runM104

task runM140;
input		signed 	[31:0]	x;
input 					[11:0]	t;
input 					[11:0]	dt;
begin
	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "command GCODE_M140 started");
	$fdisplay(main_data, "Target temp: %3d. dt = %3d.", t, dt);
	$fclose(main_data);

	command_type = `GCODE_M140;
	command_t = t;
	command_dt = dt;
	#20;
	flags_out = 'd1;

	for (i = 0; i < 130; i = i + 1)
	begin
		#2000 temp[x] = temps[i];
	end

	wait(flags_in[7]);
	#200;

	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "command GCODE_M140 finished\n\n");
	$fclose(main_data);
	#100;
	flags_out = 'd0;
	#1000;
end
endtask : runM140

task runM109;
input		signed 	[31:0]	x;
input 					[11:0]	t;
input 					[11:0]	dt;
begin
	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "command GCODE_M109 started");
	$fdisplay(main_data, "Target temp: %3d. dt = %3d.", t, dt);
	$fclose(main_data);

	command_type = `GCODE_M109;
	command_t = t;
	command_dt = dt;
	#20;
	flags_out = 'd1;
	#20;
	wait(flags_in[7]);
	for (i = 0; i < 130; i = i + 1)
	begin
		#2000 temp[x] = temps[i];
	end

	
	#20000;

	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "command GCODE_M109 finished\n\n");
	$fclose(main_data);
	#100;
	flags_out = 'd0;
	#1000;
end
endtask : runM109

task runM190;
input		signed 	[31:0]	x;
input 					[11:0]	t;
input 					[11:0]	dt;
begin
	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "command GCODE_M190 started");
	$fdisplay(main_data, "Target temp: %3d. dt = %3d.", t, dt);
	$fclose(main_data);

	command_type = `GCODE_M190;
	command_t = t;
	command_dt = dt;
	#20;
	flags_out = 'd1;

	for (i = 0; i < 130; i = i + 1)
	begin
		#2000 temp[x] = temps[i];
	end

	wait(flags_in[7]);
	#20000;

	main_data	= $fopen("main_data.txt", "a");
	$fdisplay(main_data, "command GCODE_M190 finished\n\n");
	$fclose(main_data);
	#100;
	flags_out = 'd0;
	#1000;
end
endtask : runM190

always @(temp[0] or heaters[0])
begin
	#500;
	heater_0	= $fopen("heater_0.txt", "a");
	$fdisplay(heater_0, "time = %8d, Heat = %1b, Target temp = %3d, dt = %3d, Current temp = %10d,%5d", 
						$time, heaters[0], command_t, command_dt, temp[0], temp_0);
	$fclose(heater_0);
end

initial
begin
	motor_x	 = $fopen("motor_x.txt");
	motor_y	 = $fopen("motor_y.txt");
	motor_z	 = $fopen("motor_z.txt");
	motor_e0 = $fopen("motor_e0.txt");
	motor_e1 = $fopen("motor_e1.txt");
	main_data = $fopen("main_data.txt");
	heater_0 = $fopen("heater_0.txt");
	heater_1 = $fopen("heater_1.txt");
	heater_2 = $fopen("heater_2.txt");

	$fclose(motor_x	);
	$fclose(motor_y	);
	$fclose(motor_z	);
	$fclose(motor_e0);
	$fclose(motor_e1);
	$fclose(main_data);
	$fclose(heater_0);
	$fclose(heater_1);
	$fclose(heater_2);


	CLK_100MHz	= 1'b0;
	CLK_50MHz 	= 1'b0;
	CLK_10MHz 	= 1'b0;
	CLK_5MHz 		= 1'b0;
	CLK_1MHz 		= 1'b0;

	

	resetSystem();
	setSettings();
	zeroingInputs();

	runG91();	

	runG1(2400,//command_x,
				800,//command_y,
				400,//command_z,
				500,//command_e0,
				450,//command_e1,
				5000,//command_f_x, 
				5000,//command_f_y, 
				20333,//command_f_z, 
				2666,//command_f_e0,
				2666//command_f_e1,
				);

	runM104(0, 200, 1);
	

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
