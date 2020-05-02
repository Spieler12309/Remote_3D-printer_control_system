`include "../configuration.vh"
//`define DEBUG //Расскомментировать для тестирования

module speed_to_timing(
	input		wire									clk,
	input		wire									reset,
	input		wire									start,
	input		wire	signed	[31:0]	num,
	input		wire					[31:0]	speed, //микрошагов/сек
	//Ускорение принтера
	input		wire					[31:0]	acceleration, //микрошагов/сек^2
	//Рывок принтера
	input		wire					[31:0]	jerk, //микрошагов/сек
	
	
	//output	reg				finish,
	//0   1   2   3     4
	//N, nn, t0, tna, delta
`ifdef DEBUG
	output	wire					[31:0]	params_0,
	output	wire					[31:0]	params_1,
	output	wire					[31:0]	params_2,
	output	wire					[31:0]	params_3,
	output	wire					[31:0]	params_4,
`else
	output	reg						[31:0]	params		[0:4],
`endif
	output	reg										finish
	);

`ifdef DEBUG
	reg	[31:0]	params		[0:4];
	assign params_0 = params[0];
	assign params_1 = params[1];
	assign params_2 = params[2];
	assign params_3 = params[3];
	assign params_4 = params[4];
`endif

reg	[63:0]	t;

initial
begin
	params[0] = 'd0;
	params[1] = 'd0;
	params[2] = 'd0;
	params[3] = 'd0;
	params[4] = 'd0;
	t = 'd0;
end
	
always @(posedge clk)
begin
	if (reset)
	begin
		params[0] = 'd0;
		params[1] = 'd0;
		params[2] = 'd0;
		params[3] = 'd0;
		params[4] = 'd0;
		finish	 	= 'b0;
	end
	else
	begin
		if (start)
		begin
			if (~finish)
			begin
				params[0] = num < 'd0 ? -num : num;
				params[2] = `MAIN_FREQ / jerk;
				params[3] = `MAIN_FREQ / speed;
				t = (`MAIN_FREQ / acceleration) * (params[2] - params[3]) / (params[2] * params[3]);
				params[4] = ((params[2] * params[2]) - (params[3] * params[3])) / ((t << 1) * (`MAIN_FREQ) + params[3] - params[2]);
				if (params[4] == 0)
					params[4] = 1;
				
				if (params[4] < 0)
					params[4] = -params[4];
				params[1] = (params[3] - params[2]) / params[4];
				params[3] = params[2] - params[4] * params[1];
				finish = 'b1;
			end
		end
		else
		begin
			params[0] = 'd0;
			params[1] = 'd0;
			params[2] = 'd0;
			params[3] = 'd0;
			params[4] = 'd0;	
			finish	  = 'b0;
		end
	end
end
	
endmodule
