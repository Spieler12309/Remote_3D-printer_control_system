`include "../configuration.vh"

module jerk_acc_speed ( 
	//Входные сигналы
	input		wire							clk,
	input		wire							reset,
	
	//Максимальная скорость принтера
	input		wire				[31:0]	max_speed_a, //микрошагов/сек
	input		wire				[31:0]	max_speed_b, //микрошагов/сек
	input		wire				[31:0]	max_speed_z, //микрошагов/сек
	input		wire				[31:0]	max_speed_e, //микрошагов/сек
	
	//Ускорение принтера
	input		wire				[31:0]	acceleration_a, //микрошагов/сек^2
	input		wire				[31:0]	acceleration_b, //микрошагов/сек^2
	input		wire				[31:0]	acceleration_z, //микрошагов/сек^2
	input		wire				[31:0]	acceleration_e, //микрошагов/сек^2
	
	//Рывок принтера
	input		wire				[31:0]	jerk_a, //микрошагов/сек
	input		wire				[31:0]	jerk_b, //микрошагов/сек
	input		wire				[31:0]	jerk_z, //микрошагов/сек
	input		wire				[31:0]	jerk_e, //микрошагов/сек
	
	//Данные Gcode команды движения
	input		wire				[31:0]	speed, //микрошагов/сек
	input		wire	signed	[31:0]	num_a, //микрошагов
	input		wire	signed	[31:0]	num_b, //микрошагов
	input		wire	signed	[31:0]	num_z, //микрошагов
	input		wire	signed	[31:0]	num_e, //микрошагов
	input		wire							start_driving,
	
	//Сигналы с концевиков
	input		wire							xmin,
	input		wire							xmax,
	input		wire							ymin,
	input		wire							ymax,
	input		wire							zmin,
	input		wire							zmax,

	//Включить/выключить двигатели
	input		wire							enable_steppers,
	input		wire							disable_steppers,
					
	//Выходные сигналы
	//Двигатель a
	output	reg							stepper_a_enable,
	output	reg							stepper_a_step,
	output	reg							stepper_a_direction,	
	
	//Двигатель b
	output	reg							stepper_b_enable,
	output	reg							stepper_b_step,
	output	reg							stepper_b_direction,	
	
	//Двигатель оси z
	output	reg							stepper_z_enable,
	output	reg							stepper_z_step,
	output	reg							stepper_z_direction,	
	
	//Двигатель экструдера (подачи пластика)
	output	reg							stepper_e_enable,
	output	reg							stepper_e_step,
	output	reg							stepper_e_direction
	);
								
wire	[31:0]	speed_a;
wire	[31:0]	speed_b;
wire	[31:0]	speed_z;
wire	[31:0]	speed_e;

wire	[31:0]	params_a	[0:4];
wire	[31:0]	params_b	[0:4];
wire	[31:0]	params_z	[0:4];
wire	[31:0]	params_e	[0:4];

wire				fin_ct_a;
wire				fin_ct_b;
wire				fin_ct_z;
wire				fin_ct_e;



assign speed_a = max_speed_a < speed ? max_speed_a : speed;
assign speed_b = max_speed_b < speed ? max_speed_b : speed;
assign speed_z = max_speed_z;
assign speed_e = max_speed_e;

always @(posedge enable_steppers)
begin
	stepper_a_enable <= 1'b0;
	stepper_b_enable <= 1'b0;
	stepper_z_enable <= 1'b0;
	stepper_e_enable <= 1'b0;
end

always @(posedge disable_steppers)
begin
	stepper_a_enable <= 1'b1;
	stepper_b_enable <= 1'b1;
	stepper_z_enable <= 1'b1;
	stepper_e_enable <= 1'b1;
end

speed_to_timing stt_a(	.clk(clk), 
								.reset(reset), 
								.speed(speed_a), 
								.acceleration(acceleration_a), 
								.jerk(jerk_a), 
								.params(params_a));
								
speed_to_timing stt_b(	.clk(clk), 
								.reset(reset), 
								.speed(speed_b), 
								.acceleration(acceleration_b), 
								.jerk(jerk_b), 
								.params(params_b));
								
speed_to_timing stt_z(	.clk(clk), 
								.reset(reset), 
								.speed(speed_z), 
								.acceleration(acceleration_z), 
								.jerk(jerk_z), 
								.params(params_z));
								
speed_to_timing stt_e(	.clk(clk), 
								.reset(reset), 
								.speed(speed_e), 
								.acceleration(acceleration_e), 
								.jerk(jerk_e), 
								.params(params_e));

find_max_timing fmt_a(	.clk(clk),
								.reset(reset),
								.start(),
								.params_a(),
								.params_b(),
								.params_z(),
								.params_e(),
	
								.timing_a(),
								.timing_b(),
								.timing_z(),
								.timing_e(),


								.max_timing(),
								.finish()
	);
						
calc_time ct_a(.clk(clk),
					.reset(reset),
					.start(start_driving),
					.params({num_a < 'd0 ? -num_a : num_a, params_a[1], params_a[2], params_a[3], params_a[4]}),
					.timing({1, 2, 3, 4}),
					.finish(fin_ct_a)
					);

endmodule
