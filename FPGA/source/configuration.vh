`ifndef CONFIG_VH
`define CONFIG_VH

`define	MAIN_FREQ	'd50000000

//Работа с числами с фиксированной точностью
//Точность чисел
`define	FLOAT_NUMBER_FLOAT_PART				'd20
`define	FLOAT_NUMBER_MAX_FLOAT_PART		'd999999
`define	FLOAT_NUMBER_MAX_FLOAT_PART_MULT	'd999999999999
`define	FLOAT_NUMBER_INTEGER_PART			'd32
`define	FLOAT_NUMBER_LENGHT					'd53

//Операции с вещественными числами
`define	ALU_LEN		3
`define	FLOAT_ADD	`ALU_LEN'b000
`define	FLOAT_SUB	`ALU_LEN'b001
`define	FLOAT_MUL	`ALU_LEN'b010
`define	FLOAT_DIV	`ALU_LEN'b011

//Кодирование команд G-Code
`define	GCODE_G0		32'd0
`define	GCODE_G1		32'd1
`define	GCODE_G4		32'd2
`define	GCODE_G28	32'd3
`define	GCODE_G90	32'd4
`define	GCODE_G91	32'd5
`define	GCODE_G92	32'd6
`define	GCODE_M17	32'd7
`define	GCODE_M18	32'd8
`define	GCODE_M82	32'd9
`define	GCODE_M83	32'd10
`define	GCODE_M84	32'd11
`define	GCODE_M104	32'd12
`define	GCODE_M106	32'd13
`define	GCODE_M107	32'd14
`define	GCODE_M109	32'd15
`define	GCODE_M140	32'd16
`define	GCODE_M190	32'd17

//

`endif