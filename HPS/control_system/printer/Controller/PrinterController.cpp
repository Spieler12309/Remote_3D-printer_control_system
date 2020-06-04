#include <tuple>
#include <chrono>

#include "PrinterController.h"
#include "GCodeParser.h"

PrinterController::PrinterController() {
    mechanics.printer = this;
    loadSettings();
    mechanics.initMem();
    mechanics.printSettings();
}

void PrinterController::mainLoop() {
    //writeToPipe("ready\n");
    while (true)
        waiting();
}

void PrinterController::waiting() {
    string command;
    //TODO: Добавить обнуление начальных координат, если дальше будут проблемы
    command = readFromPipe();
    while (command == "")
    {
        usleep(1000000);
        command = readFromPipe();
    }
    cout << "Новая команда: " << command << endl;

    printing(command);
}

void PrinterController::printing(string command) {
    Parameters parameters;
    GcodeParser gp;
    string comm;
    tie(comm, parameters) = gp.parse_command(command);
    string res = command;

    if (gcode_commands.find(comm)) {
        res = (this->*gcode_commands[comm])(parameters);
    }

    ofstream fout("/home/root/printer_management/gcode.txt", ios_base::app);
    fout << "Команда: " << command << ". Ответ: " << res << "." << endl;
    fout.close();

    cout << "Ответ на команду: " << res << endl;
    cout << "----------------------------------------------------------" << endl;
    writeToPipe(res);

    usleep(1000);
}
