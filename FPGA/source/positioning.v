module positioning (
	input reset,


	//Управляющие сигналы двигателей
	//Двигатель a
	input						stepper_a_enable,
	input						stepper_a_step,
	input						stepper_a_direction,	
	
	//Двигатель b
	input						stepper_b_enable,
	input						stepper_b_step,
	input						stepper_b_direction,	
	
	//Двигатель оси z
	input						stepper_z_enable,
	input						stepper_z_step,
	input						stepper_z_direction,	
	
	//Двигатель экструдера (подачи пластика)
	input						stepper_e1_enable,
	input						stepper_e1_step,
	input						stepper_e1_direction,


	//Информация об инверсия двигателей
	input						stepper_a_inversion,
	input						stepper_b_inversion,
	input						stepper_z_inversion,
	input						stepper_e1_inversion,


	//Текущая позиция
	output	reg		[31:0]	pos_x = 0,
	output	reg		[31:0]	pos_y = 0,
	output	reg		[31:0]	pos_z = 0,
	output	reg		[31:0]	pos_e1 = 0
);

	always @(posedge stepper_a_step)
	begin
		pos_a = pos_a + ((stepper_a_enable == 1'b0) ? (((stepper_a_direction ^ stepper_a_inversion) == 1'b0) ? 'd1: {32{1'b1}}) : 0);
	end

	always @(posedge stepper_b_step)
	begin
		pos_b = pos_b + ((stepper_b_enable == 1'b0) ? (((stepper_b_direction ^ stepper_b_inversion) == 1'b0) ? 'd1: {32{1'b1}}) : 0);
	end

	always @(posedge stepper_z_step)
	begin
		pos_z = pos_z + ((stepper_z_enable == 1'b0) ? (((stepper_z_direction ^ stepper_z_inversion) == 1'b0) ? 'd1: {32{1'b1}}) : 0);
	end

	always @(posedge stepper_e1_step)
	begin
		pos_e1 = pos_e1 + ((stepper_e1_enable == 1'b0) ? (((stepper_e1_direction ^ stepper_e1_inversion) == 1'b0) ? 'd1: {32{1'b1}}) : 0);
	end

endmodule