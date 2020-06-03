module heater_control(	input 	wire 				clk,
								input		wire	[11:0]	temp,
								input 	wire	signed	[11:0]	t,
								input		wire	signed	[11:0]	dt,
								input		wire	signed	[11:0]	max_temp,
								input		wire					heat,
								input		wire					heat_long,

								output	reg						enable_heater,
								output	reg						f);
wire [11:0] temp_filter;
wire	[11:0]	temp_bottom;
wire	[11:0]	temp_upper;
wire	[11:0]	temp_heat;

reg		signed	[11:0]	rth;
reg		signed	[11:0]	rt;
reg		signed	[11:0]	rdt;

reg [7:0] w;
reg				g;
reg				hp;
reg				hlp;

initial
begin
	enable_heater = 1'b0;
	f = 1'b1;
	rth = 'd0;
	rt = 'd0;
	rdt = 'd0;
	w = 'd0;
	g = 1'b0;
	hp = 1'b0;
	hlp = 1'b0;
end

analog_filter #(16) filter_1( .clk(clk),
										.signal_in(temp),
										.signal_out(temp_filter));

temp_adctemp tat0(.clk(clk),
					.temp(rth),
					.adc_temp(temp_heat));

temp_adctemp tat1(.clk(clk),
					.temp(rt-rdt),
					.adc_temp(temp_bottom));

temp_adctemp tat2(.clk(clk),
					.temp(rt),
					.adc_temp(temp_upper));
					
always @(posedge heat or posedge heat_long)
begin
	if (heat)
	begin
		if (t >= max_temp)
		begin
			rth <= 'd0;
			rt <= 'd0;
			rdt <= 'd0;
		end
		else
		begin
			rth <= t;
			rt <= 'd0;
			rdt <= 'd0;
		end
	end
	else
	begin
		if (t >= max_temp)
		begin
			rth <= 'd0;
			rt <= 'd0;
			rdt <= 'd0;
		end
		else
		begin
			rth <= 'd0;
			rt <= t;
			rdt <= dt;
		end
	end
end
					
always @(posedge clk)
begin
	g = (heat != hp) | (heat_long != hlp);
	hp = heat;
	hlp = heat_long;
	if (w <= 0)
	begin
		if (heat == 1'b0)
			f = 1'b1;

		if (heat == 1'b1) //нагрев
		begin
			if (f == 1'b1)
			begin
				if (g)
				begin
					w = 'd100;
				end
				else
				begin
					if (temp_filter <= temp_heat)
					begin
						enable_heater = 1'b0;
						f = 1'b0;
					end
					else
						enable_heater = 1'b1;
				end
			end
		end
		else 
		begin 
			if (g)
				w = 'd100;
			else
			begin
				if (temp_filter <= temp_upper)
				begin
					enable_heater = 1'b0;
				end
				else
				begin
					if (temp_filter >= temp_bottom)
						enable_heater = 1'b1;
				end
			end
		end
	end
	else
	begin
		w <= w - 1;
	end
end

endmodule
