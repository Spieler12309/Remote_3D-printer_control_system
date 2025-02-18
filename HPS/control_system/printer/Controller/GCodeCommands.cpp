#include "PrinterController.h"
//TODO: добавить команду для reset
string PrinterController::gcodeG0(const Parameters& parameters) {
    return gcodeG1(parameters);
    /*int status1 = 0;
    int status2 = 0;
    float dx = 0, dy = 0, dz = 0;
    float pos_x, pos_y, pos_z, pos_e0, pos_e1;
    getPositions(  pos_x, pos_y,
                    pos_z, pos_e0,
                    pos_e1);
    if (!isRelated()) {
        dx = pos_x;
        dy = pos_y;
        dz = pos_z;
    }

    uint32_t fx, fy, fz;
    fx = printerVariables.settings.movement.defaultSpeed.x;
    fy = printerVariables.settings.movement.defaultSpeed.y;
    fz = printerVariables.settings.movement.defaultSpeed.z;

    if (parameters.find("F")) {
        fx = static_cast<uint32_t>(parameters["F"]);
        fy = static_cast<uint32_t>(parameters["F"]);
    }

    if (parameters.find("FX")) {
        fx = static_cast<uint32_t>(parameters["FX"]);
    }
    if (parameters.find("FY")) {
        fy = static_cast<uint32_t>(parameters["FY"]);
    }
    if (parameters.find("FZ")) {
        fz = static_cast<uint32_t>(parameters["FZ"]);
    }

    if (parameters.find("X")) {
        dx = parameters["X"];
    }
    if (parameters.find("Y")) {
        dy = parameters["Y"];
    }
    if (parameters.find("Z")) {
        dz = parameters["Z"];
    }
    status1 = mechanics.move(dx, dy, dz, fx, fy, fz);

    bool xmin, xmax, ymin, ymax, zmin, zmax, barend;
    mechanics.getEndstopsStates(xmin, xmax, ymin, ymax, zmin, zmax, barend);
    status2 = mechanics.setCurrentPosition(xmin, ymin, zmin, false, 0, 0, 0, 0);

    if (status1 == 1 && status2 == 1) {
        return "1";
    }
    else {
        return "0";
    }
    return "0";*/
}

string PrinterController::gcodeG1(const Parameters& parameters) {
    int status1 = 0;
    int status2 = 0;
    float dx = 0, dy = 0, dz = 0, de0 = 0, de1 = 0;
    float pos_x, pos_y, pos_z, pos_e0, pos_e1;
    mechanics.getPositions(pos_x, pos_y,
                            pos_z, pos_e0,
                            pos_e1);
    if (!mechanics.getFlags(   flags_out_num,
                                flags_out_position_type)) {
        dx = pos_x;
        dy = pos_y;
        dz = pos_z;
    }
    if (!mechanics.getFlags(   flags_out_num,
                                flags_out_position_extruder_type)) {
        de0 = pos_e0;
        de1 = pos_e1;
    }

    uint32_t fx, fy, fz, fe0, fe1;

    fx = printerVariables.settings.movement.defaultSpeed.x;
    fy = printerVariables.settings.movement.defaultSpeed.y;
    fz = printerVariables.settings.movement.defaultSpeed.z;
    fe0 = printerVariables.settings.movement.defaultSpeed.e0;
    fe1 = printerVariables.settings.movement.defaultSpeed.e1;
    if (parameters.find("F")) {
        fx = static_cast<uint32_t>(parameters["F"]);
        fy = static_cast<uint32_t>(parameters["F"]);
    }

    if (parameters.find("FX")) {
        fx = static_cast<uint32_t>(parameters["FX"]);
    }
    if (parameters.find("FY")) {
        fy = static_cast<uint32_t>(parameters["FY"]);
    }
    if (parameters.find("FZ")) {
        fz = static_cast<uint32_t>(parameters["FZ"]);
    }
    if (parameters.find("FE")) {
        if (mechanics.extruderNumber == 0)
            fe0 = static_cast<uint32_t>(parameters["FE"]);
        else
            fe1 = static_cast<uint32_t>(parameters["FE"]);
    }

    if (parameters.find("X")) {
        dx = parameters["X"];
    }
    if (parameters.find("Y")) {
        dy = parameters["Y"];
    }
    if (parameters.find("Z")) {
        dz = parameters["Z"];
    }
    if (parameters.find("E")) {
        if (mechanics.extruderNumber == 0)
            de0 = parameters["E"];
        else
            de1 = parameters["E"];
    }

    status1 = mechanics.moveExtrude(dx, dy, dz, de0, de1, fx, fy, fz, fe0, fe1);
    bool xmin, xmax, ymin, ymax, zmin, zmax, barend;
    //mechanics.getEndstopsStates(xmin, xmax, ymin, ymax, zmin, zmax, barend);
    //status2 = mechanics.setCurrentPosition(xmin, ymin, zmin, false, 0, 0, 0, 0);

    string ans = "";

    if ((status1 == 1)){//&& (status2 == 1)) {
        ans =  "1 ";
    }
    else {
        ans =  "0 ";
    }

    mechanics.getPositions(pos_x, pos_y, pos_z, pos_e0, pos_e1);

    ostringstream stringStream;
    stringStream << fixed << setw(6) << setprecision(2) << pos_x << " ";
    stringStream << fixed << setw(6) << setprecision(2) << pos_y << " ";
    stringStream << fixed << setw(6) << setprecision(2) << pos_z << " ";
    stringStream << fixed << setw(6) << setprecision(2) << pos_e0 << " ";
    stringStream << fixed << setw(6) << setprecision(2) << pos_e1 << " ";
    ans += stringStream.str();

    mechanics.getEndstopsStates(xmin, xmax,
                                ymin, ymax,
                                zmin, zmax,
                                barend);
    ans +=  " " +
            to_string(xmin)  + " " +
            to_string(xmax)  + " " +
            to_string(ymin)  + " " +
            to_string(ymax) + " " +
            to_string(zmin) + " " +
            to_string(zmax) + " " +
            to_string(barend);

    return ans;
}

string PrinterController::gcodeG4(const Parameters &parameters) {
    if (parameters.find("S")) {
        sleep(parameters["S"]);
    } else
    {
        if (parameters.find("P")) {
            usleep(parameters["P"]);
        }
    }

    return "1";
}

string PrinterController::gcodeG28(const Parameters& parameters) {
    string status1 = 0;
    string status2 = 0;
    string status3 = 0;
    string status4 = 0;
    int status5 = 0;
    //TODO: Сделать home тдельно для каждой оси
    status1 = gcodeG91(parameters);
    Parameters par11;
    par11.insert("FX", printerVariables.settings.movement.homing.fast.x);
    par11.insert("FY", printerVariables.settings.movement.homing.fast.y);
    par11.insert("X", parameters.find("X") * (-500.0));
    status2 = gcodeG0(par11);

    Parameters par12;
    par12.insert("FX", printerVariables.settings.movement.homing.fast.x);
    par12.insert("FY", printerVariables.settings.movement.homing.fast.y);
    par12.insert("Y", parameters.find("Y") * (-500.0));
    status2 = gcodeG0(par12);

    Parameters par13;
    par13.insert("FZ", printerVariables.settings.movement.homing.fast.z);
    par13.insert("Z", parameters.find("Z") * (-500.0));
    status2 = gcodeG0(par13);


    Parameters par21;
    par21.insert("FX", printerVariables.settings.movement.homing.fast.x);
    par21.insert("FY", printerVariables.settings.movement.homing.fast.y);
    par21.insert("X", parameters.find("X") * (10));
    status3 = gcodeG0(par21);

    Parameters par22;
    par22.insert("FX", printerVariables.settings.movement.homing.fast.x);
    par22.insert("FY", printerVariables.settings.movement.homing.fast.y);
    par22.insert("Y", parameters.find("Y") * (10));
    status3 = gcodeG0(par22);

    Parameters par23;
    par23.insert("FZ", printerVariables.settings.movement.homing.fast.z);
    par23.insert("Z", parameters.find("Z") * (10));
    status3 = gcodeG0(par23);

    Parameters par31;
    par31.insert("FX", printerVariables.settings.movement.homing.fast.x);
    par31.insert("FY", printerVariables.settings.movement.homing.fast.y);
    par31.insert("X", parameters.find("X") * (-15));
    status4 = gcodeG0(par31);

    Parameters par32;
    par32.insert("FX", printerVariables.settings.movement.homing.fast.x);
    par32.insert("FY", printerVariables.settings.movement.homing.fast.y);
    par32.insert("Y", parameters.find("Y") * (-15));
    status4 = gcodeG0(par32);

    Parameters par33;
    par33.insert("FZ", printerVariables.settings.movement.homing.fast.z);
    par33.insert("Z", parameters.find("Z") * (-15));
    status4 = gcodeG0(par33);

    status5 = mechanics.setCurrentPosition(true, true, true, false, 0, 0, 0, 0);
    gcodeG90(par33);


    string ans = "";

    bool xmin   = 0;
    bool ymin   = 0;
    bool zmin   = 0;
    bool xmax   = 0;
    bool ymax   = 0;
    bool zmax   = 0;
    bool barend = 0;
    float pos_x  = 0;
    float pos_y  = 0;
    float pos_z  = 0;
    float pos_e0 = 0;
    float pos_e1 = 0;

    if  ((status1 == "1") &&
         (status2 == "1") &&
         (status3 == "1") &&
         (status4 == "1") &&
         (status5 == 1)) {
        ans = "1 ";
    }
    else {
        ans = "0 ";
    }

    mechanics.getPositions(pos_x, pos_y, pos_z, pos_e0, pos_e1);

    ostringstream stringStream;
    stringStream << fixed << setw(6) << setprecision(2) << pos_x << " ";
    stringStream << fixed << setw(6) << setprecision(2) << pos_y << " ";
    stringStream << fixed << setw(6) << setprecision(2) << pos_z << " ";
    stringStream << fixed << setw(6) << setprecision(2) << pos_e0 << " ";
    stringStream << fixed << setw(6) << setprecision(2) << pos_e1 << " ";
    ans += stringStream.str();

    mechanics.getEndstopsStates(xmin, xmax,
                                ymin, ymax,
                                zmin, zmax,
                                barend);
    ans +=  " " +
            to_string(xmin)  + " " +
            to_string(xmax)  + " " +
            to_string(ymin)  + " " +
            to_string(ymax) + " " +
            to_string(zmin) + " " +
            to_string(zmax) + " " +
            to_string(barend);

    return ans;
}

string PrinterController::gcodeG90(const Parameters& parameters) {
    int status = 0;
    status = mechanics.setAbsolute();

    if (status == 1) {
        return "1";
    }
    else {
        return "0";
    }
    return "0";
}

string PrinterController::gcodeG91(const Parameters& parameters) {
    int status = 0;
    status = mechanics.setRelative();

    if (status == 1) {
        return "1";
    }
    else {
        return "0";
    }
    return "0";
}

string PrinterController::gcodeG92(const Parameters& parameters) {
    int status = 0;
    bool x = parameters.find("X");
    bool y = parameters.find("Y");
    bool z = parameters.find("Z");
    bool e = parameters.find("E");
    float dx, dy, dz, de;
    if (parameters.find("X"))
        dx = parameters["X"];
    if (parameters.find("Y"))
        dy = parameters["Y"];
    if (parameters.find("Z"))
        dz = parameters["Z"];
    if (parameters.find("E"))
        de = parameters["E"];

    status = mechanics.setCurrentPosition(x, y, z, e,
            dx, dy, dz, de);

    string ans = "";

    float pos_x  = 0;
    float pos_y  = 0;
    float pos_z  = 0;
    float pos_e0 = 0;
    float pos_e1 = 0;

    if (status == 1) {
        ans = "1";
    }
    else {
        ans = "0";
    }

    mechanics.getPositions(pos_x, pos_y, pos_z, pos_e0, pos_e1);

    ostringstream stringStream;
    stringStream << fixed << setw(6) << setprecision(2) << pos_x << " ";
    stringStream << fixed << setw(6) << setprecision(2) << pos_y << " ";
    stringStream << fixed << setw(6) << setprecision(2) << pos_z << " ";
    stringStream << fixed << setw(6) << setprecision(2) << pos_e0 << " ";
    stringStream << fixed << setw(6) << setprecision(2) << pos_e1 << " ";
    ans += stringStream.str();

    return ans;
}

string PrinterController::gcodeM6(const Parameters& parameters) {
    int status = 0;
    if (parameters.find("T"))
        status = mechanics.changeExtruder(parameters["T"]);

    if (status == 1) {
        return "1";
    }
    else {
        return "0";
    }
    return "0";
}

string PrinterController::gcodeM17(const Parameters& parameters) {
    int status = 0;
    status = mechanics.enableMotors();

    if (status == 1) {
        return "1";
    }
    else {
        return "0";
    }
    return "0";
}

string PrinterController::gcodeM18(const Parameters& parameters) {
    int status = 0;
    status = mechanics.disableMotors();

    if (status == 1) {
        return "1";
    }
    else {
        return "0";
    }
    return "0";
}

string PrinterController::gcodeM82(const Parameters& parameters) {
    int status = 0;
    status = mechanics.setAbsoluteExtruder();

    if (status == 1) {
        return "1";
    }
    else {
        return "0";
    }
    return "0";
}

string PrinterController::gcodeM83(const Parameters& parameters) {
    int status = 0;
    status = mechanics.setRelativeExtruder();

    if (status == 1) {
        return "1";
    }
    else {
        return "0";
    }
    return "0";
}

string PrinterController::gcodeM104(const Parameters& parameters) {
    int status = 0;
    if (parameters.find("S")) {
        status = mechanics.setTemperature(HEATER_E0, parameters["S"]);
    }

    if (status == 1) {
        return "1";
    }
    else {
        return "0";
    }
    return "0";
}

string PrinterController::gcodeM105(const Parameters& parameters) {
    int status = 0;
    if (parameters.find("S"))
        status = mechanics.getTemp(parameters["S"]);

    return to_string(status);
}

string PrinterController::gcodeM106(const Parameters& parameters) {
    int status = 0;
    status = mechanics.startCooling();

    if (status == 1) {
        return "1";
    }
    else {
        return "0";
    }
    return "0";
}

string PrinterController::gcodeM107(const Parameters& parameters) {
    int status = 0;
    status = mechanics.stopCooling();

    if (status == 1) {
        return "1";
    }
    else {
        return "0";
    }
    return "0";
}

string PrinterController::gcodeM109(const Parameters& parameters) {
    int status = 0;
    if (parameters.find("S")) {
        status = mechanics.holdTemperature(HEATER_E0, parameters["S"]);
    }

    if (status == 1) {
        return "1";
    }
    else {
        return "0";
    }
    return "0";
}

string PrinterController::gcodeM114(const Parameters& parameters) {
    float pos_x  = 0;
    float pos_y  = 0;
    float pos_z  = 0;
    float pos_e0 = 0;
    float pos_e1 = 0;
    mechanics.getPositions(pos_x, pos_y, pos_z, pos_e0, pos_e1);

    ostringstream stringStream;
    stringStream << fixed << setw(6) << setprecision(2) << pos_x << " ";
    stringStream << fixed << setw(6) << setprecision(2) << pos_y << " ";
    stringStream << fixed << setw(6) << setprecision(2) << pos_z << " ";
    stringStream << fixed << setw(6) << setprecision(2) << pos_e0 << " ";
    stringStream << fixed << setw(6) << setprecision(2) << pos_e1;
    string spos = stringStream.str();

    return spos;
//    return  format(".4%f", pos_x)  + " " +
//            format(".4%f", pos_y)  + " " +
//            format(".4%f", pos_z)  + " " +
//            format(".4%f", pos_e0) + " " +
//            format(".4%f", pos_e0);
}

string PrinterController::gcodeM119(const Parameters& parameters) {
    bool xmin   = 0;
    bool ymin   = 0;
    bool zmin   = 0;
    bool xmax   = 0;
    bool ymax   = 0;
    bool zmax   = 0;
    bool barend = 0;
    mechanics.getEndstopsStates(xmin, xmax,
                                 ymin, ymax,
                                 zmin, zmax,
                                 barend);
    return  to_string(xmin)  + " " +
            to_string(xmax)  + " " +
            to_string(ymin)  + " " +
            to_string(ymax) + " " +
            to_string(zmin) + " " +
            to_string(zmax) + " " +
            to_string(barend);
}

string PrinterController::gcodeM140(const Parameters& parameters) {
    int status = 0;
    if (parameters.find("S")) {
        status = mechanics.setTemperature(HEATER_BED, parameters["S"]);
    }

    if (status == 1) {
        return "1";
    }
    else {
        return "0";
    }
    return "0";
}

string PrinterController::gcodeM190(const Parameters& parameters) {
    int status = 0;
    if (parameters.find("S")) {
        status = mechanics.holdTemperature(HEATER_BED, parameters["S"]);
    }

    if (status == 1) {
        return "1";
    }
    else {
        return "0";
    }
    return "0";
}

string PrinterController::gcodeM501(const Parameters& parameters) {
    loadSettings();
    mechanics.setSettings();
    mechanics.printSettings();
    return "1";
}

string PrinterController::resetSystem(const Parameters& parameters) {
    mechanics.initMem();
    return "1";
}