module adctemp_temp
	#(
	parameter res = 100000,
	parameter voltage = 33,
	parameter k = 10)
	(
	input 	wire							clk,
	input		wire 							reset,
	input		wire				[11:0]	adc_temp,
	output	reg 	signed	[11:0]	temp);
	
reg [31:0]	mem	[0:72];
reg [31:0]	rt;
reg [31:0]	t;
reg [31:0]	t2;
reg [7:0]		i;
reg [1:0]		state;


always @(posedge clk)
begin
	if (reset)
	begin
		state <= 'd0;
		i <= 'd0;
		rt <= 0;
		temp <= 'd0;
	end
	else
	begin	
		case (state)
			0:
			begin
				rt <= (10 * res * adc_temp * k) / (1000 * voltage - adc_temp * k);
				state <= state + 'd1;
				i <= 'd0;
			end
			1:
			begin
				if (i <= 71 && mem[i] > rt)
					i <= i + 1;
				else
					state <= state + 1;
			end
			2:
			begin
				if (i > 71)
					temp <= 'd300;
				else
				begin
					if (i == 0)
						temp <= -'d55;
					else
					begin
						temp <= ((5 * (i * (mem[i - 1] - mem[i]) + mem[i] - rt)) / (mem[i - 1] - mem[i])) - 55;
					end
				end
				state <= state + 1;
			end
			default:
				state <= 'd0;
		endcase
	end
end

//Значение сопротивления термистора в дециом  (дОм)
initial
begin
	state <= 'd0;
	i <= 'd0;
	rt <= 0;
	temp <= 'd0;
	mem[0]  <= 'd107232360;
	mem[1]  <= 'd73666890;
	mem[2]  <= 'd51327570;
	mem[3]  <= 'd36241650;
	mem[4]  <= 'd25913040;
	mem[5]  <= 'd18749130;
	mem[6]  <= 'd13718860;
	mem[7]  <= 'd10145450;
	mem[8]  <= 'd7578810;
	mem[9]  <= 'd5715900;
	mem[10] <= 'd4350260;
	mem[11] <= 'd3339640;
	mem[12] <= 'd2584970;
	mem[13] <= 'd2016590;
	mem[14] <= 'd1584990;
	mem[15] <= 'd1254680;
	mem[16] <= 'd1000000;
	mem[17] <= 'd802230;
	mem[18] <= 'd647590;
	mem[19] <= 'd525890;
	mem[20] <= 'd429510;
	mem[21] <= 'd352720;
	mem[22] <= 'd291190;
	mem[23] <= 'd241610;
	mem[24] <= 'd201440;
	mem[25] <= 'd168740;
	mem[26] <= 'd141980;
	mem[27] <= 'd119980;
	mem[28] <= 'd101810;
	mem[29] <= 'd86740;
	mem[30] <= 'd74190;
	mem[31] <= 'd63690;
	mem[32] <= 'd54870;
	mem[33] <= 'd47440;
	mem[34] <= 'd41150;
	mem[35] <= 'd35810;
	mem[36] <= 'd31260;
	mem[37] <= 'd27370;
	mem[38] <= 'd24040;
	mem[39] <= 'd21170;
	mem[40] <= 'd18690;
	mem[41] <= 'd16550;
	mem[42] <= 'd14690;
	mem[43] <= 'd13070;
	mem[44] <= 'd11660;
	mem[45] <= 'd10430;
	mem[46] <= 'd9345;
	mem[47] <= 'd8393;
	mem[48] <= 'd7554;
	mem[49] <= 'd6813;
	mem[50] <= 'd6158;
	mem[51] <= 'd5576;
	mem[52] <= 'd5059;
	mem[53] <= 'd4599;
	mem[54] <= 'd4188;
	mem[55] <= 'd3820;
	mem[56] <= 'd3491;
	mem[57] <= 'd3195;
	mem[58] <= 'd2929;
	mem[59] <= 'd2690;
	mem[60] <= 'd2473;
	mem[61] <= 'd2278;
	mem[62] <= 'd2101;
	mem[63] <= 'd1941;
	mem[64] <= 'd1795;
	mem[65] <= 'd1663;
	mem[66] <= 'd1542;
	mem[67] <= 'd1432;
	mem[68] <= 'd1332;
	mem[69] <= 'd1240;
	mem[70] <= 'd1155;
	mem[71] <= 'd1078;
	mem[72] <= 'd1000;
end

endmodule
