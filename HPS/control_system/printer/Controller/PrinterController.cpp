#include <tuple>
#include <chrono>

#include "PrinterController.h"
#include "GCodeParser.h"

PrinterController::PrinterController() {
    mechanics.printer = this;

    //TODO: Считывание настроек из файла или его создание при отсутствии самого файла


    state = Waiting;
    waiting();
}

void PrinterController::main_loop() {

    while (state != ShuttingDown) {
        if (state == Waiting) {
            waiting();
        } else if (state == Printing) {
            printing();
        }
    }

}

void PrinterController::waiting() {
    // state == Waiting
    //TODO: обработать команды от сервера.

    string command;
    Parameters parameters;
    tie(command, parameters) = gcodeParser.parse_command("G0 X100");
    //TODO: передать новые данные на сервер.
    //TODO: добавить задержку перехода в следующую итерацию.
}

void PrinterController::printing() {
    // state == Printing

    cout << "OK - PrinterController::printing" << endl;

    cout << "--Printing--" << endl;
    int32_t pos_x, pos_y, pos_z, pos_e0, pos_e1;
    mechanics.get_positions(pos_x, pos_y,
              pos_z, pos_e0,
              pos_e1);
    cout << "Координаты: " << pos_x << "; " << pos_y << "; " << pos_z << "; " << pos_e0 << "; " << pos_e1 << endl;
    gcodeParser parser(to_print);
    while ((!parser.is_done()) && (state != Stop_Printing)) {
        string command;
        Parameters parameters;
        tie(command, parameters) = parser.parse_command();

        cout << "Command:" << command << "; Parameters: {" << parameters << "}" << endl;

        if (gcode_commands.find(command)) {
            (this->*gcode_commands[command])(parameters);
        } else {
            // передать на экран ошибку
        }

        //TODO: обработать команды от сервера.
        //TODO: передать новые данные на сервер.
        while (state == Pause_Printing) {
            // обратобать события экрана
        }
        
    }


    state = Waiting;
    // если parser.is_done то все хорошо
    // иначе печать завершилась аварийно
}
