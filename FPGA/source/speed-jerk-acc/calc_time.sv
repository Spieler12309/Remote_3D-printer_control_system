module calc_time(	
	input		wire					clk,
	input		wire					reset,
	input		wire					start,	//Сигнал начала ускорения
	input		wire	[31:0]	params 		[0:4],

	output	wire	[63:0]	timing 	[0:3],
	output	reg						finish	//Сигнал окончания движения
	);

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

reg [2:0] state;
reg [15:0] w;


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
	a <= 'd0;
	t1 <= 'd0;
	t2 <= 'd0;
	t3 <= 'd0;
	tt <= 'd0;
	finish <= 'd0;
	state <= 'd0;
	w <= 'd0;
end

always @(posedge clk)
begin
	if (reset)
	begin
		t1 <= 'd0;
		t2 <= 'd0;
		t3 <= 'd0;
		tt <= 'd0;
		finish <= 1'b0;
		state <= 'd0;
		w <= 'd0;
	end
	else
	begin
		if (w <= 0)
		begin
			if (start)
			begin
				if (~finish)
				begin
					case (state)
					0:begin
						state <= state + 1;
						w <= 'd10;
						a <= (N > (nn << 1)) ? nn : (N >> 1);
					end
					1:begin
						state <= state + 1;
						w <= 'd10;
						t1 <= t0 * a - (a * (delta * (a - 1)) >> 1);
					end
					2: begin
						state <= state + 1;
						w <= 'd10;
						if (N > (nn << 1))
							t2 <= tna * (N - (nn << 1));
						else
							t2 <= (N[0] == 1) ? (t0 - delta * a) : 'd0;	
					end
					3: begin
						state <= state + 1;
						w <= 'd10;
						t3 <= t1;
					end
					4: begin
						state <= state + 1;
						w <= 'd10;
						tt <= t1 + t2 + t3;
					end
					5: finish <= 1'b1;
					default: state <= 0;
				endcase
				end
			end
			else
			begin
				t1 <= 'd0;
				t2 <= 'd0;
				t3 <= 'd0;
				tt <= 'd0;
				finish <= 1'b0;
				state <= 'd0;
				w <= 'd0;
			end	
		end
		else
		begin
			w <= w - 1;
		end
	end
end

endmodule
