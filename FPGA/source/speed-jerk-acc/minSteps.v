module minSteps(
					input wire [31:0] pulseSpeed,
					input wire [31:0] pulseJerk,
					input wire [31:0] pulseAcceleration,
					output wire [31:0] pulseMin);
					
	assign pulseMin = (PulseSpeed - pulseJer + pulseAcceleration) / pulseAcceleration;

	

endmodule
