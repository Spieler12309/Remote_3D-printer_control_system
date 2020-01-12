import matplotlib.pyplot as plt
import numpy as np
import math
import time

v0 = 50 #мм/с
vk = 100#мм/с
a = 2000  #мм/с^2
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
beta = 1
print("t0 = {}, tna = {}, beta = {}".format(t0, tna, beta))

def impulses_to_seconds(L):
    L1 = []
    for i in L:
        L1.append(i / f)
    return L1

def acceleration_01():
    t = 0
    x = []
    yn = []
    yv = []

    for i in range(N - 1):
        if (i < int(N / 2)):
            dt = tna + int((beta ** i) * ((t0 - tna) >> i))
        else:
            dt = tna + int((beta ** (N - i - 2)) * ((t0 - tna) >> (N - i - 2)))

        v = f / dt  # Микрошаг / сек
        yn.append(i + 1)
        yv.append(v)
        x.append(t)
        t += dt

    yn.append(N)
    yv.append(yv[-1])
    x.append(t)
    return [x, yn, yv]

def acceleration_02_const_a():
    t = 0
    x = []
    yn = []
    yv = []

    for i in range(N - 1):
        if (i < int(N / 2)):
            v = min(math.sqrt(v0m ** 2 + 2 * am * i), vkm)
        else:
            v = min(math.sqrt(v0m ** 2 + 2 * am * (N - i - 2)), vkm)
        dt = int(f / v)
        v = f / dt
        yn.append(i + 1)
        yv.append(v)
        x.append(t)
        t += dt

    yn.append(N)
    yv.append(yv[-1])
    x.append(t)
    return [x, yn, yv]

def acceleration_03_delta():
    t = (vk - v0) / a
    delta = ((tna ** 2) - (t0 ** 2)) / (2 * t * f + tna - t0)
    print(delta)
    nn = int((tna - t0) / delta) - 1
    print("n = " + str(int((tna - t0) / delta) - 1))

    t = 0
    dt = t0
    x = []
    yn = []
    yv = []

    k = 0;

    for i in range(N - 1):
        if (i < int(N / 2)):
            dt = max(dt + delta, tna)
            if (dt > tna):
                k += 1
        else:
            if (i > max(N - k - 2, N / 2)):
                dt = max(dt - delta, tna)

        v = f / dt  # Микрошаг / сек
        yn.append(i + 1)
        yv.append(v)
        x.append(t)
        t += dt

    yn.append(N)
    yv.append(yv[-1])
    x.append(t)
    return [x, yn, yv]



ax1 = plt.subplot(1, 2, 1)
ax2 = plt.subplot(1, 2, 2)
[x, yn, yv] = acceleration_01()
ax1.plot(impulses_to_seconds(x), yn)
ax2.plot(impulses_to_seconds(x), yv)
print(x)
print(yn)
print(yv)
print("--------------")


[x, yn, yv] = acceleration_02_const_a()
ax1.plot(impulses_to_seconds(x), yn)
ax2.plot(impulses_to_seconds(x), yv)
print(x)
print(yn)
print(yv)
print("--------------")

[x, yn, yv] = acceleration_03_delta()
ax1.plot(impulses_to_seconds(x), yn)
ax2.plot(impulses_to_seconds(x), yv)
print(x)
print(yn)
print(yv)

print("Full time: ", x[-1] / f)

ax1.legend(["1", "const_a", "delta"])
ax1.set_title("Num of microsteps from time", loc='center', fontsize=12, fontweight=0, color='orange')
ax1.set_xlabel("Time")
ax1.set_ylabel("Microsteps")

ax2.legend(["1", "const_a", "delta"])
ax2.set_title("Speed in microsteps per second from time", loc='center', fontsize=12, fontweight=0, color='orange')
ax2.set_xlabel("Time")
ax2.set_ylabel("Speed")





plt.show()