`include "../configuration.vh"

module jerk_acc_speed ( 
	//Входные сигналы
	input		wire							clk,
	input		wire							reset,
	
	//Максимальная скорость принтера
	input		wire				[31:0]	max_speed_x, //микрошагов/сек
	input		wire				[31:0]	max_speed_y, //микрошагов/сек
	input		wire				[31:0]	max_speed_z, //микрошагов/сек
	input		wire				[31:0]	max_speed_e0, //микрошагов/сек
	input		wire				[31:0]	max_speed_e1, //микрошагов/сек
	
	//Ускорение принтера
	input		wire				[31:0]	acceleration_x, //микрошагов/сек^2
	input		wire				[31:0]	acceleration_y, //микрошагов/сек^2
	input		wire				[31:0]	acceleration_z, //микрошагов/сек^2
	input		wire				[31:0]	acceleration_e0, //микрошагов/сек^2
	input		wire				[31:0]	acceleration_e1, //микрошагов/сек^2
	
	//Рывок принтера
	input		wire				[31:0]	jerk_x, //микрошагов/сек
	input		wire				[31:0]	jerk_y, //микрошагов/сек
	input		wire				[31:0]	jerk_z, //микрошагов/сек
	input		wire				[31:0]	jerk_e0, //микрошагов/сек
	input		wire				[31:0]	jerk_e1, //микрошагов/сек
	
	//Данные Gcode команды движения
	input		wire				[31:0]	speed, //микрошагов/сек
	input		wire	signed	[31:0]	num_x, //микрошагов
	input		wire	signed	[31:0]	num_y, //микрошагов
	input		wire	signed	[31:0]	num_z, //микрошагов
	input		wire	signed	[31:0]	num_e0, //микрошагов
	input		wire	signed	[31:0]	num_e1, //микрошагов
	input		wire							start_driving,
	
	//Сигналы с концевиков
	input		wire				[0:5]		endstops,
	input		wire							bar_end,

	//Включить/выключить двигатели
	input		wire							enable_steppers,
	input		wire							disable_steppers,
					
	//Выходные сигналы
	//Двигатель a
	output	reg							stepper_x_enable,
	output	reg							stepper_x_step,
	output	reg							stepper_x_direction,	
	
	//Двигатель b
	output	reg							stepper_y_enable,
	output	reg							stepper_y_step,
	output	reg							stepper_y_direction,	
	
	//Двигатель оси z
	output	reg							stepper_z_enable,
	output	reg							stepper_z_step,
	output	reg							stepper_z_direction,	
	
	//Двигатель экструдера 0
	output	reg							stepper_e0_enable,
	output	reg							stepper_e0_step,
	output	reg							stepper_e0_direction,
	
	//Двигатель экструдера 1
	output	reg							stepper_e1_enable,
	output	reg							stepper_e1_step,
	output	reg							stepper_e1_direction,

	output	wire						finish
	);
								
wire	[31:0]	speed_x;
wire	[31:0]	speed_y;
wire	[31:0]	speed_z;
wire	[31:0]	speed_e0;
wire	[31:0]	speed_e1;

wire	[63:0]	timing_x 	[0:3];
wire	[63:0]	timing_y 	[0:3];
wire	[63:0]	timing_z 	[0:3];
wire	[63:0]	timing_e0 	[0:3];
wire	[63:0]	timing_e1 	[0:3];

wire	[31:0]	params_x		[0:4];
wire	[31:0]	params_y		[0:4];
wire	[31:0]	params_z		[0:4];
wire	[31:0]	params_e0	[0:4];
wire	[31:0]	params_e1	[0:4];

wire	[31:0]	new_params_x		[0:4];
wire	[31:0]	new_params_y		[0:4];
wire	[31:0]	new_params_z		[0:4];
wire	[31:0]	new_params_e0	[0:4];
wire	[31:0]	new_params_e1	[0:4];

wire	[63:0]	max_timing 	[0:3];
wire	[31:0]	max_params	[0:4];

wire				fin_stt_x;
wire				fin_stt_y;
wire				fin_stt_z;
wire				fin_stt_e0;
wire				fin_stt_e1;

wire				fin_ct_x;
wire				fin_ct_y;
wire				fin_ct_z;
wire				fin_ct_e0;
wire				fin_ct_e1;

wire				fin_fmt;

wire				fin_cnp_x;
wire				fin_cnp_y;
wire				fin_cnp_z;
wire				fin_cnp_e0;
wire				fin_cnp_e1;

wire				fin_jc_x;
wire				fin_jc_y;
wire				fin_jc_z;
wire				fin_jc_e0;
wire				fin_jc_e1;

assign speed_x = max_speed_x < speed ? max_speed_x : speed;
assign speed_y = max_speed_y < speed ? max_speed_y : speed;
assign speed_z = max_speed_z < speed ? max_speed_z : speed;
assign speed_e0 = max_speed_e0;	
assign speed_e1 = max_speed_e1;	

assign finish = fin_jc_x && fin_jc_y && fin_jc_z && fin_jc_e0 && fin_jc_e1;

always @(posedge enable_steppers)
begin
	stepper_x_enable <= 1'b0;
	stepper_y_enable <= 1'b0;
	stepper_z_enable <= 1'b0;
	stepper_e0_enable <= 1'b0;
	stepper_e1_enable <= 1'b0;
end

always @(posedge disable_steppers)
begin
	stepper_x_enable <= 1'b1;
	stepper_y_enable <= 1'b1;
	stepper_z_enable <= 1'b1;
	stepper_e0_enable <= 1'b1;
	stepper_e1_enable <= 1'b1;
end


//Вычисление задержек на основе заданных параметров движения для каждого двигателя
speed_to_timing stt_x(
	.clk(clk),
	.reset(reset),
	.start(start_driving),
	.speed(speed_x), 
	.acceleration(acceleration_x), 
	.jerk(jerk_x), 
	
	.params(params_x),
	.finish(fin_stt_x));
								
speed_to_timing stt_y(	
	.clk(clk),
	.reset(reset), 
	.start(start_driving),
	.speed(speed_y), 
	.acceleration(acceleration_y), 
	.jerk(jerk_y), 
	
	.params(params_y),
	.finish(fin_stt_y));
								
speed_to_timing stt_z(	
	.clk(clk),
	.reset(reset), 
	.start(start_driving),
	.speed(speed_z), 
	.acceleration(acceleration_z), 
	.jerk(jerk_z), 
	
	.params(params_z),
	.finish(fin_stt_z));
								
speed_to_timing stt_e0(	
	.clk(clk),
	.reset(reset), 
	.start(start_driving),
	.speed(speed_e0), 
	.acceleration(acceleration_e0), 
	.jerk(jerk_e0), 
	
	.params(params_e0),
	.finish(fin_stt_e0));
								
speed_to_timing stt_e1(	 
	.clk(clk),
	.reset(reset), 
	.start(start_driving),
	.speed(speed_e1), 
	.acceleration(acceleration_e1), 
	.jerk(jerk_e1), 
	
	.params(params_e1),
	.finish(fin_stt_e1));

	
//Вычисление первоначального времени выполнения движения для каждого двигателя
calc_time ct_x(
	.clk(clk),
	.reset(reset),
	.start(fin_stt_x),
	.params({num_x < 'd0 ? -num_x : num_x, params_x[1], params_x[2], params_x[3], params_x[4]}),
	
	.timing(timing_x),
	.finish(fin_ct_x));

calc_time ct_y(
	.clk(clk),
	.reset(reset),
	.start(fin_stt_y),
	.params({num_y < 'd0 ? -num_y : num_y, params_y[1], params_y[2], params_y[3], params_y[4]}),
	
	.timing(timing_y),
	.finish(fin_ct_y));
					
calc_time ct_z(
	.clk(clk),
	.reset(reset),
	.start(fin_stt_z),
	.params({num_z < 'd0 ? -num_z : num_z, params_z[1], params_z[2], params_z[3], params_z[4]}),
	
	.timing(timing_z),
	.finish(fin_ct_z));
					
calc_time ct_e0(
	.clk(clk),
	.reset(reset),
	.start(fin_stt_e0),
	.params({num_e0 < 'd0 ? -num_e0 : num_e0, params_e0[1], params_e0[2], params_e0[3], params_e0[4]}),
	
	.timing(timing_e0),
	.finish(fin_ct_e0));
					
calc_time ct_e1(
	.clk(clk),
	.reset(reset),
	.start(fin_stt_e1),
	.params({num_e1 < 'd0 ? -num_e1 : num_e1, params_e1[1], params_e1[2], params_e1[3], params_e1[4]}),
	
	.timing(timing_e1),
	.finish(fin_ct_e1));
	

//Нахождение максимального вычисленного времения	
find_max_timing fmt(	
	.clk(clk),
	.reset(reset),
	.start(fin_ct_x && fin_ct_y && fin_ct_z && fin_ct_e0 && fin_ct_e1),
	.params_x({num_x < 'd0 ? -num_x : num_x, params_x[1], params_x[2], params_x[3], params_x[4]}),
	.params_y({num_y < 'd0 ? -num_y : num_y, params_y[1], params_y[2], params_y[3], params_y[4]}),
	.params_z({num_z < 'd0 ? -num_z : num_z, params_z[1], params_z[2], params_z[3], params_z[4]}),
	.params_e0({num_e0 < 'd0 ? -num_e0 : num_e0, params_e0[1], params_e0[2], params_e0[3], params_e0[4]}),
	.params_e1({num_e1 < 'd0 ? -num_e1 : num_e1, params_e1[1], params_e1[2], params_e1[3], params_e1[4]}),	
	.timing_x(timing_x),
	.timing_y(timing_y),
	.timing_z(timing_z),
	.timing_e0(timing_e0),
	.timing_e1(timing_e1),


	.max_timing(max_timing),
	.max_params(max_params),
	.finish(fin_fmt));

//Вычисление новых параметров движения на основе 
calc_new_parameters cnp_x(
	.clk(clk),
	.reset(reset),
	.start(fin_fmt),
	.max_params(max_params),
	.params(params_x),
	.max_timing(max_timing),
	
	.new_par(new_params_x),
	.finish(cnp_x)
	);

calc_new_parameters cnp_y(
	.clk(clk),
	.reset(reset),
	.start(fin_fmt),
	.max_params(max_params),
	.params(params_y),
	.max_timing(max_timing),
	
	.new_par(new_params_y),
	.finish(cnp_y)
	);

calc_new_parameters cnp_z(
	.clk(clk),
	.reset(reset),
	.start(fin_fmt),
	.max_params(max_params),
	.params(params_z),
	.max_timing(max_timing),
	
	.new_par(new_params_z),
	.finish(cnp_z)
	);

calc_new_parameters cnp_e0(
	.clk(clk),
	.reset(reset),
	.start(fin_fmt),
	.max_params(max_params),
	.params(params_e0),
	.max_timing(max_timing),
	
	.new_par(new_params_e0),
	.finish(cnp_e0)
	);

calc_new_parameters cnp_e1(
	.clk(clk),
	.reset(reset),
	.start(fin_fmt),
	.max_params(max_params),
	.params(params_e1),
	.max_timing(max_timing),
	
	.new_par(new_params_e1),
	.finish(cnp_e1)
	);

//генерация импульсов управления двигатетями
jas_constrol jc_x(
	.clk(clk),
	.reset(reset),
	.start(cnp_x && cnp_y && cnp_z && cnp_e0 && cnp_e1),
	.params(new_params_x),	

	.finish(fin_jc_x),
	.step(stepper_x_step));

jas_constrol jc_y(
	.clk(clk),
	.reset(reset),
	.start(cnp_x && cnp_y && cnp_z && cnp_e0 && cnp_e1),
	.params(new_params_y),	

	.finish(fin_jc_y),
	.step(stepper_y_step));

jas_constrol jc_z(
	.clk(clk),
	.reset(reset),
	.start(cnp_x && cnp_y && cnp_z && cnp_e0 && cnp_e1),
	.params(new_params_z),	

	.finish(fin_jc_z),
	.step(stepper_z_step));

jas_constrol jc_e0(
	.clk(clk),
	.reset(reset),
	.start(cnp_x && cnp_y && cnp_z && cnp_e0 && cnp_e1),
	.params(new_params_e0),	

	.finish(fin_jc_e0),
	.step(stepper_e0_step));

jas_constrol jc_e1(
	.clk(clk),
	.reset(reset),
	.start(cnp_x && cnp_y && cnp_z && cnp_e0 && cnp_e1),
	.params(new_params_e1),	

	.finish(fin_jc_e1),
	.step(stepper_e1_step));

endmodule
