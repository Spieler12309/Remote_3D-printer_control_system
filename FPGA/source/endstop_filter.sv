module endstop_filter(	input 	wire	clk,
								input		wire	in,
								output	reg	out);

reg [31:0] 	k;
reg 				prev;

initial
begin
	out 	= 0;
	k 		= 0;
	prev 	= 0;
end

always @(posedge clk)
begin
	if (in != out)
	begin
		if (k < 10000)
		begin
			if (in == prev)
				k = k + 1;
		end
		else
		begin
			if (k == 10000)
				out = prev;
		end
	end
	else
		k = 0;		
	prev = in;
end
								
endmodule
