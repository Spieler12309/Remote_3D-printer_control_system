`include "configuration.vh"

module control_unit(
	input		wire							clk,
	input		wire							reset,
	input		wire							start,
	input		wire				[31:0]	command_type,
	input		wire	signed	[31:0]	command_x,
	input		wire	signed	[31:0]	command_y,
	input		wire	signed	[31:0]	command_z,
	input		wire	signed	[31:0]	command_e0,
	input		wire	signed	[31:0]	command_e1,
	input		wire	signed	[31:0]	pos_x,
	input		wire	signed	[31:0]	pos_y,
	input		wire	signed	[31:0]	pos_z,
	input		wire	signed	[31:0]	pos_e0,
	input		wire	signed	[31:0]	pos_e1,
	input		wire									finish_driving,
	input		wire					[0:2]		heaters_finish,
	
	
	output	reg		signed	[31:0]	new_command_x,
	output	reg		signed	[31:0]	new_command_y,
	output	reg		signed	[31:0]	new_command_z,
	output	reg		signed	[31:0]	new_command_e0,
	output	reg		signed	[31:0]	new_command_e1,
	output	reg								is_realative = 1'b0, //0 - абсолютная, 1 - относительная
	output	reg								is_realative_extruder = 1'b0, //0 - абсолютная, 1 - относительная
	output	reg										start_move,
	output	reg						[0:2]		start_heat,
	output	reg						[0:2]		start_heat_long,
	//output	reg										change_position,
	output	reg										enable_steppers,
	output	reg										disable_steppers,
	output	reg										start_cooling,
	output	reg										finish,
	output	reg										error);

reg [31:0]		w = 'd0;
always @(posedge clk or posedge reset)
begin
	if (reset)
	begin
		start_move <= 1'b0;
		start_heat <= 3'b000;
		start_heat_long <= 3'b000;
		//change_position <= 1'b0;
		enable_steppers <= 1'b0;
		disable_steppers <= 1'b0;
		error <= 1'b0;
		finish <= 1'b0;
	end
	else
	begin		
		if (w <= 0)
		begin
			if (start && ~finish)
			begin
				error = 1'b0;
				case (command_type)
					`GCODE_G0, `GCODE_G1:
					begin						
						start_heat <= 3'b000;
						start_heat_long <= 3'b000;
						//change_position <= 1'b0;
						enable_steppers <= 1'b0;
						disable_steppers <= 1'b0;
						start_move <= 1'b1;
						new_command_x <= is_realative ? command_x : command_x - pos_x;
						new_command_y <= is_realative ? command_y : command_y - pos_y;
						new_command_z <= is_realative ? command_z : command_z - pos_z;
						new_command_e0 <= is_realative_extruder ? command_e0 : command_e0 - pos_e0;
						new_command_e1 <= is_realative_extruder ? command_e1 : command_e1 - pos_e1;
						finish <= finish_driving;
					end
					/*`GCODE_G28:
					begin
						start_home = 1'b1;
					end*/
					`GCODE_G90:
					begin
						start_move <= 1'b0;
						start_heat <= 3'b000;
						start_heat_long <= 3'b000;
						//change_position <= 1'b0;
						enable_steppers <= 1'b0;
						disable_steppers <= 1'b0;
						is_realative <= 1'b0;
						finish <= 1'b1;
					end
					`GCODE_G91:
					begin
						start_move <= 1'b0;
						start_heat <= 3'b000;
						start_heat_long <= 3'b000;
						//change_position <= 1'b0;
						enable_steppers <= 1'b0;
						disable_steppers <= 1'b0;
						is_realative <= 1'b1;
						finish <= 1'b1;
					end
					/*`GCODE_G92:
					begin
						start_move <= 1'b0;
						start_heat <= 3'b000;
						start_heat_long <= 3'b000;
						enable_steppers <= 1'b0;
						disable_steppers <= 1'b0;
						change_position <= 1'b1;
						finish <= 1'b1;
					end*/
					`GCODE_M17: 
					begin
						start_move <= 1'b0;
						start_heat <= 3'b000;
						start_heat_long <= 3'b000;
						//change_position <= 1'b0;
						disable_steppers <= 1'b0;
						enable_steppers <= 1'b1;
						w <= 'd100;
						finish <= 1'b1;
					end
					`GCODE_M18: 
					begin
						start_move <= 1'b0;
						start_heat <= 3'b000;
						start_heat_long <= 3'b000;
						//change_position <= 1'b0;
						enable_steppers <= 1'b0;
						disable_steppers <= 1'b1;
						w <= 'd100;
						finish <= 1'b1;
					end
					`GCODE_M82:
					begin
						start_move <= 1'b0;
						start_heat <= 3'b000;
						start_heat_long <= 3'b000;
						//change_position <= 1'b0;
						enable_steppers <= 1'b0;
						disable_steppers <= 1'b0;
						is_realative_extruder <= 1'b0;
						finish <= 1'b1;
					end
					`GCODE_M83:
					begin
						start_move <= 1'b0;
						start_heat <= 3'b000;
						start_heat_long <= 3'b000;
						//change_position <= 1'b0;
						enable_steppers <= 1'b0;
						disable_steppers <= 1'b0;
						is_realative_extruder <= 1'b1;
						finish <= 1'b1;
					end
					`GCODE_M104, `GCODE_M140:
					begin
						start_move <= 1'b0;
						start_heat_long <= 3'b000;
						//change_position <= 1'b0;
						enable_steppers <= 1'b0;
						disable_steppers <= 1'b0;
						if (command_x >=0 && command_x <= 2)
						begin
							start_heat[command_x] <= 1'b1; //Выбор на основе command_x
							finish <= ~heaters_finish[command_x];
						end
						else
						begin
							finish <= 1'b1;
							error <= 1'b1;
						end
					end
					`GCODE_M109, `GCODE_M190:
					begin
						start_move <= 1'b0;
						start_heat_long <= 3'b000;
						//change_position <= 1'b0;
						enable_steppers <= 1'b0;
						disable_steppers <= 1'b0;
						if (command_x >=0 && command_x <= 2)
						begin
							start_heat_long[command_x] <= 1'b1; //Выбор на основе command_x
							finish <= 1'b1; 
							w = 'd100;
						end
						else
						begin
							finish <= 1'b1;
							error <= 1'b1;
						end
					end
					`GCODE_M106:
					begin
						start_cooling <= 1'b1; //Выбор на основе command_x
						finish <= 1'b1; 
					end
					`GCODE_M107:
					begin
						start_cooling <= 1'b0; //Выбор на основе command_x
						finish <= 1'b1; 
					end
					default: 
					begin
						start_move <= 1'b0;
						start_heat <= 3'b000;
						start_heat_long <= 3'b000;
						//change_position <= 1'b0;
						enable_steppers <= 1'b0;
						disable_steppers <= 1'b0;
						w = 'd0;
						finish <= 1'b1;
						error <= 1'b1; 
					end
				endcase
			end
			else
			begin
				if (~start)
				begin
					start_move = 1'b0;
					start_heat = 1'b0;
					start_heat_long = 1'b0;
					enable_steppers = 1'b0;
					disable_steppers = 1'b0;
					finish = 1'b0;	
					error = 1'b0;		
					w = 'd0;
				end
			end
		end
		else
			w <= w - 1;
	end
end


endmodule
