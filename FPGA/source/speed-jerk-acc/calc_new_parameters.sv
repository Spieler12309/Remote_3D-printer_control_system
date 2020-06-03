module calc_new_parameters(
	input		wire					clk,
	input		wire					reset,
	input		wire					start,	//Разрешение для вычисления
	input		wire					const_speed,
	input		wire	[31:0]	max_params 	[0:4],
	input		wire	[31:0]	params 		[0:4],
	input		wire	[63:0]	max_timing 	[0:3],

	output	reg		[31:0]	new_par		[0:4],
	output	reg						finish
	);

reg [3:0] state;
reg [15:0] w;
	
initial
begin
	new_par[0]  <= 'd0;
	new_par[1]  <= 'd0;
	new_par[2]  <= 'd0;
	new_par[3]  <= 'd0;
	new_par[4]  <= 'd0;
	finish <= 0;

	state <= 'd0;
	w <= 'd0;
end

always @(posedge clk)
begin
	if (reset)
	begin
		new_par[0] <= 'd0;
		new_par[1] <= 'd0;
		new_par[2] <= 'd0;
		new_par[3] <= 'd0;
		new_par[4] <= 'd0;
		finish <= 'b0;
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
					if (~const_speed)
					begin
						if (max_params[0] >= ((max_params[1] << 1) + 'd2))
						begin
							if (params[0] == 'd0)
							begin
								new_par[1] <= 'd0;
								new_par[3] <= 'd0;
								new_par[2] <= 'd0;
								new_par[4] <= 'd0;
								finish <= 'b1;
							end
							else
							begin
								if (params[0] == 1)
								begin
									new_par[1] <= 'd1;
									new_par[3] <= max_params[2];
									new_par[2] <= max_timing[3];
									new_par[4] <= max_params[3];
									finish <= 'b1;
								end
								else
								begin
									if (params[0] == 2)
									begin
										new_par[1] <= 'd1;
										new_par[3] <= max_params[2];
										new_par[2] <= max_timing[3] >> 1;
										new_par[4] <= new_par[2] - new_par[3];
										finish <= 'b1;
									end
									else
									begin
										case (state)
											0: begin
												state <= state + 1;
												w <= 'd10;
												new_par[0] <= params[0];
											end
											1: begin 
												state <= state + 1;
												w <= 'd10;
												new_par[1] <= max_params[1] * new_par[0] / max_params[0];
											end
											2: begin 
												state <= state + 1;
												w <= 'd10;
												new_par[3] <= 	((new_par[0] - (new_par[1] << 1)) == 0) 
																				? max_params[3] 
																				: max_timing[1] / (new_par[0] - (new_par[1] << 1));
											end
											3: begin
												state <= state + 1;
												w <= 'd10;
												new_par[2] <= 	(new_par[1] != 0) 
																				? ((max_timing[0] << 1) - new_par[3] * (new_par[1] - 1)) / (new_par[1] + 1) 
																				: new_par[3];
											end
											4: begin 
												state <= state + 1;
												w <= 'd10;
												new_par[4] <= 	(new_par[1] == 0)
																				? new_par[2] - new_par[3]
																				: (new_par[2] - new_par[3]) / new_par[1];
											end
											5: begin 
												state <= state + 1;
												w <= 'd10;
												new_par[4] <=  	(new_par[4] == 0 && new_par[2] != new_par[3])
																				? 1
																				: new_par[4];
											end
											6: begin 
												state <= state + 1;
												w <= 'd10;
												new_par[1] <= 	(new_par[4] == 1)
																				? new_par[2] - new_par[3]
																				: new_par[1];
											end
											7: begin 
												state <= state + 1;
												w <= 'd10;
												new_par[1] <= 	(new_par[1] == 0 && new_par[4] != 0)
																				? 1
																				: new_par[1];
											end
											8: finish <= 1'b1;
											default: state <= 0;
										endcase
									end
								end
							end
						end
						else
						begin
							if (params[0] == 0)
							begin
								new_par[1] <= 0;
								new_par[2] <= 0;
								new_par[3] <= 0;
								new_par[4] <= 0;
								finish <= 'b1;
							end
							else
							begin
								if (params[0] == 1)
								begin
									new_par[1] <= 'd1;
									new_par[3] <= max_params[2];
									new_par[2] <= max_timing[3];
									new_par[4] <= max_params[3];
									finish <= 'b1;
								end
								else
								begin
									if (params[0] == 2)
									begin
										new_par[1] <= 'd1;
										new_par[3] <= max_params[2];
										new_par[2] <= max_timing[3] >> 1;
										new_par[4] <= new_par[2] - new_par[3];
										finish <= 'b1;
									end
									else
									begin
										case (state)
											0: begin
												state <= state + 1;
												w <= 'd10;
												new_par[0] <= params[0];
											end
											1: begin 
												state <= state + 1;
												w <= 'd10;
												new_par[1] <= (new_par[0][31:1] == 'd0) 
																			? 'd1
																			: new_par[0] >> 1;
											end
											2: begin 
												state <= state + 1;
												w <= 'd10;
												new_par[3] <= max_params[2] - max_params[4] * (max_params[0] >> 1);
											end
											3: begin
												state <= state + 1;
												w <= 'd10;
												new_par[2] <= (max_timing[3] / new_par[1]) - new_par[3];
											end
											4: begin 
												state <= state + 1;
												w <= 'd10;
												new_par[4] <= (new_par[2] - new_par[3]) / new_par[1];
											end
											5: finish <= 1'b1;
											default: state <= 0;
										endcase
									end
								end
							end
						end
					end
					else
					begin
						if (params[0] != 0)
						begin
							case (state)
								0: begin
									state <= state + 1;
									w <= 'd10;
									new_par[0] <= params[0];
								end
								1: begin 
									state <= state + 1;
									w <= 'd10;
									new_par[1] <= 'd0;
								end
								2: begin 
									state <= state + 1;
									w <= 'd10;
									new_par[2] <= max_params[0] * max_params[2] / new_par[0];
								end
								3: begin 
									state <= state + 1;
									w <= 'd10;
									new_par[3] <= new_par[2];
								end
								4: begin 
									state <= state + 1;
									w <= 'd10;
									new_par[4] <= 'd0;
								end
								5: finish <= 'b1;
								default: state <= 0;
							endcase
						end
						else
						begin
							new_par[1] <= 'd0;
							new_par[2] <= 'd0;
							new_par[3] <= 'd0;
							new_par[4] <= 'd0;
							finish <= 'b1;
						end
					end
				end
			end
			else
			begin
				new_par[0] <= 'd0;
				new_par[1] <= 'd0;
				new_par[2] <= 'd0;
				new_par[3] <= 'd0;
				new_par[4] <= 'd0;

				finish <= 'b0;
				state <= 'd0;
				w <= 'd0;
			end
		end
		else
			w <= w - 1;
	end
end

endmodule
