import matplotlib.pyplot as plt
import numpy as np
import math
import time
import tqdm

v0 = 50000 #мм/с
vk = 100000#мм/с
a = 200000  #мм/с^2
f = 50000000 #Гц (имп/с)
k = 100 #микрошагов/мм

print("v0 = {}, vk = {}, a = {}".format(v0, vk, a))

N = 200 #Количество микрошагов

#Переведем скорость из мм/с в микрошаг/с
v0m = v0 * k
vkm = vk * k
am = a * k
print("v0m = {}, vkm = {}, am = {}".format(v0m, vkm, am))

t0 = int(f / v0m)
tna = int(f / vkm)
t = (vk - v0) / a #(f / (a * k)) * ((t0 - tna) / (t0 * tna))
delta = int(((t0 ** 2) - (tna ** 2)) / (2 * t * f - tna - t0))
if (delta == 0):
   delta = 1;
if (delta < 0):
    delta = -delta
t0 = 150
tna = 23
delta = 7
print("t0 = {}, tna = {}, delta = {}".format(t0, tna, delta))

nn = int((t0 - tna) / delta)
tna = t0 - delta * nn
print("t0 = {}, tna = {}, delta = {}".format(t0, tna, delta))
print("N = {}, nn = {}".format(N, nn))

def impulses_to_seconds(L):
    L1 = []
    for i in L:
        L1.append(i / f)
    return L1

def calc_time(N):
    if (N > 2 * nn):
        t1 = t0 * nn - int((nn * (delta * (nn - 1)) / 2))
        t2 = tna * (N - 2 * nn)
        t3 = t1
        tt = t1 + t2 + t3
    else:
        a = int(N / 2)
        t1 = t0 * a - int((a * (delta * (a - 1)) / 2))
        t2 = (t0 - delta * a) if ((N % 2) == 1) else 0
        t3 = t1
        tt = t1 + t2 + t3
    return t1, t2, t3, tt

# у нас есть t11, t21, t31. И есть N1, N2, N3. d21 = N2 / N1.

# Testing with different num of steps
def test_acc():
    for i in tqdm.tqdm(range(2, 1000)):
        [x, yn, yv] = acceleration_03_delta(i)
        b = yv[-2:0:-1]
        b.append(yv[0])
        f = (yv[:-1] == b)
        if (f == False):
            print("Error in generating of steps timing. nums = {}".format(i))
            print("yv = {}".format(yv[:-1]))
            print("a = {}".format(b))
            break

        t1, t2, t3, tt = calc_time(i)

        f = x[-1] == tt
        if (f == False):
            print("Error in calculating time of all steps. nums = {}".format(i))
            # print("yv = {}".format(yv[:-1]))
            # print("a = {}".format(b))
            print("generatted time = {}".format(x[-1]))
            print("calculating time = {}".format(tt))
            break

def acceleration_03_delta(N):
    #print("nn = " + str(nn))
    t = 0
    dt = t0 + delta
    x = []
    yn = []
    yv = []
    g = 0
    for i in (range(N)):
        if (i < (int(N / 2) + N % 2)):
            #print("acc {} {} {} {}".format(i, dt + delta, tna, k))
            if (dt != tna):
                if (delta < dt - tna):
                    g = delta
                else:
                    g = dt - tna
            dt = max(dt - delta, tna)
            #print(g)
        else:
            if (i >= max(N - nn, int(N / 2) + 1)): #косяк
                #print("dec {} {} {} {}".format(i, dt - delta, tna, k))
                dt = min(dt + g, t0)
                g = delta
            else:
                pass#print("const {} {} {} {}".format(i, dt, tna, k))

        v = f / dt  # Микрошаг / сек
        yn.append(i + 1)
        yv.append(v)
        x.append(t)
        t += dt

    yn.append(N)
    yv.append(yv[-1])
    x.append(t)
    return [x, yn, yv]

test_acc()

ax1 = plt.subplot(2, 2, 1)
ax2 = plt.subplot(2, 2, 2)
ax3 = plt.subplot(2, 2, 3)
ax4 = plt.subplot(2, 2, 4)

[x, yn, yv] = acceleration_03_delta(N)
ax1.plot(impulses_to_seconds(x[:-1]), yn[:-1])
ax2.plot(impulses_to_seconds(x[:-1]), yv[:-1])
ax3.scatter(impulses_to_seconds(x[:-1]), ([1]*(len(x) - 1)))
ax3.set_xlim(impulses_to_seconds(x)[0], impulses_to_seconds(x)[-1])
print(x)
# x1 = []
# for i in range(len(x) - 1):
#     x1.append(x[i + 1] - x[i])
# print(sum(x1[:x1.index(tna)]))
# print(x1)
# x1.reverse()
# print(sum(x1[:x1.index(tna)]))
# print(x1)

print(yn)
print(yv[:-1])
a = yv[-2:0:-1]
a.append(yv[0])
print(a)

print("Full time: ", x[-1])
t1, t2, t3, tt = calc_time(N);
print("Full time(formula): {} + {} + {} = {}".format(t1, t2, t3, tt))

ax1.legend(["delta"])
ax1.set_title("Num of microsteps from time", loc='center', fontsize=12, fontweight=0, color='orange')
ax1.set_xlabel("Time")
ax1.set_ylabel("Microsteps")

ax2.legend(["delta"])
ax2.set_title("Speed in microsteps per second from time", loc='center', fontsize=12, fontweight=0, color='orange')
ax2.set_xlabel("Time")
ax2.set_ylabel("Speed")

plt.show()