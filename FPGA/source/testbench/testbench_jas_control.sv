`include "../configuration.vh"

module testbench_jas_control();

reg																clk;
reg																reset;
reg	[31:0]												f_max;
reg	[31:0]												f_min;
reg	[31:0]												delta;
reg																start;
reg	[`FLOAT_NUMBER_LENGHT - 1:0]	beta;
reg	[31:0]												acc_steps_number;
reg	[31:0]												steps_number;

wire															fin2;
wire															step;

reg [7:0] num = 0;
reg	[31:0] del = 'd10;

jas_constrol jas_constrol1(clk, reset, f_max, f_min, delta, start, steps_number, fin2, step);

initial
forever begin
	clk = 1'b0;
	#5 clk = ~clk;
	#5 $display("finish = %b, step = %b", 
						 fin2, step);
end

initial
begin
	reset = 1'b0;
	f_max = 'd8;
	f_min = 'd2;
	delta = 'd1;
	beta = 'd1;
	acc_steps_number = 'd5;
	steps_number = 'd15;
	start = 1'b1;
	#1000
	reset = 1'b1;
	start = 1'b0;
	$display("---------------------------------------",);
	#10
	reset = 1'b0;
	f_max = 'd10;
	f_min = 'd2;
	delta = 'd1;
	beta = 'd1;
	acc_steps_number = 'd5;
	steps_number = 'd5;
	start = 1'b1;
	#1100
	$finish;
end

always @(posedge step)
begin
	$monitor("%0d \t %b", $time, clk);
	$display("Impulse = %d.time = %d.", 
						 num, ($time() - del) / 10);
	del = $time;
	num = num + 1;
end

endmodule
