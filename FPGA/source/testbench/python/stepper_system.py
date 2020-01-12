import matplotlib.pyplot as plt
import numpy as np
import math
import time
import tqdm
import os

v0 = 50 #мм/с
vk = 150#мм/с
a = 2000  #мм/с^2
f = 50000000 #Гц (имп/с)
k = 100 #микрошагов/мм

#print("v0 = {}, vk = {}, a = {}".format(v0, vk, a))

#Переведем скорость из мм/с в микрошаг/с
v0m = v0 * k
vkm = vk * k
am = a * k
#print("v0m = {}, vkm = {}, am = {}".format(v0m, vkm, am))

N = [532, 323, 511, 400]

t0 = int(f / v0m)
tna = int(f / vkm)
t = (f / (a * k)) * ((t0 - tna) / (t0 * tna))
delta = int(((tna ** 2) - (t0 ** 2)) / (2 * t * f + tna - t0))
if (delta == 0):
   delta = -1;
if (delta > 0):
    delta = -delta

#print("t0 = {}, tna = {}, delta = {}".format(t0, tna, delta))

nn = int((tna - t0) / delta) + (((tna - t0) % delta) != 0) * 1
#print("nn = {}".format(nn))

def calc_time(N, nn, tna, t0, delta):
    if (N > 2 * nn):
        t1 = t0 * nn + int((nn * (delta * (nn - 1)) / 2))
        t2 = tna * (N - 2 * nn)
        t3 = t1
        tt = t1 + t2 + t3
    else:
        a = int(N / 2)
        t1 = t0 * a + int((a * (delta * (a - 1)) / 2))
        t2 = (t0 + delta * a) if ((N % 2) == 1) else 0
        t3 = t1
        tt = t1 + t2 + t3
    return t1, t2, t3, tt

def calc_new_par(t, N, mxi, nn, t0, tna, delta):
    new_par = [[0, 0, 0, 0],
               [0, 0, 0, 0],
               [0, 0, 0, 0],
               [0, 0, 0, 0]]

    new_par[mxi] = [nn, t0, tna, delta]
    t1 = t[mxi][0]
    t2 = t[mxi][1]
    t3 = t[mxi][2]
    tt = t[mxi][3]
    if (N[mxi] >= 2 * nn + 2):
        for i in range(4):
            if (True):
                if N[i] == 0:
                    new_par[i][0] = 0
                    new_par[i][2] = 0
                    new_par[i][1] = 0
                    new_par[i][3] = 0
                else:
                    if N[i] == 1:
                        new_par[i][0] = 1
                        new_par[i][2] = new_par[mxi][2]
                        new_par[i][1] = tt
                        new_par[i][3] = new_par[mxi][3]
                    else:
                        if N[i] == 2:
                            new_par[i][0] = 1
                            new_par[i][2] = new_par[mxi][2]
                            new_par[i][1] = int(tt / 2)
                            new_par[i][3] = new_par[i][1] - new_par[i][2]
                        else:
                            new_par[i][0] = int(new_par[mxi][0] * N[i] / N[mxi])
                            if (new_par[i][0] == 0):
                                new_par[i][0] = 1
                            nn1 = new_par[i][0]
                            #print(t2 / (N[i] - 2 * nn1))
                            if ((N[i] - 2 * nn1) == 0):
                                new_par[i][2] = new_par[mxi][2]
                            else:
                                new_par[i][2] = int(t2 / (N[i] - 2 * nn1))
                            tna1 = new_par[i][2]
                            new_par[i][1] = int((2 * t1 - tna1 * (nn1 - 1)) / (nn1 + 1))
                            t01 = new_par[i][1]
                            new_par[i][3] = int((new_par[i][2] - new_par[i][1]) / new_par[i][0])
    else:
        t1 = int(tt / 2)
        for i in range(4):
            if (True):
                if N[i] == 0:
                    new_par[i][0] = 0
                    new_par[i][2] = 0
                    new_par[i][1] = 0
                    new_par[i][3] = 0
                else:
                    if N[i] == 1:
                        new_par[i][0] = 1
                        new_par[i][2] = new_par[mxi][2]
                        new_par[i][1] = tt
                        new_par[i][3] = new_par[mxi][3]
                    else:
                        if N[i] == 2:
                            new_par[i][0] = 1
                            new_par[i][2] = new_par[mxi][2]
                            new_par[i][1] = int(tt / 2)
                            new_par[i][3] = new_par[i][1] - new_par[i][2]
                        else:
                            new_par[i][0] = int(N[i] / 2)
                            if (new_par[i][0] == 0):
                                new_par[i][0] = 1
                            nn1 = new_par[i][0]
                            # print(t2 / (N[i] - 2 * nn1))
                            new_par[i][2] = int(new_par[mxi][1] + new_par[mxi][3] * int(N[mxi] / 2))
                            tna1 = new_par[i][2]
                            new_par[i][1] = int((2 * t1 - tna1 * (nn1 - 1)) / (nn1 + 1))
                            t01 = new_par[i][1]
                            new_par[i][3] = int((new_par[i][2] - new_par[i][1]) / new_par[i][0])
    return new_par

# t = [[0, 0, 0, 0],
#      [0, 0, 0, 0],
#      [0, 0, 0, 0],
#      [0, 0, 0, 0]]
#
# t[0][0], t[0][1], t[0][2], t[0][3] = calc_time(N[0], nn, tna, t0, delta)
# t[1][0], t[1][1], t[1][2], t[1][3] = calc_time(N[1], nn, tna, t0, delta)
# t[2][0], t[2][1], t[2][2], t[2][3] = calc_time(N[2], nn, tna, t0, delta)
# t[3][0], t[3][1], t[3][2], t[3][3] = calc_time(N[3], nn, tna, t0, delta)
#
# print("Timings:")
# print("{:10d} {:10d} {:10d} {:10d}".format(t[0][0], t[0][1], t[0][2], t[0][3]))
# print("{:10d} {:10d} {:10d} {:10d}".format(t[1][0], t[1][1], t[1][2], t[1][3]))
# print("{:10d} {:10d} {:10d} {:10d}".format(t[2][0], t[2][1], t[2][2], t[2][3]))
# print("{:10d} {:10d} {:10d} {:10d}".format(t[3][0], t[3][1], t[3][2], t[3][3]))
#
# mx = max(t[0][3], t[1][3], t[2][3], t[3][3])
# mxi = 0
# if (mx == t[0][3]):
#     mxi = 0
# else:
#     if (mx == t[1][3]):
#         mxi = 1
#     else:
#         if (mx == t[2][3]):
#             mxi = 2
#         else:
#             mxi = 3
#
# new_par = calc_new_par(t, mxi, nn, t0, tna, delta)
# print("New parameters:")
# print("{:5d} {:5d} {:5d} {:5d}".format(new_par[0][0], new_par[0][1], new_par[0][2], new_par[0][3]))
# print("{:5d} {:5d} {:5d} {:5d}".format(new_par[1][0], new_par[1][1], new_par[1][2], new_par[1][3]))
# print("{:5d} {:5d} {:5d} {:5d}".format(new_par[2][0], new_par[2][1], new_par[2][2], new_par[2][3]))
# print("{:5d} {:5d} {:5d} {:5d}".format(new_par[3][0], new_par[3][1], new_par[3][2], new_par[3][3]))
#
# t[0][0], t[0][1], t[0][2], t[0][3] = calc_time(N[0], new_par[0][0], new_par[0][2], new_par[0][1], new_par[0][3])
# t[1][0], t[1][1], t[1][2], t[1][3] = calc_time(N[1], new_par[1][0], new_par[1][2], new_par[1][1], new_par[1][3])
# t[2][0], t[2][1], t[2][2], t[2][3] = calc_time(N[2], new_par[2][0], new_par[2][2], new_par[2][1], new_par[2][3])
# t[3][0], t[3][1], t[3][2], t[3][3] = calc_time(N[3], new_par[3][0], new_par[3][2], new_par[3][1], new_par[3][3])
#
# for i in range(4):
#     for j in range(4):
#         t[i][j] = t[i][j] / f
#
# print("New timings:")
# print("{:5f} {:5f} {:5f} {:5f}".format(t[0][0], t[0][1], t[0][2], t[0][3]))
# print("{:5f} {:5f} {:5f} {:5f}".format(t[1][0], t[1][1], t[1][2], t[1][3]))
# print("{:5f} {:5f} {:5f} {:5f}".format(t[2][0], t[2][1], t[2][2], t[2][3]))
# print("{:5f} {:5f} {:5f} {:5f}".format(t[3][0], t[3][1], t[3][2], t[3][3]))

def check_gcode(fileName):
    for v0 in tqdm.tqdm(range(11, 80, 11)):
        for vk in tqdm.tqdm(range(v0 + 2, 120, 17)):
            for a in (range(350, 2000, 250)):
                fl = open(fileName, "r")
                f1 = fl.readlines()
                fl.close
                p = 0

                x = 0.0
                y = 0.0
                z = 0.0
                e = 0.0

                for l in (f1):
                    b = l.split(" ")
                    if ((b[0] == "G0") or (b[0] == "G1")):
                        dx = 0
                        dy = 0
                        dz = 0
                        de = 0
                        for i in b:
                            if i[0] == 'X':
                                xn = float(i[1:])
                                dx = (xn - x)
                                x = xn
                            if i[0] == 'Y':
                                yn = float(i[1:])
                                dy = (yn - y)
                                y = yn
                            if i[0] == 'Z':
                                zn = float(i[1:])
                                dz = (zn - z)
                                z = zn
                            if i[0] == 'E':
                                en = float(i[1:])
                                de = (en - e)
                                e = en
                        n1 = int(abs(dx + dy) * k)
                        n2 = int(abs(dx - dy) * k)
                        n3 = int(abs(dz) * k)
                        n4 = int(abs(de) * k)

                        N = [n1, n2, n3, n4]
                        v0m = v0 * k
                        vkm = vk * k
                        am = a * k
                        t0 = int(f / v0m)
                        tna = int(f / vkm)
                        t = (f / (a * k)) * ((t0 - tna) / (t0 * tna))
                        delta = int(((tna ** 2) - (t0 ** 2)) / (2 * t * f + tna - t0))
                        if (delta == 0):
                            delta = -1;
                        if (delta > 0):
                            delta = -delta
                        nn = int((tna - t0) / delta)

                        t = [[0, 0, 0, 0],
                             [0, 0, 0, 0],
                             [0, 0, 0, 0],
                             [0, 0, 0, 0]]
                        t[0][0], t[0][1], t[0][2], t[0][3] = calc_time(N[0], nn, tna, t0, delta)
                        t[1][0], t[1][1], t[1][2], t[1][3] = calc_time(N[1], nn, tna, t0, delta)
                        t[2][0], t[2][1], t[2][2], t[2][3] = calc_time(N[2], nn, tna, t0, delta)
                        t[3][0], t[3][1], t[3][2], t[3][3] = calc_time(N[3], nn, tna, t0, delta)
                        mx = max(t[0][3], t[1][3], t[2][3], t[3][3])
                        mxi = 0
                        if (mx == t[0][3]):
                            mxi = 0
                        else:
                            if (mx == t[1][3]):
                                mxi = 1
                            else:
                                if (mx == t[2][3]):
                                    mxi = 2
                                else:
                                    mxi = 3

                        new_par = calc_new_par(t, N, mxi, nn, t0, tna, delta)

                        t[0][0], t[0][1], t[0][2], t[0][3] = calc_time(N[0], new_par[0][0], new_par[0][2],
                                                                       new_par[0][1], new_par[0][3])
                        t[1][0], t[1][1], t[1][2], t[1][3] = calc_time(N[1], new_par[1][0], new_par[1][2],
                                                                       new_par[1][1], new_par[1][3])
                        t[2][0], t[2][1], t[2][2], t[2][3] = calc_time(N[2], new_par[2][0], new_par[2][2],
                                                                       new_par[2][1], new_par[2][3])
                        t[3][0], t[3][1], t[3][2], t[3][3] = calc_time(N[3], new_par[3][0], new_par[3][2],
                                                                       new_par[3][1], new_par[3][3])
                        d1 = 0
                        d2 = 0
                        d3 = 0
                        d = 0
                        for i in range(3):
                            for j in range(i + 1, 4):
                                if (t[i][0] != 0 and t[j][0] != 0):
                                    if (d1 < abs(t[i][0] - t[j][0])):
                                        d1 = abs(t[i][0] - t[j][0])
                        for i in range(3):
                            for j in range(i + 1, 4):
                                if (t[i][1] != 0 and t[j][1] != 0):
                                    if (d2 < abs(t[i][1] - t[j][1])):
                                        d2 = abs(t[i][1] - t[j][1])
                        for i in range(3):
                            for j in range(i + 1, 4):
                                if (t[i][2] != 0 and t[j][2] != 0):
                                    if (d3 < abs(t[i][2] - t[j][2])):
                                        d3 = abs(t[i][2] - t[j][2])
                        for i in range(3):
                            for j in range(i + 1, 4):
                                if (t[i][3] != 0 and t[j][3] != 0):
                                    if (d < abs(t[i][3] - t[j][3])):
                                        d = abs(t[i][3] - t[j][3])
                        if (d > 500000):
                            print("------------------")
                            print(l)
                            print("n1 = {}, n2 = {}, n3 = {}, n4 = {}.".format(n1, n2, n3, n4))
                            print("t0 = {}, tna = {}, delta = {}, nn = {}".format(t0, tna, delta, nn))
                            p = p + 1
                            print(str(p) + " New parameters:")
                            print("{:10d} {:10d} {:10d} {:10d}".format(new_par[0][0], new_par[0][1], new_par[0][2], new_par[0][3]))
                            print("{:10d} {:10d} {:10d} {:10d}".format(new_par[1][0], new_par[1][1], new_par[1][2], new_par[1][3]))
                            print("{:10d} {:10d} {:10d} {:10d}".format(new_par[2][0], new_par[2][1], new_par[2][2], new_par[2][3]))
                            print("{:10d} {:10d} {:10d} {:10d}".format(new_par[3][0], new_par[3][1], new_par[3][2], new_par[3][3]))
                            print("New timings:")
                            print("{:10.0f} {:10.0f} {:10.0f} {:10.0f}".format(t[0][0], t[0][1], t[0][2], t[0][3]))
                            print("{:10.0f} {:10.0f} {:10.0f} {:10.0f}".format(t[1][0], t[1][1], t[1][2], t[1][3]))
                            print("{:10.0f} {:10.0f} {:10.0f} {:10.0f}".format(t[2][0], t[2][1], t[2][2], t[2][3]))
                            print("{:10.0f} {:10.0f} {:10.0f} {:10.0f}".format(t[3][0], t[3][1], t[3][2], t[3][3]))
                            print("max deviations")
                            print("d1 = {}, d2 = {}, d3 = {}, d = {}.".format(d1, d2, d3, d))
                            for i in range(4):
                                for j in range(3):
                                    if (new_par[i][j] < 0):
                                        print(
                                            "Minus error. n1 = {}, n2 = {}, n3 = {}, n4 = {}, v0 = {}, vk = {}, a = {}".format(
                                                n1, n2, n3, n4, v0, vk, a))
    print("Checking complete")

def check_all():
    d1 = 0
    d2 = 0
    d3 = 0
    d = 0
    p = 0
    maxd = 0
    for n1 in tqdm.tqdm(range(1700, 1701, 79)):
        for n2 in tqdm.tqdm(range(1700, 1701, 79)):
            for n3 in (range(1700, 1701, 79)):
                for n4 in (range(0, 1, 151)):
                    for v0 in (range(11, 80, 11)):
                        for vk in (range(v0 + 2, 120, 17)):
                            for a in (range(350, 2000, 250)):
                                N = [n1, n2, n3, n4]
                                v0m = v0 * k
                                vkm = vk * k
                                am = a * k
                                t0 = int(f / v0m)
                                tna = int(f / vkm)
                                t = (f / (a * k)) * ((t0 - tna) / (t0 * tna))
                                delta = int(((tna ** 2) - (t0 ** 2)) / (2 * t * f + tna - t0))
                                if (delta == 0):
                                    delta = -1;
                                if (delta > 0):
                                    delta = -delta
                                nn = int((tna - t0) / delta)

                                t = [[0, 0, 0, 0],
                                     [0, 0, 0, 0],
                                     [0, 0, 0, 0],
                                     [0, 0, 0, 0]]
                                t[0][0], t[0][1], t[0][2], t[0][3] = calc_time(N[0], nn, tna, t0, delta)
                                t[1][0], t[1][1], t[1][2], t[1][3] = calc_time(N[1], nn, tna, t0, delta)
                                t[2][0], t[2][1], t[2][2], t[2][3] = calc_time(N[2], nn, tna, t0, delta)
                                t[3][0], t[3][1], t[3][2], t[3][3] = calc_time(N[3], nn, tna, t0, delta)
                                mx = max(t[0][3], t[1][3], t[2][3], t[3][3])
                                mxi = 0
                                if (mx == t[0][3]):
                                    mxi = 0
                                else:
                                    if (mx == t[1][3]):
                                        mxi = 1
                                    else:
                                        if (mx == t[2][3]):
                                            mxi = 2
                                        else:
                                            mxi = 3

                                new_par = calc_new_par(t, N, mxi, nn, t0, tna, delta)

                                for i in range(4):
                                    for j in range(3):
                                        if (new_par[i][j] < 0):
                                            print(
                                                "Minus error. n1 = {}, n2 = {}, n3 = {}, n4 = {}, v0 = {}, vk = {}, a = {}".format(
                                                    n1, n2, n3, n4, v0, vk, a))

                                t[0][0], t[0][1], t[0][2], t[0][3] = calc_time(N[0], new_par[0][0], new_par[0][2],
                                                                               new_par[0][1], new_par[0][3])
                                t[1][0], t[1][1], t[1][2], t[1][3] = calc_time(N[1], new_par[1][0], new_par[1][2],
                                                                               new_par[1][1], new_par[1][3])
                                t[2][0], t[2][1], t[2][2], t[2][3] = calc_time(N[2], new_par[2][0], new_par[2][2],
                                                                               new_par[2][1], new_par[2][3])
                                t[3][0], t[3][1], t[3][2], t[3][3] = calc_time(N[3], new_par[3][0], new_par[3][2],
                                                                               new_par[3][1], new_par[3][3])
                                d1 = 0
                                d2 = 0
                                d3 = 0
                                d = 0
                                for i in range(3):
                                    for j in range(i + 1, 4):
                                        if (t[i][0] != 0 and t[j][0] != 0):
                                            if (d1 < abs(t[i][0] - t[j][0])):
                                                d1 = abs(t[i][0] - t[j][0])
                                for i in range(3):
                                    for j in range(i + 1, 4):
                                        if (t[i][1] != 0 and t[j][1] != 0):
                                            if (d2 < abs(t[i][1] - t[j][1])):
                                                d2 = abs(t[i][1] - t[j][1])
                                for i in range(3):
                                    for j in range(i + 1, 4):
                                        if (t[i][2] != 0 and t[j][2] != 0):
                                            if (d3 < abs(t[i][2] - t[j][2])):
                                                d3 = abs(t[i][2] - t[j][2])
                                for i in range(3):
                                    for j in range(i + 1, 4):
                                        if (t[i][3] != 0 and t[j][3] != 0):
                                            if (d < abs(t[i][3] - t[j][3])):
                                                d = abs(t[i][3] - t[j][3])
                                if d > maxd:
                                    maxd = d
                                if (d > 100000):
                                    print("------------------")
                                    print("n1 = {}, n2 = {}, n3 = {}, n4 = {}.".format(n1, n2, n3, n4))
                                    print("t0 = {}, tna = {}, delta = {}, nn = {}".format(t0, tna, delta, nn))
                                    p = p + 1
                                    print(str(p) + " New parameters:")
                                    print("{:10d} {:10d} {:10d} {:10d}".format(new_par[0][0], new_par[0][1],
                                                                               new_par[0][2],
                                                                               new_par[0][3]))
                                    print("{:10d} {:10d} {:10d} {:10d}".format(new_par[1][0], new_par[1][1],
                                                                               new_par[1][2],
                                                                               new_par[1][3]))
                                    print("{:10d} {:10d} {:10d} {:10d}".format(new_par[2][0], new_par[2][1],
                                                                               new_par[2][2],
                                                                               new_par[2][3]))
                                    print("{:10d} {:10d} {:10d} {:10d}".format(new_par[3][0], new_par[3][1],
                                                                               new_par[3][2],
                                                                               new_par[3][3]))
                                    print("New timings:")
                                    print("{:10.0f} {:10.0f} {:10.0f} {:10.0f}".format(t[0][0], t[0][1], t[0][2],
                                                                                       t[0][3]))
                                    print("{:10.0f} {:10.0f} {:10.0f} {:10.0f}".format(t[1][0], t[1][1], t[1][2],
                                                                                       t[1][3]))
                                    print("{:10.0f} {:10.0f} {:10.0f} {:10.0f}".format(t[2][0], t[2][1], t[2][2],
                                                                                       t[2][3]))
                                    print("{:10.0f} {:10.0f} {:10.0f} {:10.0f}".format(t[3][0], t[3][1], t[3][2],
                                                                                       t[3][3]))
                                    print("max deviations")
                                    print("d1 = {}, d2 = {}, d3 = {}, d = {}.".format(d1, d2, d3, d))
                                    for i in range(4):
                                        for j in range(3):
                                            if (new_par[i][j] < 0):
                                                print(
                                                    "Minus error. n1 = {}, n2 = {}, n3 = {}, n4 = {}, v0 = {}, vk = {}, a = {}".format(
                                                        n1, n2, n3, n4, v0, vk, a))

all_gcode = os.listdir("gcode")
for i in all_gcode:
    print(i)
    time.sleep(0.2)
    check_gcode("gcode/" + i)

#check_gcode("gcode/Front_Panel.gcode")
#check_all()