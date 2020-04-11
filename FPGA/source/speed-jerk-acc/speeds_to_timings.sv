`include "../configuration.vh"

module speeds_to_timings(
	input		wire				clk,
	input		wire				reset,
	input		wire				start,
	input		wire	signed	[31:0]	num_x,
	input		wire	signed	[31:0]	num_y,
	input		wire	signed	[31:0]	num_z,
	input		wire	signed	[31:0]	num_e0,
	input		wire	signed	[31:0]	num_e1,
	input		wire	[31:0]	speed_x,
	input		wire	[31:0]	speed_y,
	input		wire	[31:0]	speed_z,
	input		wire	[31:0]	speed_e0,
	input		wire	[31:0]	speed_e1,
	input		wire	[31:0]	acceleration_x,
	input		wire	[31:0]	acceleration_y,
	input		wire	[31:0]	acceleration_z,
	input		wire	[31:0]	acceleration_e0,
	input		wire	[31:0]	acceleration_e1,
	input		wire	[31:0]	jerk_x,
	input		wire	[31:0]	jerk_y,
	input		wire	[31:0]	jerk_z,
	input		wire	[31:0]	jerk_e0,
	input		wire	[31:0]	jerk_e1,
		
	//output	reg				finish,
	//0   1   2   3     4
	//N, nn, t0, tna, delta
	output	reg	[31:0]	params_x 	[0:4],
	output	reg	[31:0]	params_y 	[0:4],
	output	reg	[31:0]	params_z 	[0:4],
	output	reg	[31:0]	params_e0 [0:4],
	output	reg	[31:0]	params_e1 [0:4],
	output	wire				finish
);

speed_to_timing stt(
	.clk(clk),
	.reset(reset),
	.start(start_stt),
	.num(num),
	.speed(speed), 
	.acceleration(acceleration), 
	.jerk(jerk), 
	
	.params(params),
	.finish(fin));

reg									start_stt;
reg	signed	[31:0]	num;
reg					[31:0]	speed;
reg					[31:0]	acceleration;
reg					[31:0]	jerk;

wire	[31:0]	params 	[0:4];
wire					fin;

reg		[4:0]		fins = 'd0;
reg		[15:0]	w = 'd0;

assign finish = fins[0] & fins[1] & fins[2] & fins[3] & fins[4];

always @(posedge clk)
begin
	if (w <= 0)
	begin
		if (start)
		begin
			if (~fin)
			begin
				if (fins[0] == 1'b0)
				begin
					num = num_x;
					speed = speed_x;
					acceleration = acceleration_x;
					jerk = jerk_x;
					start_stt = 1'b1;
				end
				else
				begin
					if (fins[1] == 1'b0)
					begin
						num = num_y;
						speed = speed_y;
						acceleration = acceleration_y;
						jerk = jerk_y;
						start_stt = 1'b1;
					end
					else
					begin
						if (fins[2] == 1'b0)
						begin
							num = num_z;
							speed = speed_z;
							acceleration = acceleration_z;
							jerk = jerk_z;
							start_stt = 1'b1;
						end
						else
						begin
							if (fins[3] == 1'b0)
							begin
								num = num_e0;
								speed = speed_e0;
								acceleration = acceleration_e0;
								jerk = jerk_e0;
								start_stt = 1'b1;
							end
							else
							begin
								if (fins[4] == 1'b0)
								begin
									num = num_e1;
									speed = speed_e1;
									acceleration = acceleration_e1;
									jerk = jerk_e1;
									start_stt = 1'b1;
								end
								else
								begin
									start_stt = 1'b0;
									w = 'd0;
								end
							end
						end
					end
				end
			end
			else
			begin				
				case (fins[0] + fins[1] + fins[2] + fins[3] + fins[4])
					0: params_x = params; 
					1: params_y = params; 
					2: params_z = params; 
					3: params_e0 = params; 
					4: params_e1 = params; 
					default : start_stt = 1'b0;
				endcase
				fins = fins << 1;
				fins[0] = 1'b1;
				start_stt = 1'b0;
				w = 'd20;
			end
		end
		else
		begin
			fins <= 5'b0;
			num <= 'd0;
			speed <= 'd0;
			acceleration <= 'd0;
			jerk <= 'd0;
			w <= 'd0;
			start_stt <= 1'b0;
		end
	end
	else
	begin
		w = w - 1;
	end
end

endmodule
