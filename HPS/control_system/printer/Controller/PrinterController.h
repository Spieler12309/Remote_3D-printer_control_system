#ifndef INC_3D_PRINTER_PRINTERCONTROLLER_H
#define INC_3D_PRINTER_PRINTERCONTROLLER_H

#include <cstring>
#include <cmath>
#include <unistd.h>
#include <stdio.h>
#include <string>
#include <bits/stdc++.h>

#include "Dict.h"
#include "Types.h"
#include "configuration.h"

#include "MechanicsController.h"

#include <iostream>
#include <fstream>

#include <sys/types.h>
#include <sys/stat.h>

#include <unistd.h>

#include <json.h>
using json = nlohmann::json;

using namespace std;

class PrinterController {

public:
    PrinterController();

    MechanicsController mechanics;
    PrinterVariables printerVariables;

    // пути к файлам с настройками/вспомагательным
    const string toSettings = "/home/root/printer_management/webapp/static/js/setting.json";
    const char* fromPipe = "/home/root/printer_management/outputPipe.msg";
    const char* toPipe = "/home/root/printer_management/inputPipe.msg";

    void mainLoop();

    // методы отвечающие за состояния
    void waiting();
    void printing(string command);

    // список необходимых gcode комманд
    // сейчас функции возвращаю void, но потом должны возращать код ошибки
    string gcodeG0      (const Parameters& parameters);
    string gcodeG1      (const Parameters& parameters);
    string gcodeG4      (const Parameters& parameters);
    string gcodeG28     (const Parameters& parameters);
    string gcodeG90     (const Parameters& parameters);
    string gcodeG91     (const Parameters& parameters);
    string gcodeG92     (const Parameters& parameters);
    string gcodeM6      (const Parameters& parameters);

    string gcodeM17     (const Parameters& parameters);
    string gcodeM18     (const Parameters& parameters);
    string gcodeM82     (const Parameters& parameters);
    string gcodeM83     (const Parameters& parameters);
    string gcodeM104    (const Parameters& parameters);
    string gcodeM105    (const Parameters& parameters);
    string gcodeM106    (const Parameters& parameters);
    string gcodeM107    (const Parameters& parameters);
    string gcodeM109    (const Parameters& parameters);
    string gcodeM114    (const Parameters& parameters);
    string gcodeM119    (const Parameters& parameters);
    string gcodeM140    (const Parameters& parameters);
    string gcodeM190    (const Parameters& parameters);
    string gcodeM501    (const Parameters& parameters);

    dict<string, string(PrinterController::*)(const Parameters&)> gcode_commands = {
            {"G0",      &PrinterController::gcodeG0},
            {"G1",      &PrinterController::gcodeG1},
            {"G4",      &PrinterController::gcodeG4},
            {"G28",     &PrinterController::gcodeG28},
            {"G90",     &PrinterController::gcodeG90},
            {"G91",     &PrinterController::gcodeG91},
            {"G92",     &PrinterController::gcodeG92},

            {"M6",      &PrinterController::gcodeM6},
            {"M17",     &PrinterController::gcodeM17},
            {"M18",     &PrinterController::gcodeM18},
            {"M82",     &PrinterController::gcodeM82},
            {"M83",     &PrinterController::gcodeM83},
            {"M104",    &PrinterController::gcodeM104},
            {"M105",    &PrinterController::gcodeM105},
            {"M106",    &PrinterController::gcodeM106},
            {"M107",    &PrinterController::gcodeM107},
            {"M109",    &PrinterController::gcodeM109},
            {"M114",    &PrinterController::gcodeM114},
            {"M119",    &PrinterController::gcodeM119},
            {"M140",    &PrinterController::gcodeM140},
            {"M190",    &PrinterController::gcodeM190},
            {"M501",    &PrinterController::gcodeM501},
    };


    void loadSettings();
    void createSettings();
    void writeToPipe(string s);
    string readFromPipe();
    
};

#endif //INC_3D_PRINTER_PRINTERCONTROLLER_H