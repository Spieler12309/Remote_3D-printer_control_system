module calc_new_parameters(
	input		wire				clk,
	input		wire				reset,
	input		wire	[31:0]	max_params 	[0:4],
	input		wire	[31:0]	params 		[0:4],
	input		wire	[63:0]	max_timing 	[0:3],
	input		wire				start,	//Сигнал начала ускорения

	output	reg	[31:0]	new_par		[0:4],
	output	reg				finish	//Сигнал окончания движения
	);

reg	[63:0]	t1 = 0;
reg	[63:0]	t2 = 0;
reg	[63:0]	t3 = 0;
reg	[63:0]	tt = 0;
reg	[31:0]	nn = 0;
	
always @(posedge clk)
begin
	if (reset)
	begin
		new_par[0]	<= 'd0;
		new_par[1]	<= 'd0;
		new_par[2]	<= 'd0;
		new_par[3]	<= 'd0;
		new_par[4]	<= 'd0;
		finish 		<= 'd0;
	end
	else
	begin
		new_par = params;
		//0   1   2   3     4
		//N, nn, t0, tna, delta
		
		// 0   1   2   3
		//t1, t2, t3, tt		

		t1 = max_timing[0];
		t2 = max_timing[1];
		t3 = max_timing[2];
		tt = max_timing[3];
		nn = max_params[1];
		if (max_params[0] >= ((nn << 1) + 'd2))
		begin
			if (new_par[0] == 'd0)
			begin
				new_par[1] <= 'd0;
				new_par[3] <= 'd0;
				new_par[2] <= 'd0;
				new_par[4] <= 'd0;
			end
			else
			begin
				if (new_par[0] == 1)
				begin
					new_par[1] <= 'd1;
					new_par[3] <= max_params[2];
					new_par[2] <= tt;
					new_par[4] <= max_params[3];
				end
				else
				begin
					if (new_par[0] == 2)
					begin
						 new_par[1] <= 'd1;
						 new_par[3] <= max_params[2];
						 new_par[2] <= tt >> 1;
						 new_par[4] <= new_par[1] - new_par[2];
					end
					else
					begin
						 new_par[1] = max_params[1] * new_par[0] / max_params[0];
						 if (new_par[1] == 0)
							  new_par[1] = 'd1;
						 
						 if ((new_par[0] - (new_par[1] << 1)) == 0)
							  new_par[3] = max_params[3];
						 else
							  new_par[3] = t2 / (new_par[0] - (new_par[1] << 1));
							  
						 new_par[2] = ((t1 << 1) - new_par[3] * (new_par[1] - 'd1)) / (new_par[1] + 'd1);
						 new_par[4] = (new_par[3] - new_par[2]) / new_par[1];
					end
				end
			end
		end
		else
		begin
			t1 = tt << 1;
			if (new_par[0] == 0)
			begin
				new_par[1] <= 0;
				new_par[2] <= 0;
				new_par[3] <= 0;
				new_par[4] <= 0;
			end
			else
			begin
				if (new_par[0] == 1)
				begin
					new_par[1] <= 'd1;
					new_par[3] <= max_params[2];
					new_par[2] <= tt;
					new_par[4] <= max_params[3];
				end
				else
				begin
					if (new_par[0] == 2)
					begin
						new_par[1] <= 'd1;
						new_par[3] <= max_params[2];
						new_par[2] <= tt << 1;
						new_par[4] <= new_par[1] - new_par[2];
					end
					else
					begin
						 new_par[1] = new_par[0] << 1;
						 if (new_par[1] == 0)
							  new_par[1] = 'd1;
							  
						 new_par[3] = max_params[2] + max_params[4] * (max_params[0] << 1);
						 new_par[2] = ((t1 << 1) - new_par[3] * (new_par[1] - 1)) / (new_par[1] + 1);
						 new_par[4] = (new_par[3] - new_par[2]) / new_par[1];
					end
				end
			end
		end
	end
end

endmodule
