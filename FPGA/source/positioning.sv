module positioning (
	input reset,


	//Управляющие сигналы двигателей
	//Двигатель a
	input		wire			stepper_x_enable,
	input		wire			stepper_x_step,
	input		wire			stepper_x_direction,	
	
	//Двигатель b
	input		wire			stepper_y_enable,
	input		wire			stepper_y_step,
	input		wire			stepper_y_direction,	
	
	//Двигатель оси z
	input		wire			stepper_z_enable,
	input		wire			stepper_z_step,
	input		wire			stepper_z_direction,	
	
	//Двигатель экструдера 0 (подачи пластика)
	input		wire			stepper_e0_enable,
	input		wire			stepper_e0_step,
	input		wire			stepper_e0_direction,
	
	//Двигатель экструдера 1 (подачи пластика)
	input		wire			stepper_e1_enable,
	input		wire			stepper_e1_step,
	input		wire			stepper_e1_direction,


	//Сигналы для установки новых координат
	input		wire			stepper_x_set_new_coordinates,
	input		wire			stepper_y_set_new_coordinates,
	input		wire			stepper_z_set_new_coordinates,
	input		wire			stepper_e0_set_new_coordinates,
	input		wire			stepper_e1_set_new_coordinates,
	//Значения новых координат
	input		wire	signed	[31:0]	new_pos_x,
	input		wire	signed	[31:0]	new_pos_y,
	input		wire	signed	[31:0]	new_pos_z,
	input		wire	signed	[31:0]	new_pos_e0,
	input		wire	signed	[31:0]	new_pos_e1,
		
	//Текущая позиция
	output	reg	signed	[31:0]	pos_x = 0,
	output	reg	signed	[31:0]	pos_y = 0,
	output	reg	signed	[31:0]	pos_z = 0,
	output	reg	signed	[31:0]	pos_e0 = 0,
	output	reg	signed	[31:0]	pos_e1 = 0
);


//Изменение текущих координат по управляющему сигналу двигателей
always @(posedge reset or posedge stepper_x_set_new_coordinates or posedge stepper_x_step)
begin 
	if (reset)
		pos_x = 0;
	else
	begin
		if (stepper_x_set_new_coordinates)
			pos_x = new_pos_x;
		else
			pos_x = pos_x + ((~stepper_x_enable) ? ((~stepper_x_direction) ? $signed(32'd1): $signed(-32'd1)) : $signed(32'd0));
	end
end

always @(posedge reset or posedge stepper_y_set_new_coordinates or posedge stepper_y_step)
begin
	if (reset)
		pos_y = 0;
	else
		if (stepper_y_set_new_coordinates)
			pos_y = new_pos_y;
		else
			pos_y = pos_y + ((stepper_y_enable == 1'b0) ? (((stepper_y_direction) == 1'b0) ? $signed(32'd1): $signed(-32'd1)) : $signed(32'd0));
end

always @(posedge reset or posedge stepper_z_set_new_coordinates or posedge stepper_z_step)
begin
	if (reset)
		pos_z = 0;
	else
		if (stepper_z_set_new_coordinates)
			pos_z = new_pos_z;
		else
			pos_z = pos_z + ((stepper_z_enable == 1'b0) ? (((stepper_z_direction) == 1'b0) ? $signed(32'd1): $signed(-32'd1)) : $signed(32'd0));
end

always @(posedge reset or posedge stepper_e0_set_new_coordinates or posedge stepper_e0_step)
begin
	if (reset)
		pos_e0 = 0;
	else
		if (stepper_e0_set_new_coordinates)
			pos_e0 = new_pos_e0;
		else
			pos_e0 = pos_e0 + ((stepper_e0_enable == 1'b0) ? (((stepper_e0_direction) == 1'b0) ? $signed(32'd1): $signed(-32'd1)) : $signed(32'd0));
end

always @(posedge reset or posedge stepper_e1_set_new_coordinates or posedge stepper_e1_step)
begin
	if (reset)
		pos_e1 = 0;
	else
		if (stepper_e1_set_new_coordinates)
			pos_e1 = new_pos_e1;
		else
			pos_e1 = pos_e1 + ((stepper_e1_enable == 1'b0) ? (((stepper_e1_direction) == 1'b0) ? $signed(32'd1): $signed(-32'd1)) : $signed(32'd0));
end

endmodule
