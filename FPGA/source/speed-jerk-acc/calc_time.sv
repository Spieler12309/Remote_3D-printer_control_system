//`define DEBUG //Расскомментировать для тестирования

module calc_time(	
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
	
`ifdef DEBUG
	output	wire	[63:0]	timing_0,
	output	wire	[63:0]	timing_1,
	output	wire	[63:0]	timing_2,
	output	wire	[63:0]	timing_3,
`else
	output	wire	[63:0]	timing 	[0:3],
`endif
	output	reg						finish	//Сигнал окончания движения
	);

`ifdef DEBUG
	wire	[31:0]	params 		[0:4];

	assign params[0] = params_0;
	assign params[1] = params_1;
	assign params[2] = params_2;
	assign params[3] = params_3;
	assign params[4] = params_4;


	wire	[63:0]	timing 	[0:3];
	assign timing_0 = timing[0];
	assign timing_1 = timing[1];
	assign timing_2 = timing[2];
	assign timing_3 = timing[3];
`endif

wire	[31:0]	N;
wire	[31:0]	nn;
wire	[31:0]	t0;
wire	[31:0]	tna;
wire	[31:0]	delta;

reg		[31:0]	a;
reg		[63:0]	t1;
reg		[63:0]	t2;
reg		[63:0]	t3;
reg		[63:0]	tt;


assign N 		 = params[0]; //Количество шагов для движения
assign nn 	 = params[1]; //Количество шагов для ускорения
assign t0 	 = params[2]; //Максимальная задержка между импульсами
assign tna 	 = params[3]; //Минимальная задержка между импульсами
assign delta = params[4]; //Пошаговое уменьшение задержки между импульсами

assign timing[0] = t1;
assign timing[1] = t2;
assign timing[2] = t3;
assign timing[3] = tt;

initial
begin
	a = 'd0;
	t1 = 'd0;
	t2 = 'd0;
	t3 = 'd0;
	tt = 'd0;
end

always @(posedge clk)
begin
	if (reset)
	begin
		t1 = 'd0;
		t2 = 'd0;
		t3 = 'd0;
		tt = 'd0;
		finish = 1'b0;
	end
	else
	begin
		if (start)
		begin
			if (~finish)
			begin
				a = (N > (nn << 1)) ? nn : (N >> 1);
				t1 = t0 * a - (a * (delta * (a - 1)) >> 1);

				if (N > (nn << 1))
					t2 = tna * (N - (nn << 1));
				else
					t2 = (N[0] == 1) ? (t0 - delta * a) : 'd0;	
				t3 = t1;
				tt = t1 + t2 + t3;
				finish = 1'b1;
			end
		end
		else
		begin
			t1 = 'd0;
			t2 = 'd0;
			t3 = 'd0;
			tt = 'd0;
			finish = 1'b0;
		end	
	end
end

endmodule
