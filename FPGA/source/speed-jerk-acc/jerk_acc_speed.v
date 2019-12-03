`include "../configuration.vh"

module jerk_acc_speed ( //Входные сигналы
								input		wire				clk,
								input		wire				reset,
								
								//Максимальная скорость принтера
								input		wire	[31:0]	max_speed_a, //микрошагов/сек
								input		wire	[31:0]	max_speed_b, //микрошагов/сек
								input		wire	[31:0]	max_speed_z, //микрошагов/сек
								input		wire	[31:0]	max_speed_e, //микрошагов/сек
								
								//Ускорение принтера
								input		wire	[31:0]	acceleration_a, //микрошагов/сек^2
								input		wire	[31:0]	acceleration_b, //микрошагов/сек^2
								input		wire	[31:0]	acceleration_z, //микрошагов/сек^2
								input		wire	[31:0]	acceleration_e, //микрошагов/сек^2
								
								//Рывок принтера
								input		wire	[31:0]	jerk_a, //микрошагов/сек
								input		wire	[31:0]	jerk_b, //микрошагов/сек
								input		wire	[31:0]	jerk_z, //микрошагов/сек
								input		wire	[31:0]	jerk_e, //микрошагов/сек
								
								//Данные Gcode команды движения
								input		wire	[31:0]	speed, //микрошагов/сек
								input		wire	[31:0]	num_a, //микрошагов
								input		wire	[31:0]	num_b, //микрошагов
								input		wire	[31:0]	num_z, //микрошагов
								input		wire	[31:0]	num_e, //микрошагов
								
								//Сигналы с концевиков
								input		wire				xmin,
								input		wire				xmax,
								input		wire				ymin,
								input		wire				ymax,
								input		wire				zmin,
								input		wire				zmax,
								
								
								
								//Выходные сигналы
								//Двигатель a
								output	reg				stepper_a_enable,
								output	reg				stepper_a_step,
								output	reg				stepper_a_direction,	
								
								//Двигатель b
								output	reg				stepper_b_enable,
								output	reg				stepper_b_step,
								output	reg				stepper_b_direction,	
								
								//Двигатель оси z
								output	reg				stepper_z_enable,
								output	reg				stepper_z_step,
								output	reg				stepper_z_direction,	
								
								//Двигатель экструдера (подачи пластика)
								output	reg				stepper_e_enable,
								output	reg				stepper_e_step,
								output	reg				stepper_e_direction
								);
								
	wire	[31:0]	speed_a;
	wire	[31:0]	speed_b;
	wire	[31:0]	speed_z;
	wire	[31:0]	speed_e;
	
	
	

endmodule
