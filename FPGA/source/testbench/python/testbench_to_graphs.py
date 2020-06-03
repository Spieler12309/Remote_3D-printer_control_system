from prettytable import PrettyTable
import matplotlib.pyplot as plt
from tqdm import tqdm

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
			time.append(ll[0] / MAIN_FREQ / 100)
			steps.append(num)
			num = num + 1
			if (ll[4] != 0):
				speed.append(MAIN_FREQ / ll[4])
			else:
				speed.append(MAIN_FREQ)
	f.close()
	return time, steps, speed

nsaj_mm_title = ["N (мм)", "speed (мм/мин)", "acceleration (мм/мин^2)", "jerk (мм/мин)"]
nsaj_ms_title = ["N (мш)", "speed (мш/с)", "acceleration (мш/с^2)", "jerk (мш/с)"]
params_title = ["N", "nn", "t0", "tna", "delta"]
timing_title = ["t1", "t2", "t3", "tt"]

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

ax1 = plt.subplot(2, 1, 1)
ax2 = plt.subplot(2, 1, 2)
#ax3 = plt.subplot(2, 2, 3)
#ax4 = plt.subplot(2, 2, 4)

time, steps, speed = motor_file_to_graph("motor_x.txt")

yn  = steps
x   = time
yv  = speed
ax1.plot(x[:-1], yn[:-1])
ax2.plot(x[:-1], yv[:-1])
#ax3.scatter(x[:-1], ([1] * (len(x) - 1)))
#ax3.set_xlim(x[0], x[-1])

ax1.legend(["delta"])
ax1.set_title("1", loc='center', fontsize=12, fontweight=0, color='orange')
ax1.set_xlabel("Time")
ax1.set_ylabel("Microsteps")

ax2.legend(["delta"])
ax2.set_title("2", loc='center', fontsize=12, fontweight=0, color='orange')
ax2.set_xlabel("Time")
ax2.set_ylabel("Speed")

plt.show()