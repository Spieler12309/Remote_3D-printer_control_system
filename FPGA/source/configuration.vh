`ifndef CONFIG_VH
`define CONFIG_VH

`define	MAIN_FREQ	'd50000000 //Для управления двигателями

//Кодирование команд G-Code
`define	GCODE_G0  	32'd0
`define	GCODE_G1  	32'd1
`define	GCODE_G4  	32'd2
`define	GCODE_G28 	32'd3
`define	GCODE_G90 	32'd4
`define	GCODE_G91 	32'd5
`define	GCODE_G92 	32'd6
`define	GCODE_M6  	32'd7
`define	GCODE_M17 	32'd8
`define	GCODE_M18 	32'd9
`define	GCODE_M82 	32'd10
`define	GCODE_M83 	32'd11
`define	GCODE_M104	32'd12
`define	GCODE_M105	32'd13
`define	GCODE_M106	32'd14
`define	GCODE_M107	32'd15
`define	GCODE_M109	32'd16
`define	GCODE_M114	32'd17
`define	GCODE_M119	32'd18
`define	GCODE_M140	32'd19
`define	GCODE_M190	32'd20

//

`endif