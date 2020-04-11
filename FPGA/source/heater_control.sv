module heater_control(	input 	wire 				clk,
								input		wire	[11:0]	temp,
								input 	wire	signed	[11:0]	t,
								input		wire	signed	[11:0]	dt,
								input		wire					heat,
								input		wire					heat_long,

								output	reg						enable_heater = 1'b0,
								output	reg						f = 1'b1);
wire [11:0] temp_filter;
wire	[11:0]	temp_bottom;
wire	[11:0]	temp_upper;

reg		signed	[11:0]	rt = 'd0;
reg		signed	[11:0]	rdt = 'd0;
reg [7:0] w = 'd0;
reg		g = 1'b0;
reg		hp = 1'b0;
reg		hlp = 1'b0;

analog_filter #(16) filter_1( .clk(clk),
										.signal_in(temp),
										.signal_out(temp_filter));

temp_adctemp tat1(.clk(clk),
					.temp(rt-rdt),
					.res(100000),
					.voltage(33), //Напряжение, умноженное на k
					.k(10),
					.adc_temp(temp_bottom));

temp_adctemp tat2(.clk(clk),
					.temp(rt),
					.res(100000),
					.voltage(33), //Напряжение, умноженное на k
					.k(10),
					.adc_temp(temp_upper));

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
					if (temp_filter <= temp_upper)
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
			if (heat_long == 1'b1) //нагрев и удержание
			begin
				if (g)
				begin
					w = 'd100;
				end
				else
				begin
					if (temp_filter <= temp_upper)
						enable_heater = 1'b0;
					else
						if (temp_filter >= temp_bottom)
							enable_heater = 1'b1;
				end
			end
			else
				enable_heater = 1'b0;
		end
	end
	else
	begin
		w <= w - 1;
	end
end

endmodule
