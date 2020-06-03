#ifndef INC_3D_PRINTER_GCODEPARSER_H
#define INC_3D_PRINTER_GCODEPARSER_H

#include <string>
#include <fstream>
#include <exception>
#include <ctype.h>
#include <stdio.h>
#include <iostream>

#include "dict.h"

using namespace std;

class GcodeParser {
    string path;
    fstream f;

    unsigned int commands; // количество команд
    unsigned int currentCommand;
public:
    explicit GcodeParser(const string& path);
    explicit GcodeParser();
    ~GcodeParser();
    int get_command_percentage();

    pair<string, Parameters> parse_command();
    pair<string, Parameters> parse_command(string line);
    bool is_done();
};

#endif //INC_3D_PRINTER_GCODEPARSER_H