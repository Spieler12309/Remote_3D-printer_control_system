`include "../configuration.vh"

module jas_constrol(
	input		wire																clk,
	input		wire																reset,
	input		wire	[31:0]												t0,	//Максимальная задержка между импульсами
	input		wire	[31:0]												tna,	//Минимальная задержка между импульсами
	input		wire	[31:0]												delta, //Пошаговое уменьшение задержки между импульсами
	input		wire																start,	//Сигнал начала ускорения
	input		wire	[31:0]												N,	//Количество шагов для движения

	output	wire																finish,	//Сигнал окончания движения
	output	reg																	step);	//Сигнал двигателя
	
reg	[31:0]	i = 0;
reg fin = 1'b0;
reg [31:0]	wait_step = 'b0;
reg [31:0]	n_acc = 'b0;
reg [31:0]	step_num = 'b0;
assign finish = start & fin;

always @(posedge clk or posedge reset)
begin
	if (reset)
	begin
		fin = 1'b0;
		step_num = 'b0;
		wait_step = t0;
		i = 'b0;
	end
	else
	begin
		if (start & ~fin)
			if (step_num == 0 & i == 0)
			begin
				i = i + 1;
				fin = 'b0;
				step_num = 'b0;
				wait_step = t0;
			end
			else
			begin
				if (step_num < (N - 1))
				begin
					if (i < wait_step - 1)
						i = i + 1;
					else
					begin
						i = 0;
						step_num = step_num + 1;
						if (step_num < (N >> 1))
						begin
							wait_step = (tna > (wait_step - delta)) ? tna : wait_step - delta;
							if (wait_step > tna)
								n_acc = n_acc + 1;
						end	
						else
						begin
							if (step_num > ((((N - n_acc - 2) > (N >> 1))) ? N - n_acc - 2 : N >> 1))
								wait_step = (tna > (wait_step + delta)) ? tna : wait_step + delta;
						end
					end		
				end
				else
				begin
					fin = 1'b1;
					i = 0'b0;
				end
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
