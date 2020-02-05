module calc_time(	
	input		wire				clk,
	input		wire				reset,
	input		wire				start,	//Сигнал начала ускорения
	input		wire	[31:0]	params [0:4],


	output	wire	[63:0]	timing 	[0:3],
	output	reg				finish	//Сигнал окончания движения
	);

wire	[31:0]	N 		= params[0]; //Количество шагов для движения
wire	[31:0]	nn 	= params[1]; //Количество шагов для ускорения
wire	[31:0]	t0 	= params[2]; //Максимальная задержка между импульсами
wire	[31:0]	tna 	= params[3]; //Минимальная задержка между импульсами
wire	[31:0]	delta = params[4]; //Пошаговое уменьшение задержки между импульсами
	
reg	[31:0]	a = 'd0;
reg	[63:0]	t1 = 0;
reg	[63:0]	t2 = 0;
reg	[63:0]	t3 = 0;
reg	[63:0]	tt = 0;

assign timing[0] = t1;
assign timing[1] = t2;
assign timing[2] = t3;
assign timing[3] = tt;

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
			if (N > (nn << 1))
			begin
				t1 = t0 * nn - (nn * (delta * (nn - 1)) / 2);
				t2 = tna * (N - (nn << 1));
				t3 = t1;
				tt = t1 + t2 + t3;
				finish = 1'b1;
			end
			else
			begin
				a = (N >> 1);
				t1 = t0 * a - (a * (delta * (a - 1)) / 2);
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
