from prettytable import PrettyTable
import matplotlib.pyplot as plt
import numpy as np
import math
import time
import tqdm

nsaj_mm_title = ["N (мм)", "speed (мм/мин)", "acceleration (мм/мин^2)", "jerk (мм/мин)"]
nsaj_ms_title = ["N (мш)", "speed (мш/с)", "acceleration (мш/с^2)", "jerk (мш/с)"]
params_title = ["N", "nn", "t0", "tna", "delta"]
timing_title = ["t1", "t2", "t3", "tt"]
k = 100
MAIN_FREQ = 1000000

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

def impulses_to_seconds(L):
    L1 = []
    for i in L:
        L1.append(i / MAIN_FREQ)
    return L1

def mm_to_microsteps(num, speed, acceleration, jerk, k):
	return int(num * k), speed * k // 60, acceleration * k // 3600, jerk * k // 60

def mms_to_microsteps(nums, speeds, accelerations, jerks, k):
	nums_new            = []
	speeds_new          = []
	accelerations_new   = []
	jerks_new           = []
	for i in range(len(nums)):
		n, s, a, j = mm_to_microsteps(nums[i], speeds[i], accelerations[i], jerks[i], k)
		nums_new.append(n)
		speeds_new.append(s)
		accelerations_new.append(a)
		jerks_new.append(j)
	return nums_new, speeds_new, accelerations_new, jerks_new

def speed_to_timing(num, speed, acceleration, jerk):
	params = [0, 0, 0, 0, 0]
	params[0] = abs(num)
	params[2] = MAIN_FREQ if (jerk == 0) else MAIN_FREQ // jerk
	params[3] = MAIN_FREQ // speed
	t = MAIN_FREQ * (speed - jerk) // acceleration
	params[4] = 0 if (params[2] == params[3]) \
					else ((params[2] * params[2]) - (params[3] * params[3])) // (2 * t)
	params[4] = 1 if (params[4] == 0 and params[2] != params[3]) else params[4]
	params[4] = (params[2] - params[3]) if (params[4] > params[2] - params[3]) else params[4]
	params[1] = 0 if (params[4] == 0) else (params[2] - params[3]) // params[4]
	params[3] = params[2] - params[4] * params[1]
	return params

def speeds_to_timings(nums, speeds, accelerations, jerks):
	all_params = []
	for i in range(len(nums)):
		all_params.append(speed_to_timing(nums[i], speeds[i], accelerations[i], jerks[i]))
	return all_params

def calc_time(params):
	timings = [0, 0, 0, 0]
	N = params[0]
	nn = params[1]
	t0 = params[2]
	tna = params[3]
	delta = params[4]

	a = nn if (N > (nn << 1)) else (N >> 1)
	t1 = t0 * a - (a * (delta * (a - 1)) >> 1)
	if (N > (nn << 1)):
		t2 = tna * (N - (nn << 1))
	else:
		t2 = (t0 - delta * a) if (N % 2 == 1) else 0
	t3 = t1
	tt = t1 + t2 + t3

	timings[0] = t1
	timings[1] = t2
	timings[2] = t3
	timings[3] = tt
	return timings

def calc_times(all_params):
	all_timings = []
	for i in range(len(all_params)):
		all_timings.append(calc_time(all_params[i]))
	return all_timings

def find_max_timing(all_params, all_timings):
	if (all_timings[0][3] > all_timings[1][3] and all_timings[0][3] > all_timings[2][3] and all_timings[0][3] > all_timings[3][3] and all_timings[0][3] > all_timings[4][3]):
		max_params = all_params[0]
		max_timing = all_timings[0]
	else:
		if (all_timings[1][3] > all_timings[0][3] and all_timings[1][3] > all_timings[2][3] and all_timings[1][3] > all_timings[3][3] and all_timings[1][3] > all_timings[4][3]):
			max_params = all_params[1]
			max_timing = all_timings[1]
		else:
			if (all_timings[2][3] > all_timings[0][3] and all_timings[2][3] > all_timings[1][3] and all_timings[2][3] > all_timings[3][3] and all_timings[2][3] > all_timings[4][3]):
				max_params = all_params[2]
				max_timing = all_timings[2]
			else:
				if (all_timings[3][3] > all_timings[0][3] and all_timings[3][3] > all_timings[1][3] and all_timings[3][3] > all_timings[2][3] and all_timings[3][3] > all_timings[4][3]):
					max_params = all_params[3]
					max_timing = all_timings[3]
				else:
					max_params = all_params[4]
					max_timing = all_timings[4]
	return max_params, max_timing

def calc_new_paramters(params, max_params, max_timing):
	new_par = [0, 0, 0, 0, 0]
	new_par[0] = params[0]
	new_par[1] = params[1]
	new_par[2] = params[2]
	new_par[3] = params[3]
	new_par[4] = params[4]

	# 0   1   2   3     4
	# N, nn, t0, tna, delta

	#  0   1   2   3
	# t1, t2, t3, tt

	t1 = max_timing[0]
	t2 = max_timing[1]
	t3 = max_timing[2]
	tt = max_timing[3]
	nn = max_params[1]
	if (max_params[0] >= ((nn << 1) + 2)):
		if (new_par[0] == 0):
			new_par[1] = 0
			new_par[3] = 0
			new_par[2] = 0
			new_par[4] = 0
		else:
			if (new_par[0] == 1):
				new_par[1] = 1
				new_par[3] = max_params[2]
				new_par[2] = tt
				new_par[4] = max_params[3]
			else:
				if (new_par[0] == 2):
					new_par[1] = 1
					new_par[3] = max_params[2]
					new_par[2] = tt >> 1
					new_par[4] = new_par[2] - new_par[3]
				else:
					new_par[1] = max_params[1] * new_par[0] // max_params[0]

					if ((new_par[0] - (new_par[1] << 1)) == 0):
						new_par[3] = max_params[3]
					else:
						new_par[3] = t2 // (new_par[0] - (new_par[1] << 1))

					if (new_par[1] != 0):
						new_par[2] = ((t1 << 1) - new_par[3] * (new_par[1] - 1)) // (new_par[1] + 1)
					else:
						new_par[2] = new_par[3]

					if (new_par[1] == 0):
						new_par[4] = new_par[2] - new_par[3]
					else:
						new_par[4] = (new_par[2] - new_par[3]) // new_par[1]

					if (new_par[4] == 0 and new_par[2] != new_par[3]):
						new_par[4] = 1

					if (new_par[4] == 1):
						new_par[1] = new_par[2] - new_par[3]

					if (new_par[1] == 0 and new_par[4] != 0):
						new_par[1] = 1
	else:
		t1 = tt << 1
		if (new_par[0] == 0):
			new_par[1] = 0
			new_par[2] = 0
			new_par[3] = 0
			new_par[4] = 0
		else:
			if (new_par[0] == 1):
				new_par[1] = 1
				new_par[3] = max_params[2]
				new_par[2] = tt
				new_par[4] = max_params[3]
			else:
				if (new_par[0] == 2):
					new_par[1] = 1
					new_par[3] = max_params[2]
					new_par[2] = tt << 1
					new_par[4] = new_par[2] - new_par[3]
				else:
					new_par[1] = new_par[0] >> 1
					if (new_par[1] == 0):
						new_par[1] = 1

					new_par[3] = max_params[2] + max_params[4] * (max_params[0] >> 1)
					new_par[2] = ((t1 << 1) - new_par[3] * (new_par[1] - 1)) // (new_par[1] + 1)
					new_par[4] = (new_par[2] - new_par[3]) // new_par[1]
	return new_par

def calc_all_new_paramters(all_params, max_params, max_timing):
	all_new_params = []
	for i in range(len(nums)):
		all_new_params.append(calc_new_paramters(all_params[i], max_params, max_timing))
	return all_new_params

def jas_control(params):
	steps = [0]
	time = [0]

	N = params[0]
	nn = params[1]
	t0 = params[2]
	tna = params[3]
	delta = params[4]

	wait_step = t0
	step_num = 0
	g = 0
	t = 0
	speed = [MAIN_FREQ // wait_step]

	while (step_num < N):
		step_num = step_num + 1

		if (step_num < ((N >> 1) + (N % 2))):
			if (wait_step != tna):
				g = delta if delta < (wait_step - tna) else wait_step - tna
			wait_step = tna if tna > (wait_step - delta) else wait_step - delta
		else:
			if (step_num >= (N - nn if ((N - nn) > ((N >> 1) + 1)) else (N >> 1) + 1)):
				wait_step = t0 if t0 < (wait_step + g) else wait_step + g
				g = delta
		t = t + wait_step
		steps.append(step_num)
		time.append(t)
		speed.append(MAIN_FREQ // wait_step)

	return [steps, time, speed]

def jas_controls(all_params):
	all_steps = []
	for i in range(len(all_params)):
		all_steps.append(jas_control(all_params[i]))
	return all_steps

def jerk_acc_speed(nums, speeds, accelerations, jerks, printInfo = True):
	if printInfo:
		nsaj_mm = []
		for i in range(len(nums)):
			nsaj_mm.append(nums[i])
			nsaj_mm.append(speeds[i])
			nsaj_mm.append(accelerations[i])
			nsaj_mm.append(jerks[i])
		print_table(head=nsaj_mm_title,
		            data=nsaj_mm,
		            title="Первоначальные данные",
		            addNumber=True,
		            setOneD=False)

	nums_ms, speeds_ms, accelerations_ms, jerks_ms = mms_to_microsteps(nums, speeds, accelerations, jerks, k)
	if printInfo:
		nsaj_ms = []
		for i in range(len(nums)):
			nsaj_ms.append(nums_ms[i])
			nsaj_ms.append(speeds_ms[i])
			nsaj_ms.append(accelerations_ms[i])
			nsaj_ms.append(jerks_ms[i])
		print_table(head=nsaj_ms_title,
		            data=nsaj_ms,
		            title="Первоначальные данные в микрошагах/секундах (mms_to_microsteps)",
		            addNumber=True,
		            setOneD=False)

	all_params = speeds_to_timings(nums_ms, speeds_ms, accelerations_ms, jerks_ms)
	if printInfo:
		print_table(head=params_title,
		            data=all_params,
		            title="Базовые параметры (speeds_to_timings)",
		            addNumber=True,
		            setOneD=True)

	all_timings = calc_times(all_params)
	if printInfo:
		print_table(head=timing_title,
		            data=all_timings,
		            title="Время выполнения при базовых параметрах (calc_times)",
		            addNumber=True,
		            setOneD=True)

	max_params, max_timing = find_max_timing(all_params, all_timings)
	if printInfo:
		print_table(head=params_title,
		            data=max_params,
		            title="Параметры для мотора с максимальным временем выполнения (find_max_timing)",
		            addNumber=False,
		            setOneD=False)
		print_table(head=timing_title,
		            data=max_timing,
		            title="Время выполнения для мотора с максимальным временем выполнения (find_max_timing)",
		            addNumber=False,
		            setOneD=False)

	all_new_params = calc_all_new_paramters(all_params, max_params, max_timing)
	if printInfo:
		print_table(head=params_title,
		            data=all_new_params,
		            title="Новые параметры (calc_all_new_paramters)",
	                addNumber=True,
	                setOneD=True)

	all_steps = jas_controls(all_new_params)

	ax1 = plt.subplot(2, 1, 1)
	ax2 = plt.subplot(2, 1, 2)
	#ax3 = plt.subplot(2, 2, 3)
	#ax4 = plt.subplot(2, 2, 4)

	#print(all_steps[3][0])
	#print(all_steps[3][1])
	#print(all_steps[3][2])
	yn  = all_steps[0][0]
	x   = all_steps[0][1]
	yv  = all_steps[0][2]
	ax1.plot(impulses_to_seconds(x[:-1]), yn[:-1])
	ax2.plot(impulses_to_seconds(x[:-1]), yv[:-1])
	#ax3.scatter(impulses_to_seconds(x[:-1]), ([1] * (len(x) - 1)))
	#ax3.set_xlim(impulses_to_seconds(x)[0], impulses_to_seconds(x)[-1])

	ax1.legend(["delta"])
	ax1.set_title("Num of microsteps from time", loc='center', fontsize=12, fontweight=0, color='orange')
	ax1.set_xlabel("Time")
	ax1.set_ylabel("Microsteps")

	ax2.legend(["delta"])
	ax2.set_title("Speed in microsteps per second from time", loc='center', fontsize=12, fontweight=0, color='orange')
	ax2.set_xlabel("Time")
	ax2.set_ylabel("Speed")

	plt.show()


nums            = [     815.15,      984.66,      786.78,      776.57,      435.79] #мм
speeds          = [    6000,     5000,     4500,     10000,    10000] #мм/мин
accelerations   = [1200000, 1100000, 1350000, 1000000, 1000000] #мм/мин^2
jerks           = [    1000,      100,     1000,       1000,     1000] #мм/мин

jerk_acc_speed(nums, speeds, accelerations, jerks, printInfo=True)
