import matplotlib.pyplot as plt
import numpy as np
import math
import time
import tqdm
import os
import copy

#Зададим скорости для каждого двигателя (v0, vk, a, k)
speed = [[50, 150, 2000, 100],
         [50, 150, 2000, 100],
         [50, 150, 2000, 100],
         [50, 150, 2000, 100]]
k = 100 #микрошагов/мм
#Настройки принтера
f = 50000000 #Гц (имп/с)

#Зададим количество микрошагов для движения
N = [532, 323, 621, 400]

#Перевед скорость из мм/с в количество импульсов
def speed_to_timing(v0, vk, a, k, f):
    t0 = int(f / (v0 * k))
    tna = int(f / (vk * k))
    t = (f / (a * k)) * ((t0 - tna) / (t0 * tna))
    delta = int(((t0 ** 2) - (tna ** 2)) / (2 * t * f + tna - t0))
    if (delta == 0):
        delta = 1;
    if (delta < 0):
        delta = -delta
    nn = int((tna - t0) / delta)
    tna = t0 - delta * nn
    return nn, t0, tna, delta

def calc_all_parameters(N, speed):
    #N, nn, t0, tna, delta
    params = [[N[0], 0, 0, 0, 0],
              [N[1], 0, 0, 0, 0],
              [N[2], 0, 0, 0, 0],
              [N[3], 0, 0, 0, 0]]
    # Двигатель 1
    params[0][1], params[0][2], params[0][3], params[0][4] = speed_to_timing(speed[0][0], speed[0][1], speed[0][2], speed[0][3], f)
    # Двигатель 2
    params[1][1], params[1][2], params[1][3], params[1][4] = speed_to_timing(speed[1][0], speed[1][1], speed[1][2], speed[1][3], f)
    # Двигатель 3
    params[2][1], params[2][2], params[2][3], params[2][4] = speed_to_timing(speed[2][0], speed[2][1], speed[2][2], speed[2][3], f)
    # Двигатель 4
    params[3][1], params[3][2], params[3][3], params[3][4] = speed_to_timing(speed[3][0], speed[3][1], speed[3][2], speed[3][3], f)
    # параметры таймингов двигателей (nn, t0, tna, delta)
    # print("N = {}, nn = {}, t0 = {}, tna = {}, delta = {}".format(params[0][0], params[0][1], params[0][2],
    #                                                               params[0][3], params[0][4]))
    # print("N = {}, nn = {}, t0 = {}, tna = {}, delta = {}".format(params[1][0], params[1][1], params[1][2],
    #                                                               params[1][3], params[1][4]))
    # print("N = {}, nn = {}, t0 = {}, tna = {}, delta = {}".format(params[2][0], params[2][1], params[2][2],
    #                                                               params[2][3], params[2][4]))
    # print("N = {}, nn = {}, t0 = {}, tna = {}, delta = {}".format(params[3][0], params[3][1], params[3][2],
    #                                                               params[3][3], params[3][4]))
    return params

def calc_time(N, nn, t0, tna, delta):
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

def calc_all_times(params):
    t = [[0, 0, 0, 0],
         [0, 0, 0, 0],
         [0, 0, 0, 0],
         [0, 0, 0, 0]]

    t[0][0], t[0][1], t[0][2], t[0][3] = calc_time(params[0][0], params[0][1], params[0][2], params[0][3], params[0][4])
    t[1][0], t[1][1], t[1][2], t[1][3] = calc_time(params[1][0], params[1][1], params[1][2], params[1][3], params[1][4])
    t[2][0], t[2][1], t[2][2], t[2][3] = calc_time(params[2][0], params[2][1], params[2][2], params[2][3], params[2][4])
    t[3][0], t[3][1], t[3][2], t[3][3] = calc_time(params[3][0], params[3][1], params[3][2], params[3][3], params[3][4])

    # print("Timings:")
    # print("{:10d} {:10d} {:10d} {:10d}".format(t[0][0], t[0][1], t[0][2], t[0][3]))
    # print("{:10d} {:10d} {:10d} {:10d}".format(t[1][0], t[1][1], t[1][2], t[1][3]))
    # print("{:10d} {:10d} {:10d} {:10d}".format(t[2][0], t[2][1], t[2][2], t[2][3]))
    # print("{:10d} {:10d} {:10d} {:10d}".format(t[3][0], t[3][1], t[3][2], t[3][3]))

    return t


def calc_new_par(t, params):
    new_par = params
    # 0   1   2   3     4
    # N, nn, t0, tna, delta
    new_par = copy.deepcopy(params)
    #  0   1   2   3
    # t1, t2, t3, tt
    # t

    mxi = 0
    for i in range(4):
        if (t[i][3] > t[mxi][3]):
            mxi = i

    t1 = t[mxi][0]
    t2 = t[mxi][1]
    t3 = t[mxi][2]
    tt = t[mxi][3]
    nn = new_par[mxi][1]
    if (new_par[mxi][0] >= 2 * nn + 2):
        for i in range(4):
            if (True):
                if new_par[i][0] == 0:
                    new_par[i][1] = 0
                    new_par[i][3] = 0
                    new_par[i][2] = 0
                    new_par[i][4] = 0
                else:
                    if new_par[i][0] == 1:
                        new_par[i][1] = 1
                        new_par[i][3] = new_par[mxi][2]
                        new_par[i][2] = tt
                        new_par[i][4] = new_par[mxi][3]
                    else:
                        if new_par[i][0] == 2:
                            new_par[i][1] = 1
                            new_par[i][3] = new_par[mxi][2]
                            new_par[i][2] = int(tt / 2)
                            new_par[i][4] = new_par[i][1] - new_par[i][2]
                        else:
                            new_par[i][1] = int(new_par[mxi][1] * new_par[i][0] / new_par[mxi][0])
                            if (new_par[i][1] == 0):
                                new_par[i][1] = 1
                            nn1 = new_par[i][1]
                            #print(t2 / (new_par[i][0] - 2 * nn1))
                            if ((new_par[i][0] - 2 * nn1) == 0):
                                new_par[i][3] = new_par[mxi][3]
                            else:
                                new_par[i][3] = int(t2 / (new_par[i][0] - 2 * nn1))
                            tna1 = new_par[i][3]
                            new_par[i][2] = int((2 * t1 - tna1 * (nn1 - 1)) / (nn1 + 1))
                            t01 = new_par[i][2]
                            new_par[i][4] = int((new_par[i][3] - new_par[i][2]) / new_par[i][1])
    else:
        t1 = int(tt / 2)
        for i in range(4):
            if (True):
                if new_par[i][0] == 0:
                    new_par[i][1] = 0
                    new_par[i][3] = 0
                    new_par[i][2] = 0
                    new_par[i][4] = 0
                else:
                    if new_par[i][0] == 1:
                        new_par[i][1] = 1
                        new_par[i][3] = new_par[mxi][2]
                        new_par[i][2] = tt
                        new_par[i][4] = new_par[mxi][3]
                    else:
                        if new_par[i][0] == 2:
                            new_par[i][1] = 1
                            new_par[i][3] = new_par[mxi][2]
                            new_par[i][2] = int(tt / 2)
                            new_par[i][4] = new_par[i][1] - new_par[i][2]
                        else:
                            new_par[i][1] = int(new_par[i][0] / 2)
                            if (new_par[i][1] == 0):
                                new_par[i][1] = 1
                            nn1 = new_par[i][1]
                            # print(t2 / (new_par[i][0] - 2 * nn1))
                            new_par[i][3] = int(new_par[mxi][2] + new_par[mxi][4] * int(new_par[mxi][0] / 2))
                            tna1 = new_par[i][3]
                            new_par[i][2] = int((2 * t1 - tna1 * (nn1 - 1)) / (nn1 + 1))
                            t01 = new_par[i][2]
                            new_par[i][4] = int((new_par[i][3] - new_par[i][2]) / new_par[i][1])
    return new_par, mxi

# t = calc_all_times(N, params)
#
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

# def calc_new_par(t, params):
#     # 0   1   2   3     4
#     # N, nn, t0, tna, delta
#     new_par = copy.deepcopy(params)
#     #  0   1   2   3
#     # t1, t2, t3, tt
#     # t
#
#     mxi = 0
#     for i in range(4):
#         if (t[i][3] > t[mxi][3]):
#             mxi = i
#
#     for i in range(4):
#         #print("----------")
#         N = new_par[i][0]
#         nn = new_par[i][1]
#         t0 = new_par[i][2]
#         tna = new_par[i][3]
#         delta = new_par[i][4]
#         #print("N = {}, nn = {}, t0 = {}, tna = {}, delta = {}".format(N, nn, t0, tna, delta))
#         if (N > 2 * nn):
#             if N == 0:
#                 new_par[i][1] = 0
#                 new_par[i][2] = 0
#                 new_par[i][3] = 0
#                 new_par[i][4] = 0
#             else:
#                 if N == 1:
#                     new_par[i][1] = 1
#                     new_par[i][2] = t[mxi][3]
#                     new_par[i][3] = t[mxi][3] + 1
#                     new_par[i][4] = 1
#                 else:
#                     if N == 2:
#                         new_par[i][1] = 1
#                         new_par[i][2] = int(t[mxi][3] / 2)
#                         new_par[i][3] = int(t[mxi][3] / 2) + 1
#                         new_par[i][4] = 1
#                     else:
#                         new_par[i][3] = int(t[mxi][1] / (new_par[i][0] - 2 * new_par[i][1]))
#                         new_par[i][2] = int((-(new_par[i][1] - 1) * new_par[i][3] + 2 * t[mxi][0]) / (new_par[i][1] + 1))
#                         new_par[i][4] = int((-2 * t[mxi][0] + 2 * new_par[i][3] * new_par[i][1]) / (new_par[i][1] * (new_par[i][1] + 1)))
#                         new_par[i][2] = int(new_par[i][3] - new_par[i][1] * new_par[i][4])
#         else:
#             if N == 0:
#                 new_par[i][1] = 0
#                 new_par[i][2] = 0
#                 new_par[i][3] = 0
#                 new_par[i][4] = 0
#             else:
#                 if N == 1:
#                     new_par[i][1] = 1
#                     new_par[i][2] = t[mxi][3]
#                     new_par[i][3] = t[mxi][3] + 1
#                     new_par[i][4] = 1
#                 else:
#                     if N == 2:
#                         new_par[i][1] = 1
#                         new_par[i][2] = int(t[mxi][3] / 2)
#                         new_par[i][3] = int(t[mxi][3] / 2) + 1
#                         new_par[i][4] = 1
#                     else:
#                         new_par[i][1] = int(N / 2)
#                         nn = int(N / 2) + N % 2
#                         new_par[i][4] = - 1
#                         new_par[i][2] = int((t[mxi][3] / nn - new_par[i][4] * (nn - 1)) / 2)
#                         new_par[i][3] = int((t[mxi][3] / nn + new_par[i][4] * (nn - 1)) / 2)
#
#     return new_par, mxi

def acceleration_microsteps(param):
    t = 0
    x = []
    yn = []
    yv = []
    N = param[0]
    if N != 0:
        nn = param[1]
        t0 = param[2]
        tna = param[3]
        delta = param[4]
        dt = t0 - delta
        g = 0
        for i in (range(N)):
            if (i < (int(N / 2) + N % 2)):
                if (dt != tna):
                    if (abs(delta) < abs(tna - dt)):
                        g = delta
                    else:
                        g = tna - dt
                dt = max(dt + delta, tna)
            else:
                if (i >= max(N - nn, int(N / 2) + 1)):
                    dt = min(dt - g, t0)
                    g = delta
                else:
                    pass

            v = f / dt  # Микрошаг / сек
            yn.append(i + 1)
            yv.append(v)
            x.append(t)
            t += dt

        yn.append(N)
        yv.append(yv[-1])
        x.append(t)
    return x, yn, yv

def distance_to_line(dx, dy, x, y):
    a = dy / dx
    b = -1
    c = 0
    dist = abs(a * x + b * y + c) / math.sqrt(a ** 2 + b ** 2)
    return dist

def path_deviation(params):
    x0, _, _ = acceleration_microsteps(params[0])
    x1, _, _ = acceleration_microsteps(params[1])
    x2, _, _ = acceleration_microsteps(params[2])
    x3, _, _ = acceleration_microsteps(params[3])

    t = list(set(x0 + x1 + x2 + x3))
    t.sort()
    maxrelat = 0

    dn1 = 0
    dn2 = 0
    dn3 = 0
    dn4 = 0

    x = []
    y = []
    z = []
    e = []

    for i in (t):
        if (i in x0):
            dn1 += 1
        if (i in x1):
            dn2 += 1
        if (i in x2):
            dn3 += 1
        if (i in x3):
            dn4 += 1

        x.append((dn1 + dn2) / 2)
        y.append((dn1 - dn2) / 2)
        z.append(dn3)
        e.append(dn4)

        if params[0][0] != 0:
            x = list(2 * np.array(x) / (params[0][0] + params[1][0]))
        if params[1][0] != 0:
            y = list(2 * np.array(y) / (params[0][0] - params[1][0]))
        if params[2][0] != 0:
            z = list(np.array(z) / params[2][0])
        if params[3][0] != 0:
            e = list(np.array(e) / params[3][0])
        qq = []
        if params[0][0] != 0:
            qq.append(x[-1])
        if params[1][0] != 0:
            qq.append(y[-1])
        if params[2][0] != 0:
            qq.append(z[-1])
        if params[3][0] != 0:
            qq.append(e[-1])
        for q in range(len(qq)):
            for w in range(len(qq) - 1):
                maxrelat = max(maxrelat, abs(qq[q] - qq[w]))
    #print("maxrelat = {}".format(maxrelat))
    return x, y, z, e, t, maxrelat

def check_gcode(fileName):
    dmax = 0


    fll = open(fileName[6:] + ".txt", "w")
    fll.close

    for v0 in tqdm.tqdm(range(11, 80, 15)):
        for vk in tqdm.tqdm(range(v0 + 2, 120, 30)):
            for a in (range(350, 2000, 450)):
                fl = open(fileName, "r")
                f1 = fl.readlines()
                fl.close
                p = 0

                x = 0.0
                y = 0.0
                z = 0.0
                e = 0.0

                for l in (f1):
                    maxrelat = 0
                    b = l.split(" ")
                    #print(l)
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
                        speed = [[v0, vk, a, k],
                                 [v0, vk, a, k],
                                 [v0, vk, a, k],
                                 [v0, vk, a, k]]
                        params = calc_all_parameters(N, speed)
                        t_old = calc_all_times(params)
                        new_par, mxi = calc_new_par(t_old, params)
                        t = calc_all_times(new_par)

                        #_, _, _, _, _, mxrel = path_deviation(new_par)


                        #maxrelat = max(maxrelat, mxrel)

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
                        # if (d > 500000):
                        #     print("------------------ {:10d}".format(mxi))
                        #     print(l)
                        #     print("n1 = {}, n2 = {}, n3 = {}, n4 = {}.".format(n1, n2, n3, n4))
                        #     #print("t0 = {}, tna = {}, delta = {}, nn = {}".format(t0, tna, delta, nn))
                        #     p = p + 1
                        #     print("Old parameters:")
                        #     print("{:10d} {:10d} {:10d} {:10d} {:10d}".format(params[0][0], params[0][1], params[0][2], params[0][3], params[0][4]))
                        #     print("{:10d} {:10d} {:10d} {:10d} {:10d}".format(params[1][0], params[1][1], params[1][2], params[1][3], params[1][4]))
                        #     print("{:10d} {:10d} {:10d} {:10d} {:10d}".format(params[2][0], params[2][1], params[2][2], params[2][3], params[2][4]))
                        #     print("{:10d} {:10d} {:10d} {:10d} {:10d}".format(params[3][0], params[3][1], params[3][2], params[3][3], params[3][4]))
                        #     print("Old timings:")
                        #     print("{:10.0f} {:10.0f} {:10.0f} {:10.0f}".format(t_old[0][0], t_old[0][1], t_old[0][2], t_old[0][3]))
                        #     print("{:10.0f} {:10.0f} {:10.0f} {:10.0f}".format(t_old[1][0], t_old[1][1], t_old[1][2], t_old[1][3]))
                        #     print("{:10.0f} {:10.0f} {:10.0f} {:10.0f}".format(t_old[2][0], t_old[2][1], t_old[2][2], t_old[2][3]))
                        #     print("{:10.0f} {:10.0f} {:10.0f} {:10.0f}".format(t_old[3][0], t_old[3][1], t_old[3][2], t_old[3][3]))
                        #     print(str(p) + " New parameters:")
                        #     print("{:10d} {:10d} {:10d} {:10d} {:10d}".format(new_par[0][0], new_par[0][1], new_par[0][2], new_par[0][3], new_par[0][4]))
                        #     print("{:10d} {:10d} {:10d} {:10d} {:10d}".format(new_par[1][0], new_par[1][1], new_par[1][2], new_par[1][3], new_par[1][4]))
                        #     print("{:10d} {:10d} {:10d} {:10d} {:10d}".format(new_par[2][0], new_par[2][1], new_par[2][2], new_par[2][3], new_par[2][4]))
                        #     print("{:10d} {:10d} {:10d} {:10d} {:10d}".format(new_par[3][0], new_par[3][1], new_par[3][2], new_par[3][3], new_par[3][4]))
                        #     print("New timings:")
                        #     print("{:10.0f} {:10.0f} {:10.0f} {:10.0f}".format(t[0][0], t[0][1], t[0][2], t[0][3]))
                        #     print("{:10.0f} {:10.0f} {:10.0f} {:10.0f}".format(t[1][0], t[1][1], t[1][2], t[1][3]))
                        #     print("{:10.0f} {:10.0f} {:10.0f} {:10.0f}".format(t[2][0], t[2][1], t[2][2], t[2][3]))
                        #     print("{:10.0f} {:10.0f} {:10.0f} {:10.0f}".format(t[3][0], t[3][1], t[3][2], t[3][3]))
                        #     print("max deviations")
                        #     print("d1 = {}, d2 = {}, d3 = {}, d = {}.".format(d1, d2, d3, d))
                        #     for i in range(4):
                        #         for j in range(3):
                        #             if (new_par[i][j] < 0):
                        #                 print(
                        #                     "Minus error. n1 = {}, n2 = {}, n3 = {}, n4 = {}, v0 = {}, vk = {}, a = {}".format(
                        #                         n1, n2, n3, n4, v0, vk, a))

                        dmax = max(d, dmax)
                        #fll = open(fileName[6:] + ".txt", "a")
                        #fll.write("{:2s} {:2s} {:2s}: maxrelate = {:6.3f}.\n".format(b[0], b[1], b[2], maxrelat))
                        #fll.close
    print("Checking complete. dmax = {}. maxrelat = {}".format(dmax, maxrelat))
    fl = open("record_05.02.20.txt", "a")
    fl.write("{:50s}: dmax = {:15d}.\n".format(fileName, dmax))
    fl.close

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

# params = calc_all_parameters(N, speed)
# t = calc_all_times(params)
# new_par, mxi = calc_new_par(t, params)
# t = calc_all_times(new_par)

all_gcode = os.listdir("gcode")
fl = open("record_05.02.20.txt", "w")
fl.close
for i in all_gcode:
    print(i)
    time.sleep(0.2)
    check_gcode("gcode/" + i)


# x, y, z, e, t, d = path_deviation(new_par, dx, dy, dz, de)
# print(d)
# #plt.scatter(t, x)
#
# print(x[-1])
# print(y[-1])
# print(z[-1])
# print(e[-1])
#
# plt.plot(t, list(np.array(x) / x[-1] + 0))
# plt.plot(t, list(np.array(y) / y[-1] + 0.1))
# plt.plot(t, list(np.array(z) / z[-1] + 0.2))
# plt.plot(t, list(np.array(e) / e[-1] + 0.3))
# plt.show()

check_gcode("gcode/Front_Panel.gcode")
#check_all()