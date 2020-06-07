from prettytable import PrettyTable
import matplotlib.pyplot as plt
from tqdm import tqdm

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
	a = (temp + 55) // 5
	rt = mem[a] - (mem[a] - mem[a + 1]) * (temp - 5 * a + 55) // 5
	adc_temp = (1000 * voltage * rt) // (k * (rt + 10 * res))
	return adc_temp


MAIN_FREQ = 50000000

nsaj_mm_title = ["N (мм)", "speed (мм/мин)", "acceleration (мм/мин^2)", "jerk (мм/мин)"]
nsaj_ms_title = ["N (мш)", "speed (мш/с)", "acceleration (мш/с^2)", "jerk (мш/с)"]
params_title = ["N", "nn", "t0", "tna", "delta"]
timing_title = ["t1", "t2", "t3", "tt"]

def print_table(head, data, title = "", addNumber = True, setOneD = True):
	if (len(title) != 0):
		print(title)
	columns = len(head) + addNumber
	table = PrettyTable(["№"] + head) if addNumber else PrettyTable(head)
	if setOneD:
		td_data = sum(data, [])
	else:
		td_data = data[:]
	if addNumber:
		for i in range(len(td_data) // (columns - 1) + 1 * (len(td_data) % (columns - 1) != 0)):
			td_data.insert(i * (columns), i)
	while td_data:
		table.add_row(td_data[:columns])
		td_data = td_data[columns:]

	print(table)  # Печатаем таблицу

def choose_int(s):
	l = len(s)
	integ = []
	i = 0
	while i < l:
		s_int = ''
		a = s[i]
		while '0' <= a <= '9':
			s_int += a
			i += 1
			if i < l:
				a = s[i]
			else:
				break
		i += 1
		if s_int != '' and (i == l or s[i-1] == ','):
			integ.append(int(s_int))
	return integ

def motor_file_to_graph(filename):
	f = open(filename, 'r')
	f.readline()
	f.readline()
	num = 0
	time = []
	steps = []
	speed = []
	for line in tqdm(f):
		ll = choose_int(line)
		if (ll[2] == 1):
			time.append(ll[0] / MAIN_FREQ / 20)
			steps.append(num)
			num = num + 1
			if (ll[4] != 0):
				speed.append(MAIN_FREQ / ll[4])
			else:
				speed.append(MAIN_FREQ)
	f.close()
	return time, steps, speed

def printMain():
	f = open('main_data.txt', 'r')
	f.readline()
	f.readline()
	stt = []
	for i in range(5):
		l = f.readline()
		ll = choose_int(l)
		stt.append(ll)

	print_table(head=params_title,
	            data=stt,
	            title="Базовые параметры (speeds_to_timings)",
	            addNumber=True,
	            setOneD=True)
	f.readline()
	ct = []
	for i in range(5):
		l = f.readline()
		ll = choose_int(l)
		ct.append(ll)
	print_table(head=timing_title,
	            data=ct,
	            title="Время выполнения при базовых параметрах (calc_times)",
	            addNumber=True,
	            setOneD=True)
	f.readline()
	stt = []
	l = f.readline()
	ll = choose_int(l)
	stt.append(ll)
	ct = []
	l = f.readline()
	ll = choose_int(l)
	ct.append(ll)
	print_table(head=params_title,
			    data=stt,
			    title="Параметры для мотора с максимальным временем выполнения (find_max_timing)",
			    addNumber=False,
			    setOneD=True)
	print_table(head=timing_title,
	            data=ct,
	            title="Время выполнения для мотора с максимальным временем выполнения (find_max_timing)",
	            addNumber=False,
	            setOneD=True)

	f.readline()
	stt = []
	for i in range(5):
		l = f.readline()
		ll = choose_int(l)
		stt.append(ll)
	print_table(head=params_title,
			   data=stt,
			   title="Новые параметры (calc_all_new_paramters)",
		       addNumber=True,
		       setOneD=True)
	f.close()

def parse_motors():
	ax1 = plt.subplot(2, 1, 1)
	ax2 = plt.subplot(2, 1, 2)

	time, steps, speed = motor_file_to_graph("motor_x.txt")
	yn = []
	for i in steps:
		yn.append(i / steps[-1] * 100)
	x = time
	yv = speed

	ax1.plot(x[:-1], yn[:-1])
	ax2.plot(x[:-1], yv[:-1])

	time, steps, speed = motor_file_to_graph("motor_y.txt")
	yn = []
	for i in steps:
		yn.append(i / steps[-1] * 100)
	x = time
	yv = speed
	ax1.plot(x[:-1], yn[:-1])
	ax2.plot(x[:-1], yv[:-1])

	time, steps, speed = motor_file_to_graph("motor_z.txt")
	yn = []
	for i in steps:
		yn.append(i / steps[-1] * 100)
	x = time
	yv = speed
	ax1.plot(x[:-1], yn[:-1])
	ax2.plot(x[:-1], yv[:-1])

	time, steps, speed = motor_file_to_graph("motor_e0.txt")
	yn = []
	for i in steps:
		yn.append(i / steps[-1] * 100)
	x = time
	yv = speed
	ax1.plot(x[:-1], yn[:-1])
	ax2.plot(x[:-1], yv[:-1])

	time, steps, speed = motor_file_to_graph("motor_e1.txt")
	yn = []
	for i in steps:
		yn.append(i / steps[-1] * 100)
	x = time
	yv = speed
	ax1.plot(x[:-1], yn[:-1])
	ax2.plot(x[:-1], yv[:-1])


	ax1.legend(["X", "Y", "Z", "E0", "E1"])
	ax1.set_title("Путь", loc='center', fontsize=12, fontweight=0, color='orange')
	ax1.set_xlabel("Время (сек)")
	ax1.set_ylabel("% пути")

	ax2.legend(["X", "Y", "Z", "E0", "E1"])
	ax2.set_title("Скорость", loc='center', fontsize=12, fontweight=0, color='orange')
	ax2.set_xlabel("Время (сек)")
	ax2.set_ylabel("Скорость (микрошагов/сек)")

	plt.savefig("motors.png")
	plt.show()

def heaters_file_to_graph(filename):
	f = open(filename, 'r')
	time = []
	target = []
	current = []
	heat = []
	for line in tqdm(f):
		ll = choose_int(line)
		print(ll)

		if (len(heat) != 0 and ll[1] * 300 != heat[-1]):
			time.append(ll[0] / MAIN_FREQ / 20 - 1/MAIN_FREQ)
			heat.append(heat[-1])
			target.append(target[-1])
			current.append(adctemp_temp(ll[4]))

		time.append(ll[0] / MAIN_FREQ / 20)
		heat.append(ll[1] * 300)
		target.append(ll[2])
		current.append(adctemp_temp(ll[4]))

	f.close()

	ax1 = plt.subplot(1, 1, 1)

	ax1.plot(time, target)
	ax1.plot(time, current)
	ax1.plot(time, heat)

	ax1.legend(["Цель", "Текущая", "Нагрев"])
	ax1.set_title("Ожидание нагрева", loc='center', fontsize=14, fontweight=0, color='orange')
	ax1.set_xlabel("Время")
	ax1.set_ylabel("Температура")

	plt.savefig("heater_0.png")
	plt.show()

#printMain()
parse_motors()

# heaters_file_to_graph("heater_0.txt")
