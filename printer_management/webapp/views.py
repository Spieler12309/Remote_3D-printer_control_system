from django.shortcuts import render
from django.http import HttpResponse
from django.http import JsonResponse
from django.contrib.staticfiles.views import serve
from django.core import serializers
from .forms import GcodeCommandForm
from .models import command
import json
import requests
import os

input_pipe_name = "inputPipe"
output_pipe_name = "outputPipe"
open(input_pipe_name, 'tw', encoding='utf-8').close()
open(output_pipe_name, 'tw', encoding='utf-8').close()


validcommands = ["G0", "G1", "G4", "G28", "G90", "G91", "G92", "M6", "M17",
"M18", "M82", "M83", "M104", "M106", "M107", "M109", "M140", "M190"]

def read_pipe():
    try:
        pipe_descr = os.open(output_pipe_name, os.O_RDONLY)
        # pipe_descr = os.open(input_pipe_name, os.O_RDONLY) - это правильная строчка
        mes = os.read(pipe_descr, 1024)
        os.close(pipe_descr)
        print('Got: ' + mes.decode())
    except os.error as exc:
        print('Exception: ' + str(exc))

def write_pipe(s):
    try:
        pipe_descr = os.open(output_pipe_name, os.O_WRONLY)
        os.write(pipe_descr, bytes(s, 'UTF-8'))
        os.close(pipe_descr)
        print("written value: "+s)
    except os.error as exc:
        print('Exception: ' + str(exc))

def index(request):
    if request.method == 'GET':
        print("INDEX GET")
        i = request.path.rfind('.') + 1
        print(i, request.path, request.path[i:])

    form = GcodeCommandForm()
    gcodecommand = command.objects.all()
    print(gcodecommand)
    return render(request, "home.html", {'form':form})


def output(request):
    data=requests.get()
    print(data.text)
    data=data.text
    return render(request, 'home.html',{'data':data})

def add_command(request):
    if request.method == 'POST':
        print("in POST")
        gcommand = request.POST.get('test')
        response_data = {}
        #здесь проверим команду и если она норм то добавим в словарь для отображения и отправим в канал
        if (len(gcommand)>0 and gcommand.split()[0].upper() in validcommands):
            response_data['gcommandinput'] = gcommand
            write_pipe(gcommand)
            read_pipe()
            print(response_data, " gcommand: ", gcommand)
            return HttpResponse(json.dumps(response_data), content_type="application/json")
    return JsonResponse({"not valid command": ""}, status=400)

def check_command(request):
    print('inside check')
    # request should be ajax and method should be GET.
    if request.method == "GET":
        print('!!!!ajax get request')
        # get the command from the client side.
        gcode_command = request.GET.get("gcode_command", None)

        # check for the command in the database.
        # if command.objects.filter(gcode_command = gcode_command).exists():
        #     # if nick_name found return not valid new friend
        #     return JsonResponse({"valid":False}, status = 200)
        # else:
        #     # if nick_name not found, then user can create a new friend.

        # какая-то проверка на валидность команды
        return JsonResponse({"valid": True}, status=200)
    return JsonResponse({"error": ""}, status=400)


def postCommand(request):
    print('inside post')
    if request.method == "POST":
        # get the form data
        print('!!!!ajax post request')
        form = GcodeCommandForm(request.POST)
        # save the data and after fetch the object in instance
        if form.is_valid():
            instance = form.save()
            # serialize in a command object in json
            ser_instance = serializers.serialize('json', [instance, ])
            # send to client side.
            return JsonResponse({"instance": ser_instance}, status=200)
        else:
            # some form errors occured.
            return JsonResponse({"error": form.errors}, status=400)

    # some error occured
    return JsonResponse({"error": ""}, status=400)
