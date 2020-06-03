`include "../configuration.vh"

module speed_to_timing(
	input		wire									clk,
	input		wire									reset,
	input		wire									start,
	input		wire									const_speed,
	input		wire	signed	[31:0]	num,
	input		wire					[31:0]	speed, //микрошагов/сек
	//Ускорение принтера
	input		wire					[31:0]	acceleration, //микрошагов/сек^2
	//Рывок принтера
	input		wire					[31:0]	jerk, //микрошагов/сек
	
	
	//output	reg				finish,
	//0   1   2   3     4
	//N, nn, t0, tna, delta
	output	reg						[31:0]	params		[0:4],
	output	reg										finish
	);

reg	[63:0]	t;
reg [3:0] state;
reg [15:0] w;

initial
begin
	params[0] <= 'd0;
	params[1] <= 'd0;
	params[2] <= 'd0;
	params[3] <= 'd0;
	params[4] <= 'd0;
	t <= 'd0;
	finish <= 'b0;
	state <= 'd0;
	w <= 'd0;
end
	
always @(posedge clk)
begin
	if (reset)
	begin
		params[0] <= 'd0;
		params[1] <= 'd0;
		params[2] <= 'd0;
		params[3] <= 'd0;
		params[4] <= 'd0;
		finish	 	<= 'b0;
		t <= 'd0;
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
					if (num != 0)
					begin
						if (~const_speed)
						begin
							case (state)
								0: begin
									state <= state + 1;
									w <= 'd10;
									params[0] <= 	(num < 'd0)
																? ~num + 1 
																: num;
								end
								1: begin 
									state <= state + 1;
									w <= 'd10;
									params[2] <= 	(jerk == 'd0) 
																? `MAIN_FREQ  
																: `MAIN_FREQ / jerk; 
								end
								2: begin 
									state <= state + 1;
									w <= 'd10;
									params[3] <= `MAIN_FREQ / speed; 
								end
								3: begin
									state <= state + 1;
									w <= 'd10;
									t <= (((params[2] * params[2]) - (params[3] * params[3])) * acceleration); 
								end
								4: begin 
									state <= state + 1;
									w <= 'd10;
									params[4] <= 	(params[2] == params[3]) 
																? 'd0 
																: t / (2 * `MAIN_FREQ * (speed - jerk)); 
								end
								5: begin 
									state <= state + 1;
									w <= 'd10;
									params[4] <= 	(params[4] == 'd0 && params[2] != params[3]) 
																? 'd1 
																: params[4]; 
								end
								6: begin 
									state <= state + 1;
									w <= 'd10;
									params[4] <= 	(params[4] > params[2] - params[3]) 
																? (params[2] - params[3]) 
																: params[4]; 
								end
								7: begin 
									state <= state + 1;
									w <= 'd10;
									params[1] <= 	(params[4] == 'd0) 
																? 'd0 
																: (params[2] - params[3]) / params[4]; 
								end
								8: begin 
									state <= state + 1;
									w <= 'd10;
									params[3] <= params[2] - params[4] * params[1]; 
								end
								9: finish <= 1'b1;
								default: state <= 0;
							endcase
						end
						else
						begin
							case (state)
								0: begin
									state <= state + 1;
									w <= 'd10;
									params[0] <= 	(num < 'd0)
												? ~num + 1 
												: num;
								end
								1: begin
									state <= state + 1;
									w <= 'd10;
									params[1] <= 'd0;
								end
								2: begin
									state <= state + 1;
									w <= 'd10;
									params[2] <= `MAIN_FREQ / speed;
								end
								3: begin
									state <= state + 1;
									w <= 'd10;
									params[3] <= params[2];
								end
								4: begin
									state <= state + 1;
									w <= 'd10;
									params[4] <= 'd0;
								end
								5: finish <= 'b1;
								default: state <= 0;
							endcase
						end					
					end
					else
						finish <= 'b1;
				end
			end
			else
			begin
				params[0] <= 'd0;
				params[1] <= 'd0;
				params[2] <= 'd0;
				params[3] <= 'd0;
				params[4] <= 'd0;	
				finish	  <= 'b0;
				t <= 'd0;
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
