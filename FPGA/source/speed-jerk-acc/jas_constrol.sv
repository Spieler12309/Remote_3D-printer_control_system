`include "../configuration.vh"
//`define DEBUG //Расскомментировать для тестирования

module jas_constrol(
	input		wire					clk,
	input		wire					reset,
	input		wire					start,	//Сигнал начала ускорения
`ifdef DEBUG
	input		wire	[31:0]	params_0,
	input		wire	[31:0]	params_1,
	input		wire	[31:0]	params_2,
	input		wire	[31:0]	params_3,
	input		wire	[31:0]	params_4,
`else
	input		wire	[31:0]	params 		[0:4],
`endif

	output	reg						finish,	//Сигнал окончания движения
	output	reg		[31:0]	step_num,
	output	reg						step);	//Сигнал двигателя

`ifdef DEBUG
	wire	[31:0]	params 		[0:4];
	assign params[0] = params_0;
	assign params[1] = params_1;
	assign params[2] = params_2;
	assign params[3] = params_3;
	assign params[4] = params_4;
`endif

wire	[31:0]	N 		= params[0]; //Количество шагов для движения
wire	[31:0]	nn 		= params[1]; //Количество шагов для ускорения
wire	[31:0]	t0 		= params[2]; //Максимальная задержка между импульсами
wire	[31:0]	tna 	= params[3]; //Минимальная задержка между импульсами
wire	[31:0]	delta = params[4]; //Пошаговое уменьшение задержки между импульсами

reg		[31:0]	i;
reg		[31:0]	wait_step;
reg		[31:0]	g;

initial
begin
	finish		=	'b0;
	step_num	=	'd0;
	step 			=	'b0;

	g = 'd0;
	i = 'd0;
	wait_step = 'b0;
end

always @(posedge clk or posedge reset)
begin
	if (reset)
	begin
		finish = 1'b0;
		step_num = 'b0;
		wait_step = 'b0;
		i = 'b0;
		g = 'b0;
	end
	else
	begin
		if (start)
		begin
			if (step_num == 0 & i == 0)
			begin
				i = i + 1;
				finish = 'b0;
				step_num = 'b0;
				wait_step = t0;
				g = 0;
			end
			else
			begin
				if (step_num < N)
				begin
					if (i < wait_step - 1)
						i = i + 1;
					else
					begin
						i = 0;
						step_num = step_num + 1;
						if (step_num < ((N >> 1) + N[0]))
						begin
							if (wait_step != tna)
								g = delta < (wait_step - tna) ? delta : wait_step - tna;
							wait_step = tna > (wait_step - delta) ? tna : wait_step - delta;
						end	
						else
						begin
							if (step_num >= (((N - nn) > ((N >> 1) + 1)) ? N - nn : (N >> 1) + 1))
							begin
								wait_step = t0 < (wait_step + g) ? t0 : wait_step + g;
								g = delta;
							end
						end
					end		
				end
				else
				begin
					finish = 1'b1;
					i = 'b0;
				end
			end
		end
		else
		begin
			finish = 1'b0;
			step_num = 'b0;
			wait_step = t0;
			i = 'b0;
			g = 'b0;
		end
	end
end

always @(negedge clk or posedge reset)
begin
	if (reset)
		step = 1'b0;
	else
		if (i < (wait_step >> 1))
			step = 1'b1;
		else
			step = 1'b0;
end

endmodule
