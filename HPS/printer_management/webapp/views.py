from django.shortcuts import render
from django.http import HttpResponse
from django.http import JsonResponse
from django.contrib.staticfiles.views import serve
from django.core import serializers
from .forms import UploadFileForm
from django.views.decorators.csrf import csrf_exempt
from .models import command
import json
import requests
import os
import time

# python3 printer_management/manage.py runserver 192.168.1.:8000
input_pipe_name = "/home/root/printer_management/inputPipe.msg"
output_pipe_name = "/home/root/printer_management/outputPipe.msg"

validcommands = ["G0", "G1", "G4", "G28", "G90", "G91", "G92", "M6", "M17", "M119", "M105", "M114", 'M501',
                 "M18", "M82", "M83", "M104", "M106", "M107", "M109", "M140", "M190"]

d = {
    'lastcommand': 'not started',
    'number':0,
    'atall':0,
    's':'test',
    'bed':0,
    'ex':0
}

def read_pipe():
    while not(os.path.exists(input_pipe_name)):
        time.sleep(0.1)
    print('openning pipe')
    pipe_descr = open(input_pipe_name, 'r')
    print('file is ready to be read')
    time.sleep(0.1)
    mes = pipe_descr.read()
    pipe_descr.close()
    print('Got: ' + mes)
    if os.path.exists(input_pipe_name):
        test = open(input_pipe_name, 'w')
        test.close()
        print('file , status: ', os.path.exists(input_pipe_name))
    return mes

def write_pipe(s):
    # if os.path.exists(input_pipe_name):
    #     test = open(input_pipe_name, 'w')
    #     test.close()
    #     print('file , status: ', os.path.exists(input_pipe_name))
    os.system('sudo rm '+input_pipe_name)
    pipe_descr = open(output_pipe_name, 'w')
    print('trying to write '+ s+ ' into '+output_pipe_name)
    pipe_descr.write(s)
    pipe_descr.close()
    print("written value: " + s)


def index(request):
    if request.method == 'GET':
        print("Index")
    data = {}
    datatest = []
    n = 0
    for file in os.listdir("/home/root/printer_management/webapp/static/gcodefiles"):
        if file.endswith(".gcode"):
            print(file)
            name = 'file'+str(n+1)
            data[name] = file
            n+=1
            data['quantity'] = n
            datatest.append(file)
    print(data)
    for key in data.items():
        print(key)
    return render(request, "home.html", {'filenames': datatest})


def output(request):
    # data=requests.get()
    # print(data.text)
    data = 888
    return render(request, 'home.html', {'data': data})

@csrf_exempt
def add_command(request):
    if request.method == 'POST':
        print('add_command: ', request)
        gcommand = request.POST.get('test')
        response_data = {}
        response_data['gcommand'] = gcommand
        # здесь проверим команду и если она норм то добавим в словарь для отображения и отправим в канал
        if (len(gcommand) > 0 and gcommand.split()[0].upper() in validcommands):
            write_pipe(gcommand)
            response_data['response'] = read_pipe()
            print('add_command resp_data: ',response_data, " === gcommand: ", gcommand)
            fs = gcommand.split()[0]
            s = response_data['response'].split()
            if fs == 'G1' or fs == 'G0' or fs == 'G28':
                response_data['x'] = s[1]
                response_data['y'] = s[2]
                response_data['z'] = s[3]
                response_data['e'] = s[4]
                response_data['xmin'] = s[6]
                response_data['xmax'] = s[7]
                response_data['ymin'] = s[8]
                response_data['ymax'] = s[9]
                response_data['zmin'] = s[10]
                response_data['zmax'] = s[11]
                response_data['barend'] = s[12]
            if fs == 'M114'  or fs == 'G92':
                response_data['x'] = s[0]
                response_data['y'] = s[1]
                response_data['z'] = s[2]
                response_data['e'] = s[3]
            if fs == 'M119':
                response_data['xmin'] = s[0]
                response_data['xmax'] = s[1]
                response_data['ymin'] = s[2]
                response_data['ymax'] = s[3]
                response_data['zmin'] = s[4]
                response_data['zmax'] = s[5]
                response_data['barend'] = s[6]
        else:
            response_data['response'] = 'invalid command'
        return HttpResponse(json.dumps(response_data), content_type="application/json")
    return JsonResponse({"not valid command": ""}, status=400)

@csrf_exempt
def buttons_processing(request):
    if request.method == 'POST':
        print(request)
        response_data = {}
        if(request.POST.get('type')=='home_all'):
            home_speed_x = request.POST.get('home_speed_x')
            home_speed_y = request.POST.get('home_speed_y')
            home_speed_z = request.POST.get('home_speed_z')
            response_data['command'] = 'G28 X0 Y0 Z0 FX' + home_speed_x + ' FY' + home_speed_y + ' FZ' + home_speed_z
        if (request.POST.get('type') == 'home_x'):
            home_speed_y = request.POST.get('home_speed_y')
            home_speed_x = request.POST.get('home_speed_x')
            response_data['command'] = 'G28 X0 FX' + home_speed_x + ' FY' + home_speed_y
        if (request.POST.get('type') == 'home_y'):
            home_speed_x = request.POST.get('home_speed_x')
            home_speed_y = request.POST.get('home_speed_y')
            response_data['command'] = 'G28 Y0 FX' + home_speed_x + ' FY' + home_speed_y
        if (request.POST.get('type') == 'home_z'):
            home_speed_z = request.POST.get('home_speed_z')
            response_data['command'] = 'G28 Z0 FZ' + home_speed_z
        if (request.POST.get('type') == 'bed_heating' or
            request.POST.get('type') == 'ex_heating' or
            request.POST.get('type') == 'x_left' or
            request.POST.get('type') == 'x_right' or
            request.POST.get('type') == 'y_up' or
            request.POST.get('type') == 'y_down' or
            request.POST.get('type') == 'z_up' or
            request.POST.get('type') == 'z_down' or
            request.POST.get('type') == 'e_up' or
            request.POST.get('type') == 'e_down' or
            request.POST.get('type') == 'reset'):
            response_data['command'] = request.POST.get('command')
            write_pipe('G91')
            read_pipe()
            print(response_data['command'])
        write_pipe(response_data['command'])
        print('buttons_processing: ','finished writing')
        res = read_pipe()
        print('buttons_processing: ','read_pipe(): '+ res)
        print('buttons_processing: ','finished reading')
        fs = response_data['command'].split()[0].upper()
        s = res.split()
        print('buttons_processing: ', s, fs)
        if fs == 'G1' or fs == 'G0' or fs == 'G28':
            response_data['x'] = s[1]
            response_data['y'] = s[2]
            response_data['z'] = s[3]
            response_data['e'] = s[4]
            response_data['xmin'] = s[6]
            response_data['xmax'] = s[7]
            response_data['ymin'] = s[8]
            response_data['ymax'] = s[9]
            response_data['zmin'] = s[10]
            response_data['zmax'] = s[11]
            response_data['barend'] = s[12]
        if fs == 'M114'  or fs == 'G92':
            response_data['x'] = s[0]
            response_data['y'] = s[1]
            response_data['z'] = s[2]
            response_data['e'] = s[3]
        if fs == 'M119':
            response_data['xmin'] = s[0]
            response_data['xmax'] = s[1]
            response_data['ymin'] = s[2]
            response_data['ymax'] = s[3]
            response_data['zmin'] = s[4]
            response_data['zmax'] = s[5]
            response_data['barend'] = s[6]
        return HttpResponse(json.dumps(response_data), content_type="application/json")
    return JsonResponse({"not valid command": ""}, status=400)

@csrf_exempt
def upload_file(request):
    if request.method == 'POST':
        form = UploadFileForm(request.POST, request.FILES)
        handle_uploaded_file(request.FILES['file'])
        print('file has been uploaded')
    else:
        form = UploadFileForm()
    return HttpResponse()

def handle_uploaded_file(f):
    print('trying to create a file: http://localhost:8000/static/gcodefiles/'+str(f))
    with open('/home/root/printer_management/webapp/static/gcodefiles/'+str(f), 'wb+') as destination:
        for chunk in f.chunks():
            destination.write(chunk)

@csrf_exempt
def updateHTML(request):
    response_data = {}
    print('updateHTML:',1, request, request.POST.get('type'), request.GET.get('type'))
    if request.method == 'GET' and request.GET.get('type') == 'init':
        write_pipe('M114')
        d['s'] = read_pipe()
        s = d['s'].split()
        d['x'] = s[0]
        d['y'] = s[1]
        d['z'] = s[2]
        d['e'] = s[3]
        response_data['x'] = d['x']
        response_data['y'] = d['y']
        response_data['z'] = d['z']
        response_data['e'] = d['e']
        write_pipe('M119')
        d['s'] = read_pipe()
        s = d['s'].split()
        d['xmin'] = s[0]
        d['xmax'] = s[1]
        d['ymin'] = s[2]
        d['ymax'] = s[3]
        d['zmin'] = s[4]
        d['zmax'] = s[5]
        d['barend'] = s[6]
        response_data['xmin'] = d['xmin']
        response_data['xmax'] = d['xmax']
        response_data['ymin'] = d['ymin']
        response_data['ymax'] = d['ymax']
        response_data['zmin'] = d['zmin']
        response_data['zmax'] = d['zmax']
        response_data['barend'] = d['barend']
        return HttpResponse(json.dumps(response_data), content_type="application/json")
    if request.method == 'POST' and request.POST.get('type') == 'waiting':
        write_pipe('M105 S2')
        response_data['bed'] = read_pipe()
        write_pipe('M105 S0')
        response_data['ex'] = read_pipe()
        return HttpResponse(json.dumps(response_data), content_type="application/json")
    if request.method == 'POST' and request.POST.get('type') == 'printing':
        print('updating printing data')
        response_data['bed'] = d['bed']
        response_data['ex'] = d['ex']
        response_data['lastcommand'] = d['lastcommand']
        response_data['number'] = d['number']
        response_data['atall'] = d['atall']
        print('updateHTML:',3,response_data)
        #M119, M114, command num
        fs = d['lastcommand'].split()[0].upper()
        # s = d['s'].split()
        print('updateHTML:',3.5, fs)
        if fs == 'G1' or fs == 'G0' or fs == 'G28':
            response_data['x'] = d['x']
            response_data['y'] = d['y']
            response_data['z'] = d['z']
            response_data['e'] = d['e']
            response_data['xmin'] = d['xmin']
            response_data['xmax'] = d['xmax']
            response_data['ymin'] = d['ymin']
            response_data['ymax'] = d['ymax']
            response_data['zmin'] = d['zmin']
            response_data['zmax'] = d['zmax']
            response_data['barend'] = d['barend']
        if fs == 'M114'  or fs == 'G92':
            response_data['x'] = d['x']
            response_data['y'] = d['y']
            response_data['z'] = d['z']
            response_data['e'] = d['e']
        if fs == 'M119':
            response_data['xmin'] = d['xmin']
            response_data['xmax'] = d['xmax']
            response_data['ymin'] = d['ymin']
            response_data['ymax'] = d['ymax']
            response_data['zmin'] = d['zmin']
            response_data['zmax'] = d['zmax']
            response_data['barend'] = d['barend']
        print('updateHTML:',4, response_data, d,'\n\n')
        # write pipe с командами для обновления а данные отправить джейсоном в нтмл или МНОГО WRITE PIPEов?
        return HttpResponse(json.dumps(response_data), content_type="application/json")
    return JsonResponse({"not valid printing data": ""}, status=400)


@csrf_exempt
def setprint(request):
    if request.method == 'POST':
        print('setprint:',request)
        response_data = {}
        response_data['status'] = 'unset'
        d['status'] = 'unset'
        print(request.POST.keys(),request.POST.get('type'), request.POST.get('filename'))
        if (request.POST.get('type') == 'start'):
            print('setprint:','s ',request.POST.get('startline'))
            startline = int(request.POST.get('startline'))
            if startline != 0:
                startline += 1
            filename = request.POST.get('filename')[1:-1]
            curline = 1
            # data = {}
            atall = 0
            # print('curline: ', curline, ', startline: ', startline)
            print(filename, " printing started, startline: ", startline)
            with open('/home/root/printer_management/webapp/static/gcodefiles/' + filename, 'r') as source:
                for line in source:
                    atall += 1
                d['atall'] = atall
                print('setprint:','atall = ',atall)
            with open('/home/root/printer_management/webapp/static/gcodefiles/' + filename, 'r') as source:
                for line in source:
                    if(d['status'] == 'unset'):
                        if (curline > startline or startline == 0):
                            print('setprint: line = ',line.strip())
                            write_pipe(line.strip())
                            d['s']=read_pipe()
                            print('setprint: readpipe() = ',d['s'])
                            d['lastcommand'] = line.strip()
                            d['number'] = curline
                            print('setprint: curline = ', d)
                            fs = d['lastcommand'].split()[0].upper()
                            s = d['s'].split()
                            if fs == 'G1' or fs == 'G0' or fs == 'G28':
                                d['x'] = s[1]
                                d['y'] = s[2]
                                d['z'] = s[3]
                                d['e'] = s[4]
                                d['xmin'] = s[6]
                                d['xmax'] = s[7]
                                d['ymin'] = s[8]
                                d['ymax'] = s[9]
                                d['zmin'] = s[10]
                                d['zmax'] = s[11]
                                d['barend'] = s[12]
                            if fs == 'M114' or fs == 'G92':
                                d['x'] = s[0]
                                d['y'] = s[1]
                                d['z'] = s[2]
                                d['e'] = s[3]
                            if fs == 'M119':
                                d['xmin'] = s[0]
                                d['xmax'] = s[1]
                                d['ymin'] = s[2]
                                d['ymax'] = s[3]
                                d['zmin'] = s[4]
                                d['zmax'] = s[5]
                                d['barend'] = s[6]

                            time.sleep(1)
                            # updateHTML(data, True)
                        curline += 1
                    else:
                        break
                if (d['status'] == 'unset'):
                    response_data['status'] = 'end'
        if (request.POST.get('type') == 'pause'):
            filename = request.POST.get('filename')
            lastcommand = request.POST.get('lastcommand')
            print('setprint: ',filename, " printing paused, last command: ", lastcommand)
            response_data['lastcommand'] = lastcommand
            response_data['status'] = 'printing paused'
            d['status'] = 'printing paused'
        if (request.POST.get('type') == 'stop'):
            filename = request.POST.get('filename')
            lastcommand = request.POST.get('lastcommand')
            print('setprint: ',filename, " printing stopped, last command: ", lastcommand)
            response_data['status'] = 'printing finished'
            d['status'] = 'printing finished'
        return HttpResponse(json.dumps(response_data), content_type="application/json")
    return JsonResponse({"not valid printing data": ""}, status=400)

@csrf_exempt
def apply_settings(request):
    if request.method == 'GET':
        print("in apply set GET")
        print(json.dumps(request.GET, indent=2))
        response = {
            'speed': {
                "X": float(request.GET.get('speed[X]')),
                "Y": float(request.GET.get('speed[Y]')),
                "Z": float(request.GET.get('speed[Z]')),
                "E0": float(request.GET.get('speed[E0]')),
            },
            'max_speed': {
                'X': float(request.GET.get('max_speed[X]')),
                'Y': float(request.GET.get('max_speed[Y]')),
                'Z': float(request.GET.get('max_speed[Z]')),
                'E0': float(request.GET.get('max_speed[E0]')),
            },
            "pid": {
                "P": float(request.GET.get('pid[P]')),
                "I": float(request.GET.get('pid[I]')),
                "D": float(request.GET.get('pid[D]'))
            },
            "delta": float(request.GET.get('delta')),
            "home_speed_fast": {
                'X': float(request.GET.get('home_speed_fast[X]')),
                'Y': float(request.GET.get('home_speed_fast[Y]')),
                'Z': float(request.GET.get('home_speed_fast[Z]')),
            },
            "home_speed_slow": {
                'X': float(request.GET.get('home_speed_slow[X]')),
                'Y': float(request.GET.get('home_speed_slow[Y]')),
                'Z': float(request.GET.get('home_speed_slow[Z]')),
            },
            "acceleration": {
                'X': float(request.GET.get('acceleration[X]')),
                'Y': float(request.GET.get('acceleration[Y]')),
                'Z': float(request.GET.get('acceleration[Z]')),
                'E0': float(request.GET.get('acceleration[E0]')),
            },
            "jerk": {
                'X': float(request.GET.get('jerk[X]')),
                'Y': float(request.GET.get('jerk[Y]')),
                'Z': float(request.GET.get('jerk[Z]')),
                'E0': float(request.GET.get('jerk[E0]')),
            },
            "max_temps": {
                "E0": float(request.GET.get('max_temps[E0]')),
                "BED": float(request.GET.get('max_temps[BED]'))
            },
            "steps_per_unit": {
                'X': float(request.GET.get('steps_per_unit[X]')),
                'Y': float(request.GET.get('steps_per_unit[Y]')),
                'Z': float(request.GET.get('steps_per_unit[Z]')),
                'E0': float(request.GET.get('steps_per_unit[E0]')),
            },
            "max_size": {
                "X": float(request.GET.get('max_size[X]')),
                "Y": float(request.GET.get('max_size[Y]')),
                "Z": float(request.GET.get('max_size[Z]'))
            },
            "num_extruders": int(request.GET.get('num_extruders')),
            "set_extruder": int(request.GET.get('set_extruder')),
            "num_motors": int(request.GET.get('num_motors')),
            "motors_inverting": {
                "X": request.GET.get('motors_inverting[X]'),
                "Y": request.GET.get('motors_inverting[Y]'),
                "Z": request.GET.get('motors_inverting[Z]'),
                "E0": request.GET.get('motors_inverting[E0]')
            },
            "num_endstops": float(request.GET.get('num_endstops')),
            "endstops_inverting": {
                "X_MIN": request.GET.get('endstops_inverting[X_MIN]'),
                "Y_MIN": request.GET.get('endstops_inverting[Y_MIN]'),
                "Z_MIN": request.GET.get('endstops_inverting[Z_MIN]'),
                "X_MAX": request.GET.get('endstops_inverting[X_MAX]'),
                "Y_MAX": request.GET.get('endstops_inverting[Y_MAX]'),
                "Z_MAX": request.GET.get('endstops_inverting[Z_MAX]')
            },
            "barend_inverting": request.GET.get('barend_inverting')
        }
        # print(json.dumps(response))
        new_set_file = open("/home/root/printer_management/webapp/static/js/setting.json", "w")
        json.dump(response, new_set_file, indent=2, sort_keys=False)
        new_set_file.close()
        write_pipe('M501')
        read_pipe()
        # time.sleep(3)
        return HttpResponse(json.dumps(response), content_type="application/json")
    return JsonResponse({"not valid command": ""}, status=400)