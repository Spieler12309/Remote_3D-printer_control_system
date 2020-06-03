`include "../configuration.vh"

module testbench_calc_times();

localparam PERIOD = 10;

reg 					clk 						= 1'b0;
reg 					reset 					= 1'b0;
reg 					start 					= 1'b0;
reg		[31:0]	params_x 	[0:4];
reg		[31:0]	params_y 	[0:4];
reg		[31:0]	params_z 	[0:4];
reg		[31:0]	params_e0 [0:4];
reg		[31:0]	params_e1 [0:4];

wire	[63:0]	timing_x 		[0:3];
wire	[63:0]	timing_y 		[0:3];
wire	[63:0]	timing_z 		[0:3];
wire	[63:0]	timing_e0 	[0:3];
wire	[63:0]	timing_e1 	[0:3];
wire					finish;

calc_times ct1(
	.clk(clk),
	.reset(reset),
	.start(start),
	.params_x(params_x),
	.params_y(params_y),
	.params_z(params_z),
	.params_e0(params_e0),
	.params_e1(params_e1),

	.timing_x(timing_x),
	.timing_y(timing_y),
	.timing_z(timing_z),
	.timing_e0(timing_e0),
	.timing_e1(timing_e1),
	.finish(finish)
	);

always
	#(PERIOD/2) clk = ~clk;

initial
begin
	
	params_x[0]					= 10000;
	params_x[1]					= 83;
	params_x[2]					= 600;
	params_x[3]					= 102;
	params_x[4]					= 6;

	params_y[0]					= 20000;
	params_y[1]					= 8;
	params_y[2]					= 6024;
	params_y[3]					= 600;
	params_y[4]					= 678;

	params_z[0]					= 30000;
	params_z[1]					= 42;
	params_z[2]					= 600;
	params_z[3]					= 138;
	params_z[4]					= 11;

	params_e0[0]				= 500000;
	params_e0[1]				= 1;
	params_e0[2]				= 62500;
	params_e0[3]				= 600;
	params_e0[4]				= 61900;

	params_e1[0]				= 100000;
	params_e1[1]				= 180;
	params_e1[2]				= 600;
	params_e1[3]				= 60;
	params_e1[4]				= 3;

	#10;

	start = 1;

	wait(finish);
	$display("calculating");
	$display("%0d \t %b X : t1 = %10d, t2 = %10d, t3 = %10d, tt = %10d", 
					$time, finish, timing_x[0], timing_x[1], timing_x[2], timing_x[3]);
	$display("%0d \t %b Y : t1 = %10d, t2 = %10d, t3 = %10d, tt = %10d", 
					$time, finish, timing_y[0], timing_y[1], timing_y[2], timing_y[3]);
	$display("%0d \t %b Z : t1 = %10d, t2 = %10d, t3 = %10d, tt = %10d", 
					$time, finish, timing_z[0], timing_z[1], timing_z[2], timing_z[3]);
	$display("%0d \t %b E0: t1 = %10d, t2 = %10d, t3 = %10d, tt = %10d", 
					$time, finish, timing_e0[0], timing_e0[1], timing_e0[2], timing_e0[3]);
	$display("%0d \t %b E1: t1 = %10d, t2 = %10d, t3 = %10d, tt = %10d", 
					$time, finish, timing_e1[0], timing_e1[1], timing_e1[2], timing_e1[3]);
	start = 0;
	#10;
	reset = 1;

	#10;
	$display("reset");
	$display("%0d \t %b X : t1 = %10d, t2 = %10d, t3 = %10d, tt = %10d", 
					$time, finish, timing_x[0], timing_x[1], timing_x[2], timing_x[3]);
	$display("%0d \t %b Y : t1 = %10d, t2 = %10d, t3 = %10d, tt = %10d", 
					$time, finish, timing_y[0], timing_y[1], timing_y[2], timing_y[3]);
	$display("%0d \t %b Z : t1 = %10d, t2 = %10d, t3 = %10d, tt = %10d", 
					$time, finish, timing_z[0], timing_z[1], timing_z[2], timing_z[3]);
	$display("%0d \t %b E0: t1 = %10d, t2 = %10d, t3 = %10d, tt = %10d", 
					$time, finish, timing_e0[0], timing_e0[1], timing_e0[2], timing_e0[3]);
	$display("%0d \t %b E1: t1 = %10d, t2 = %10d, t3 = %10d, tt = %10d", 
					$time, finish, timing_e1[0], timing_e1[1], timing_e1[2], timing_e1[3]);

	$stop;
end

endmodule
