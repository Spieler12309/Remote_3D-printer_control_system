#ifndef INC_3D_PRINTER_PRINTERCONTROLLER_H
#define INC_3D_PRINTER_PRINTERCONTROLLER_H

#include <cstring>
#include <cmath>
#include <unistd.h>

#include "Dict.h"
#include "Types.h"
#include "configuration.h"

#include "MechanicsController.h"
#include "FileManager.h"

#include <iostream>
#include <fstream>

using namespace std;

class PrinterController {

public:
    PrinterController();

    MechanicsController mechanics;
    FileManager fileManager;

    StateType state;
    PrinterVariables settings;


    // пути к файлам для печати
    string to_print;
    // пути к файлам с настройками/вспомагательным
    const string to_settings = "settings.txt";
    const string extra_set = "temp.txt";

    void main_loop();

    // методы отвечающие за состояния
    void waiting();
    void printing();

    // список необходимых gcode комманд
    // сейчас функции возвращаю void, но потом должны возращать код ошибки
    void gcode_G0(const Parameters& parameters);
    void gcode_G1(const Parameters& parameters);
    void gcode_G4(const Parameters& parameters);
    void gcode_G28(const Parameters& parameters);
    void gcode_G90(const Parameters& parameters);
    void gcode_G91(const Parameters& parameters);
    void gcode_G92(const Parameters& parameters);
    void gcode_M6(const Parameters& parameters);
    void gcode_M17(const Parameters& parameters);
    void gcode_M18(const Parameters& parameters);
    void gcode_M82(const Parameters& parameters);
    void gcode_M83(const Parameters& parameters);
    void gcode_M104(const Parameters& parameters);
    void gcode_M106(const Parameters& parameters);
    void gcode_M107(const Parameters& parameters);
    void gcode_M109(const Parameters& parameters);
    void gcode_M140(const Parameters& parameters);
    void gcode_M190(const Parameters& parameters);

    dict<string, void(PrinterController::*)(const Parameters&)> gcode_commands = {
            {"G0", &PrinterController::gcode_G0},
            {"G1", &PrinterController::gcode_G1},
            {"G4", &PrinterController::gcode_G4},
            {"G28", &PrinterController::gcode_G28},
            {"G90", &PrinterController::gcode_G90},
            {"G91", &PrinterController::gcode_G91},
            {"G92", &PrinterController::gcode_G92},
            {"M6", &PrinterController::gcode_M6},
            {"M17", &PrinterController::gcode_M17},
            {"M18", &PrinterController::gcode_M18},
            {"M82", &PrinterController::gcode_M82},
            {"M83", &PrinterController::gcode_M83},
            {"M104", &PrinterController::gcode_M104},
            {"M106", &PrinterController::gcode_M106},
            {"M107", &PrinterController::gcode_M107},
            {"M109", &PrinterController::gcode_M109},
            {"M140", &PrinterController::gcode_M140},
            {"M190", &PrinterController::gcode_M190},
    };


    void update_parameters(); //Обновить изменяющиеся параметры (температура, статус, др)
    void set_pid(float pid_p, float pid_i, float pid_d);
    void set_speed(float x, float y, float z, float e);
    void set_max_xyz(float max_x, float max_y, float max_z);
    void get_pid(float& pid_p, float& pid_i, float& pid_d);
    void get_speed(float& x, float& y, float& z, float& e);
    void get_max_xyz(float& max_x, float& max_y, float& max_z);
    
};

#endif //INC_3D_PRINTER_PRINTERCONTROLLER_H