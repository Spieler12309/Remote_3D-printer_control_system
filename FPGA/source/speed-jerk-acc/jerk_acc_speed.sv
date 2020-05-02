`include "../configuration.vh"
//`define DEBUG //Расскомментировать для тестирования

module jerk_acc_speed ( 
	//Входные сигналы
	input		wire									clk,
	input		wire									reset,
	
	//Максимальная скорость принтера
	input		wire					[31:0]	max_speed_x, //микрошагов/сек
	input		wire					[31:0]	max_speed_y, //микрошагов/сек
	input		wire					[31:0]	max_speed_z, //микрошагов/сек
	input		wire					[31:0]	max_speed_e0, //микрошагов/сек
	input		wire					[31:0]	max_speed_e1, //микрошагов/сек
	
	//Ускорение принтера
	input		wire					[31:0]	acceleration_x, //микрошагов/сек^2
	input		wire					[31:0]	acceleration_y, //микрошагов/сек^2
	input		wire					[31:0]	acceleration_z, //микрошагов/сек^2
	input		wire					[31:0]	acceleration_e0, //микрошагов/сек^2
	input		wire					[31:0]	acceleration_e1, //микрошагов/сек^2
	
	//Рывок принтера
	input		wire					[31:0]	jerk_x, //микрошагов/сек
	input		wire					[31:0]	jerk_y, //микрошагов/сек
	input		wire					[31:0]	jerk_z, //микрошагов/сек
	input		wire					[31:0]	jerk_e0, //микрошагов/сек
	input		wire					[31:0]	jerk_e1, //микрошагов/сек
	
	//Информация об инверсия двигателей
	input		wire									stepper_x_inversion,
	input		wire									stepper_y_inversion,
	input		wire									stepper_z_inversion,
	input		wire									stepper_e0_inversion,
	input		wire									stepper_e1_inversion,

	//Данные Gcode команды движения
	input		wire					[31:0]	speed, //микрошагов/сек
	input		wire	signed	[31:0]	num_x_m, //микрошагов
	input		wire	signed	[31:0]	num_y_m, //микрошагов
	input		wire	signed	[31:0]	num_z_m, //микрошагов
	input		wire	signed	[31:0]	num_e0_m, //микрошагов
	input		wire	signed	[31:0]	num_e1_m, //микрошагов
	input		wire									start_driving_main,
	
	//Сигналы с концевиков
	input		wire					[0:5]		endstops_nf,
	input		wire									bar_end_nf,

	//Включить/выключить двигатели
	input		wire									enable_steppers,
	input		wire									disable_steppers,
					
	//Выходные сигналы
	//Двигатель a
	output	reg										stepper_x_enable,
	output	wire									stepper_x_step,
	output	wire									stepper_x_direction,	
	
	//Двигатель b
	output	reg										stepper_y_enable,
	output	wire									stepper_y_step,
	output	wire									stepper_y_direction,	
	
	//Двигатель оси z
	output	reg										stepper_z_enable,
	output	wire									stepper_z_step,
	output	wire									stepper_z_direction,	
	
	//Двигатель экструдера 0
	output	reg										stepper_e0_enable,
	output	wire									stepper_e0_step,
	output	wire									stepper_e0_direction,
	
	//Двигатель экструдера 1
	output	reg										stepper_e1_enable,
	output	wire									stepper_e1_step,
	output	wire									stepper_e1_direction,

	output	wire									finish,
	output	wire									error
	);
								
wire	[31:0]	speed_x;
wire	[31:0]	speed_y;
wire	[31:0]	speed_z;
wire	[31:0]	speed_e0;
wire	[31:0]	speed_e1;

wire	[63:0]	timing_x 			[0:3];
wire	[63:0]	timing_y 			[0:3];
wire	[63:0]	timing_z 			[0:3];
wire	[63:0]	timing_e0 		[0:3];
wire	[63:0]	timing_e1 		[0:3];

wire	[31:0]	params_x			[0:4];
wire	[31:0]	params_y			[0:4];
wire	[31:0]	params_z			[0:4];
wire	[31:0]	params_e0			[0:4];
wire	[31:0]	params_e1			[0:4];

wire	[31:0]	new_params_x	[0:4];
wire	[31:0]	new_params_y	[0:4];
wire	[31:0]	new_params_z	[0:4];
wire	[31:0]	new_params_e0	[0:4];
wire	[31:0]	new_params_e1	[0:4];

wire	[63:0]	max_timing 		[0:3];
wire	[31:0]	max_params		[0:4];

wire					fin_stt;
wire					fin_ct;
wire					fin_fmt;
wire					fin_canp;
wire					fin_jc_x;
wire					fin_jc_y;
wire					fin_jc_z;
wire					fin_jc_e0;
wire					fin_jc_e1;

assign speed_x  = max_speed_x < speed ? max_speed_x : speed;
assign speed_y  = max_speed_y < speed ? max_speed_y : speed;
assign speed_z  = max_speed_z < speed ? max_speed_z : speed;
assign speed_e0 = max_speed_e0;
assign speed_e1 = max_speed_e1;

wire	[31:0]	num_x;
wire	[31:0]	num_y;
wire	[31:0]	num_z;
wire	[31:0]	num_e0;
wire	[31:0]	num_e1;

wire	[31:0]	num_x_now;
wire	[31:0]	num_y_now;
wire	[31:0]	num_z_now;
wire	[31:0]	num_e0_now;
wire	[31:0]	num_e1_now;

wire	[0:5]		endstops;
wire					bar_end;

reg [1:0]	x	= 0; //0 - =; 1 - -; 2 - +;
reg [1:0]	y	= 0; //0 - =; 1 - -; 2 - +;
endstop_filter ef0(.clk(clk),
					.in(endstops_nf[0]),
					.out(endstops[0]));
endstop_filter ef1(.clk(clk),
					.in(endstops_nf[1]),
					.out(endstops[1]));
endstop_filter ef2(.clk(clk),
					.in(endstops_nf[2]),
					.out(endstops[2]));
endstop_filter ef3(.clk(clk),
					.in(endstops_nf[3]),
					.out(endstops[3]));
endstop_filter ef4(.clk(clk),
					.in(endstops_nf[4]),
					.out(endstops[4]));
endstop_filter ef5(.clk(clk),
					.in(endstops_nf[5]),
					.out(endstops[5]));

endstop_filter ef6(.clk(clk),
					.in(bar_end_nf),
					.out(bar_end));

assign num_x = (stepper_x_inversion == 0) ? num_x_m : -num_x_m;
assign num_y = (stepper_y_inversion == 0) ? num_y_m : -num_y_m;
assign num_z = (stepper_z_inversion == 0) ? num_z_m : -num_z_m;
assign num_e0 = (stepper_e0_inversion == 0) ? num_e0_m : -num_e0_m;
assign num_e1 = (stepper_e1_inversion == 0) ? num_e1_m : -num_e1_m;

assign stepper_x_direction = num_x[31];
assign stepper_y_direction = num_y[31];
assign stepper_z_direction = num_z[31];
assign stepper_e0_direction = num_e0[31];
assign stepper_e1_direction = num_e1[31];

assign finish = fin_jc_x && fin_jc_y && fin_jc_z && fin_jc_e0 && fin_jc_e1 || error && start_driving_main;

assign error = ((((x == 1) && endstops[0]) || 
			((x == 2) && endstops[1])) && (num_y - num_y_now == num_x - num_x_now) && (stepper_x_direction != stepper_y_direction)) &&
		((((y == 1) && endstops[2]) || 
			((y == 2) && endstops[3])) && (num_y - num_y_now == num_x - num_x_now) && (stepper_x_direction == stepper_y_direction)) &&
		((~stepper_z_direction && endstops[4] && num_z != num_z_now) || 
			(stepper_z_direction && endstops[5]));
wire	start_driving;
assign start_driving = (start_driving_main == 1'b1) && (error == 1'b0);

initial
begin
	stepper_x_enable <= 1'b0;
	stepper_y_enable <= 1'b0;
	stepper_z_enable <= 1'b0;
	stepper_e0_enable <= 1'b0;
	stepper_e1_enable <= 1'b0;
end

always @(posedge clk)
begin
	//Вычисление направления движения по осям x и y
	if ((stepper_x_direction == 0) && (stepper_y_direction == 0))
	begin
		x = 2;
		if (num_x > num_y)
			y = 2;
		else 
		begin
			if (num_x == num_y)
				y = 0;
			else
				y = 1;
		end
	end
	
	if ((stepper_x_direction == 0) && (stepper_y_direction == 1))
	begin
		y = 2;
		if (num_x > num_y)
			x = 2;
		else 
		begin
			if (num_x == num_y)
				x = 0;
			else
				x = 1;
		end
	end
	
	if ((stepper_x_direction == 1) && (stepper_y_direction == 0))
	begin
		y = 1;
		if (num_y > num_x)
			x = 2;
		else 
		begin
			if (num_x == num_y)
				x = 0;
			else
				x = 1;
		end
	end
	
	if ((stepper_x_direction == 1) && (stepper_y_direction == 1))
	begin
		x = 1;
		if (num_y > num_x)
			y = 2;
		else 
		begin
			if (num_x == num_y)
				y = 0;
			else
				y = 1;
		end
	end
end

always @(posedge enable_steppers or posedge disable_steppers)
begin
	if (enable_steppers)
	begin
		stepper_x_enable <= 1'b0;
		stepper_y_enable <= 1'b0;
		stepper_z_enable <= 1'b0;
		stepper_e0_enable <= 1'b0;
		stepper_e1_enable <= 1'b0;
	end
	else
	begin
		stepper_x_enable <= 1'b1;
		stepper_y_enable <= 1'b1;
		stepper_z_enable <= 1'b1;
		stepper_e0_enable <= 1'b1;
		stepper_e1_enable <= 1'b1;
	end
end

//Вычисление задержек на основе заданных параметров движения для каждого двигателя
speeds_to_timings stt(
	.clk(clk),
	.reset(reset),
	.start(start_driving),
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
	.finish(fin_stt)
);
	
//Вычисление первоначального времени выполнения движения для каждого двигателя
calc_times ct(
	.clk(clk),
	.reset(reset),
	.start(fin_stt),
	.params_x(params_x),
	.params_y(params_y),
	.params_z(params_z),
	.params_e0(params_e0),
	.params_e1(params_e1),
	
	.timing_x(timing_x),
	.timing_y(timing_y),
	.timing_z(timing_z),
	.timing_e0(timing_e0),
	.timing_e1(timing_e1),
	.finish(fin_ct));

//Нахождение максимального вычисленного времения	
find_max_timing fmt(	
	.clk(clk),
	.reset(reset),
	.start(fin_ct),
	.params_x(params_x),
	.params_y(params_y),
	.params_z(params_z),
	.params_e0(params_e0),
	.params_e1(params_e1),
	.timing_x(timing_x),
	.timing_y(timing_y),
	.timing_z(timing_z),
	.timing_e0(timing_e0),
	.timing_e1(timing_e1),

	.max_timing(max_timing),
	.max_params(max_params),
	.finish(fin_fmt));

//Вычисление новых параметров движения на основе 
calc_all_new_parameters canp(
	.clk(clk),
	.reset(reset),
	.start(fin_fmt),
	.max_params(max_params),
	.params_x(params_x),
	.params_y(params_y),
	.params_z(params_z),
	.params_e0(params_e0),
	.params_e1(params_e1),
	.max_timing(max_timing),
	
	.new_par_x(new_params_x),
	.new_par_y(new_params_y),
	.new_par_z(new_params_z),
	.new_par_e0(new_params_e0),
	.new_par_e1(new_params_e1),
	.finish(fin_canp)
	);


//генерация импульсов управления двигатетями
jas_constrol jc_x(
	.clk(clk),
	.reset(reset),
	.start(fin_canp),
	.params(new_params_x),	

	.finish(fin_jc_x),
	.step_num(num_x_now),
	.step(stepper_x_step));

jas_constrol jc_y(
	.clk(clk),
	.reset(reset),
	.start(fin_canp),
	.params(new_params_y),	

	.finish(fin_jc_y),
	.step_num(num_y_now),
	.step(stepper_y_step));

jas_constrol jc_z(
	.clk(clk),
	.reset(reset),
	.start(fin_canp),
	.params(new_params_z),	

	.finish(fin_jc_z),
	.step_num(num_z_now),
	.step(stepper_z_step));

jas_constrol jc_e0(
	.clk(clk),
	.reset(reset),
	.start(fin_canp),
	.params(new_params_e0),	

	.finish(fin_jc_e0),
	.step_num(num_e0_now),
	.step(stepper_e0_step));

jas_constrol jc_e1(
	.clk(clk),
	.reset(reset),
	.start(fin_canp),
	.params(new_params_e1),	

	.finish(fin_jc_e1),
	.step_num(num_e1_now),
	.step(stepper_e1_step));

endmodule
