#include "GcodeParser.h"

GcodeParser::GcodeParser() {

}

GcodeParser::GcodeParser(const string& path) {
    this->path = path;
    f.open(path);
    // проверить существует ли файл
    if (!f.is_open()) {
        throw invalid_argument("Wrong gcode file path!");
    }

    currentCommand = 0;
    commands = 0;
    // прочитать файл - почтитать кол-во commands
    string line;
    while (getline(f, line)) {
        if (line[0] == 'G' || line[0] == 'M') {
            ++commands;
        }
    }

    // вернуть позиционирование в начало файла
    f.clear();
    f.seekg(0, f.beg);
}

GcodeParser::~GcodeParser() {
    f.close();
}

pair<string, Parameters> GcodeParser::parse_command() {
    string command;
    Parameters parameters;

    string line;
    while (line.length() == 0 || (line[0] != 'G' && line[0] != 'M')) {
        getline(f, line);
    }
    int space_idx = -1;
    int i = 0;
    for (; i < line.size() && line[i] != ';'; ++i) {
        if (line[i] == ' ') {
            if (space_idx == -1) {
                command = line.substr(0, i);
            } else {
                if (isalpha(line[space_idx + 2])) {
                    parameters.insert(line.substr(space_idx + 1, 2),
                                      stof(line.substr(space_idx + 3, i - space_idx - 2)));
                }
                else {
                    parameters.insert(line.substr(space_idx + 1, 1),
                                      stof(line.substr(space_idx + 2, i - space_idx - 2)));
                }
            }
            space_idx = i;
        }
    }

    if (i == line.size()) {
        if (space_idx == -1) {
            command = line.substr(0, line.size());
        } else {
            if (isalpha(line[space_idx + 2])) {
                parameters.insert(line.substr(line[space_idx + 1], 2),
                                  stof(line.substr(space_idx + 3, i - space_idx - 2)));
            }
            else {
                parameters.insert(line.substr(line[space_idx + 1], 1),
                                  stof(line.substr(space_idx + 2, i - space_idx - 2)));
            }
        }
    }
    ++currentCommand;

    return make_pair(command, parameters);
}

pair<string, Parameters> GcodeParser::parse_command(string line) {
    string command;
    Parameters parameters;
    int space_idx = -1;
    int i = 0;
    for (; i < line.size() && line[i] != ';'; ++i) {
        if (line[i] == ' ') {
            if (space_idx == -1) {
                command = line.substr(0, i);
            } else {
                if (isalpha(line[space_idx + 2])) {
                    parameters.insert(line.substr(space_idx + 1, 2),
                                      stof(line.substr(space_idx + 3, i - space_idx - 2)));
                }
                else {
                    parameters.insert(line.substr(space_idx + 1, 1),
                                      stof(line.substr(space_idx + 2, i - space_idx - 2)));
                }
            }
            space_idx = i;
        }
    }
    if (i == line.size()) {
        if (space_idx == -1) {
            command = line.substr(0, line.size());
        } else {
            if (isalpha(line[space_idx + 2])) {
                parameters.insert(line.substr(space_idx + 1, 2),
                                  stof(line.substr(space_idx + 3, i - space_idx - 2)));
            }
            else {
                parameters.insert(line.substr(space_idx + 1, 1),
                                  stof(line.substr(space_idx + 2, i - space_idx - 2)));
            }
        }
    }
    ++currentCommand;
    return make_pair(command, parameters);
}

bool GcodeParser::is_done() {
    return commands == currentCommand;
}

int GcodeParser::get_command_percentage(){
    return (int) 100 * (float) currentCommand / commands;
}
