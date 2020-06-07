mem = [0]*73

mem[0]  = 107232360
mem[1]  = 73666890
mem[2]  = 51327570
mem[3]  = 36241650
mem[4]  = 25913040
mem[5]  = 18749130
mem[6]  = 13718860
mem[7]  = 10145450
mem[8]  = 7578810
mem[9]  = 5715900
mem[10] = 4350260
mem[11] = 3339640
mem[12] = 2584970
mem[13] = 2016590
mem[14] = 1584990
mem[15] = 1254680
mem[16] = 1000000
mem[17] = 802230
mem[18] = 647590
mem[19] = 525890
mem[20] = 429510
mem[21] = 352720
mem[22] = 291190
mem[23] = 241610
mem[24] = 201440
mem[25] = 168740
mem[26] = 141980
mem[27] = 119980
mem[28] = 101810
mem[29] = 86740
mem[30] = 74190
mem[31] = 63690
mem[32] = 54870
mem[33] = 47440
mem[34] = 41150
mem[35] = 35810
mem[36] = 31260
mem[37] = 27370
mem[38] = 24040
mem[39] = 21170
mem[40] = 18690
mem[41] = 16550
mem[42] = 14690
mem[43] = 13070
mem[44] = 11660
mem[45] = 10430
mem[46] = 9345
mem[47] = 8393
mem[48] = 7554
mem[49] = 6813
mem[50] = 6158
mem[51] = 5576
mem[52] = 5059
mem[53] = 4599
mem[54] = 4188
mem[55] = 3820
mem[56] = 3491
mem[57] = 3195
mem[58] = 2929
mem[59] = 2690
mem[60] = 2473
mem[61] = 2278
mem[62] = 2101
mem[63] = 1941
mem[64] = 1795
mem[65] = 1663
mem[66] = 1542
mem[67] = 1432
mem[68] = 1332
mem[69] = 1240
mem[70] = 1155
mem[71] = 1078
mem[72] = 1000

res = 100000
voltage = 33
k = 10

def adctemp_temp(adc_temp):
	rt = (10 * res * adc_temp * k) // (1000 * voltage - adc_temp * k)

	i = 0
	while (i <= 71 and mem[i] > rt):
		i = i + 1

	if (i > 71):
		temp = 300
	else:
		if (i == 0):
			temp = -55
		else:
			temp = ((5 * (i * (mem[i - 1] - mem[i]) + mem[i] - rt)) // (mem[i - 1] - mem[i])) - 55
	return temp

def temp_adctemp(temp):
	a = int((temp + 55) // 5)
	rt = mem[a] - (mem[a] - mem[a + 1]) * (temp - 5 * a + 55) / 5
	adc_temp = (1000 * voltage * rt) // (k * (rt + 10 * res))
	return adc_temp


tp = [20, 50, 100, 150, 180, 190, 200, 203, 200, 190, 205, 200, 190, 200, 180, 150, 100]
results = []
for y in range(len(tp) - 1):
	for u in range(10):
		kl = tp[y] + u * (tp[y+1] - tp[y]) / 10
		results.append(temp_adctemp(kl))

print("reg [11:0] temps [0:{}];".format(len(results)-1))
print("\ninitial\nbegin")
for i in range(len(results)):
	print("	temps[{}]  = {};".format(i, int(results[i])))
print("end")