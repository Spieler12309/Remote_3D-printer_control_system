#include "PrinterController.h"

void PrinterController::update_parameters()
{
    //TODO: Нужно выслать все параметры
}

void PrinterController::set_pid(float pid_p, float pid_i, float pid_d) {
    fstream f;
    f.open(to_settings);
// проверить существует ли файл
    if (!f.is_open()) {
        throw invalid_argument("Wrong settings file to_settings!pid");
    }
// прочитать файл и найти свойства пресета
    string line;
    int i = 0;
    bool settings_found = false;
    while (getline(f, line) && !settings_found) {
        i++;
        if (line.find("pid") != string::npos) {
            settings_found = true;
            getline(f, line);
            ofstream temp;
            temp.open(extra_set);
            f.seekg(0, f.beg);
            for(int j = 0; j < i; j++) {
                getline(f, line);
                temp << line << endl;
            }
            temp << pid_p <<endl;
            temp << pid_i

                 <<endl;
            temp << pid_d <<endl;
            for(int j = 0; j < 3; j++) getline(f, line);
            while(!f.eof()) {
                getline(f, line);
                temp << line;
                if(!f.eof()) temp << endl;
            }
            f.clear();
            ifstream temp_read;
            temp_read.open(extra_set);
            ofstream test_write;
            test_write.open(to_settings);
            while(!temp_read.eof()) {
                temp_read >> line;
                test_write << line;
                if(!temp_read.eof()) test_write << endl;
            }
            temp_read.close();
            test_write.close();
        }
    }
    f.close();
}

void PrinterController::set_speed(float x, float y, float z, float e) {
    fstream f;
    f.open(to_settings);
// проверить существует ли файл
    if (!f.is_open()) {
        throw invalid_argument("Wrong settings file to_settings!speed");
    }
// прочитать файл и найти свойства пресета
    string line;
    int i = 0;
    bool settings_found = false;
    while (getline(f, line) && !settings_found) {
        i++;
        if (line.find("speed") != string::npos) {
            settings_found = true;
            getline(f, line);
            ofstream temp;
            temp.open(extra_set);
            f.seekg(0, f.beg);
            for (int j = 0; j < i; j++) {
                getline(f, line);
                temp << line << endl;
            }
            temp << x << endl;
            temp << y << endl;
            temp << z << endl;
            temp << e << endl;
            for (int j = 0; j < 4; j++) getline(f, line);
            while (!f.eof()) {
                getline(f, line);
                temp << line;
                if (!f.eof()) temp << endl;
            }
            f.clear();
            ifstream temp_read;
            temp_read.open(extra_set);
            ofstream test_write;
            test_write.open(to_settings);
            while (!temp_read.eof()) {
                temp_read >> line;
                test_write << line;
                if (!temp_read.eof()) test_write << endl;
            }
            temp_read.close();
            test_write.close();
        }
    }
    f.close();
}

void PrinterController::set_max_xyz(float max_x, float max_y, float max_z) {
    fstream f;
    f.open(to_settings);
// проверить существует ли файл 
    if (!f.is_open()) {
        throw invalid_argument("Wrong settings file to_settings!max_xyz");
    }
// прочитать файл и найти свойства пресета 
    string line;
    int i = 0;
    bool settings_found = false;
    while (getline(f, line) && !settings_found) {
        i++;
        if (line.find("max_xyz") != string::npos) {
            settings_found = true;
            getline(f, line);
            ofstream temp;
            temp.open(extra_set);
            f.seekg(0, f.beg);
            for(int j = 0; j < i; j++) {
                getline(f, line);
                temp << line << endl;
            }
            temp << max_x <<endl;
            temp << max_y <<endl;
            temp << max_z <<endl;
            for(int j = 0; j < 3; j++) getline(f, line);
            while(!f.eof()) {
                getline(f, line);
                temp << line;
                if(!f.eof()) temp << endl;
            }
            f.clear();
            ifstream temp_read;
            temp_read.open(extra_set);
            ofstream test_write;
            test_write.open(to_settings);
            while(!temp_read.eof()) {
                temp_read >> line;
                test_write << line;
                if(!temp_read.eof()) test_write << endl;
            }
            temp_read.close();
            test_write.close();
        }
    }
    f.close();
}

void PrinterController::get_pid(float& pid_p, float& pid_i, float& pid_d) {
    fstream f;
    f.open(to_settings);
    // проверить существует ли файл
    if (!f.is_open()) {
        throw invalid_argument("Wrong settings file to_settings!pid");
    }
    // прочитать файл и найти свойства пресета
    string line;
    bool settings_found = false;
    while (getline(f, line) && !settings_found) {
        if (line.find("pid") != string::npos) {
            settings_found = true;
            getline(f, line);
            pid_p = stof(line);
            getline(f, line);
            pid_i = stof(line);
            getline(f, line);
            pid_d = stof(line);
        }
    }
    f.close();
}

void PrinterController::get_speed(float& x, float& y, float& z, float& e) {
    fstream f;
    f.open(to_settings);
    // проверить существует ли файл
    if (!f.is_open()) {
        throw invalid_argument("Wrong settings file to_settings!speed");
    }
    // прочитать файл и найти свойства пресета
    string line;
    bool speed_found = false;
    while (getline(f, line) && !speed_found) {
        if (line.find("speed") != string::npos) {
            speed_found = true;
            getline(f, line);
            x = stof(line);
            getline(f, line);
            y = stof(line);
            getline(f, line);
            z = stof(line);
            getline(f, line);
            e = stof(line);
        }
    }
    f.close();
}

void PrinterController::get_max_xyz(float& max_x, float& max_y, float& max_z) {
    fstream f;
    f.open(to_settings);
    // проверить существует ли файл
    if (!f.is_open()) {
        throw invalid_argument("Wrong settings file to_settings!max_xyz");
    }
    // прочитать файл и найти свойства пресета
    string line;
    bool settings_found = false;
    while (getline(f, line) && !settings_found) {
        if (line.find("max_xyz") != string::npos) {
            settings_found = true;
            getline(f, line);
            max_x = stof(line);
            getline(f, line);
            max_y = stof(line);
            getline(f, line);
            max_z = stof(line);
        }
    }
    f.close();
}