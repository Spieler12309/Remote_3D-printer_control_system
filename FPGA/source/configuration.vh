`ifndef CONFIG_VH
`define CONFIG_VH

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


//

`endif