#include "PrinterController.h"

void PrinterController::loadSettings()
{
    ifstream ifs(toSettings);
    if (!(ifs.is_open())){
        createSettings();
    }
    ifs.close();
    ifstream ifs2(toSettings);
    json j = json::parse(ifs2);

    printerVariables.settings.heaters.pid.p = j["pid"]["P"];
    printerVariables.settings.heaters.pid.i = j["pid"]["I"];
    printerVariables.settings.heaters.pid.d = j["pid"]["D"];

    printerVariables.settings.heaters.delta = j["delta"];

    printerVariables.settings.movement.homing.fast.x = j["home_speed_fast"]["X"];
    printerVariables.settings.movement.homing.fast.y = j["home_speed_fast"]["Y"];
    printerVariables.settings.movement.homing.fast.z = j["home_speed_fast"]["Z"];

    printerVariables.settings.movement.homing.slow.x = j["home_speed_slow"]["X"];
    printerVariables.settings.movement.homing.slow.y = j["home_speed_slow"]["Y"];
    printerVariables.settings.movement.homing.slow.z = j["home_speed_slow"]["Z"];

    printerVariables.settings.movement.default_Speed.x  = j["speed"]["X"];
    printerVariables.settings.movement.default_Speed.y  = j["speed"]["Y"];
    printerVariables.settings.movement.default_Speed.z  = j["speed"]["Z"];
    printerVariables.settings.movement.default_Speed.e0 = j["speed"]["E0"];
    printerVariables.settings.movement.default_Speed.e1 = j["speed"]["E0"];

    printerVariables.settings.movement.max_Speed.x  = j["max_speed"]["X"];
    printerVariables.settings.movement.max_Speed.y  = j["max_speed"]["Y"];
    printerVariables.settings.movement.max_Speed.z  = j["max_speed"]["Z"];
    printerVariables.settings.movement.max_Speed.e0 = j["max_speed"]["E0"];
    printerVariables.settings.movement.max_Speed.e1 = j["max_speed"]["E0"];

    printerVariables.settings.movement.max_Acceleration.x  = j["acceleration"]["X"];
    printerVariables.settings.movement.max_Acceleration.y  = j["acceleration"]["Y"];
    printerVariables.settings.movement.max_Acceleration.z  = j["acceleration"]["Z"];
    printerVariables.settings.movement.max_Acceleration.e0 = j["acceleration"]["E0"];
    printerVariables.settings.movement.max_Acceleration.e1 = j["acceleration"]["E0"];

    printerVariables.settings.movement.max_Jerk.x  = j["jerk"]["X"];
    printerVariables.settings.movement.max_Jerk.y  = j["jerk"]["Y"];
    printerVariables.settings.movement.max_Jerk.z  = j["jerk"]["Z"];
    printerVariables.settings.movement.max_Jerk.e0 = j["jerk"]["E0"];
    printerVariables.settings.movement.max_Jerk.e1 = j["jerk"]["E0"];

    printerVariables.settings.heaters.max_Temp.bed = j["max_temps"]["BED"];
    printerVariables.settings.heaters.max_Temp.e0 = j["max_temps"]["E0"];
    printerVariables.settings.heaters.max_Temp.e1 = j["max_temps"]["E0"];

    printerVariables.settings.movement.step_per_Unit.x  = j["steps_per_unit"]["X"];
    printerVariables.settings.movement.step_per_Unit.y  = j["steps_per_unit"]["Y"];
    printerVariables.settings.movement.step_per_Unit.z  = j["steps_per_unit"]["Z"];
    printerVariables.settings.movement.step_per_Unit.e0 = j["steps_per_unit"]["E0"];
    printerVariables.settings.movement.step_per_Unit.e1 = j["steps_per_unit"]["E0"];

    printerVariables.settings.movement.size.x = j["max_size"]["X"];
    printerVariables.settings.movement.size.y = j["max_size"]["Y"];
    printerVariables.settings.movement.size.z = j["max_size"]["Z"];

    printerVariables.settings.movement.num_extruders = j["num_extruders"];
    printerVariables.settings.movement.num_motors = j["num_motors"];

    printerVariables.settings.movement.invertion.motors.x  = j["motors_inverting"]["X"];
    printerVariables.settings.movement.invertion.motors.y  = j["motors_inverting"]["Y"];
    printerVariables.settings.movement.invertion.motors.z  = j["motors_inverting"]["Z"];
    printerVariables.settings.movement.invertion.motors.e0 = j["motors_inverting"]["E0"];
    printerVariables.settings.movement.invertion.motors.e1 = j["motors_inverting"]["E0"];

    printerVariables.settings.movement.num_endstops = j["num_endstops"];

    printerVariables.settings.movement.invertion.endstops.xmin = j["endstops_inverting"]["X_MIN"];
    printerVariables.settings.movement.invertion.endstops.xmax = j["endstops_inverting"]["X_MAX"];
    printerVariables.settings.movement.invertion.endstops.ymin = j["endstops_inverting"]["Y_MIN"];
    printerVariables.settings.movement.invertion.endstops.ymax = j["endstops_inverting"]["Y_MAX"];
    printerVariables.settings.movement.invertion.endstops.zmin = j["endstops_inverting"]["Z_MIN"];
    printerVariables.settings.movement.invertion.endstops.zmax = j["endstops_inverting"]["Z_MAX"];

    printerVariables.settings.movement.invertion.barend.e0 = j["barend_inverting"];
    printerVariables.settings.movement.invertion.barend.e1 = j["barend_inverting"];
}

void PrinterController::createSettings()
{
    json j;
    j["pid"]["P"] = PID[0];
    j["pid"]["I"] = PID[1];
    j["pid"]["D"] = PID[2];

    j["delta"] = TEMP_DELTA;

    j["home_speed_fast"]["X"] = HOMING_SPEED_FAST[0];
    j["home_speed_fast"]["Y"] = HOMING_SPEED_FAST[1];
    j["home_speed_fast"]["Z"] = HOMING_SPEED_FAST[2];

    j["home_speed_slow"]["X"] = HOMING_SPEED_SLOW[0];
    j["home_speed_slow"]["Y"] = HOMING_SPEED_SLOW[1];
    j["home_speed_slow"]["Z"] = HOMING_SPEED_SLOW[2];

    j["speed"]["X"]  = DEFAULT_AXIS_SPEED[0];
    j["speed"]["Y"]  = DEFAULT_AXIS_SPEED[1];
    j["speed"]["Z"]  = DEFAULT_AXIS_SPEED[2];
    j["speed"]["E0"] = DEFAULT_AXIS_SPEED[3];

    j["max_speed"]["X"]  = MAX_AXIS_SPEED[0];
    j["max_speed"]["Y"]  = MAX_AXIS_SPEED[1];
    j["max_speed"]["Z"]  = MAX_AXIS_SPEED[2];
    j["max_speed"]["E0"] = MAX_AXIS_SPEED[3];

    j["acceleration"]["X"]  = MAX_AXIS_ACCELERATION[0];
    j["acceleration"]["Y"]  = MAX_AXIS_ACCELERATION[1];
    j["acceleration"]["Z"]  = MAX_AXIS_ACCELERATION[2];
    j["acceleration"]["E0"] = MAX_AXIS_ACCELERATION[3];

    j["jerk"]["X"]  = MAX_AXIS_JERK[0];
    j["jerk"]["Y"]  = MAX_AXIS_JERK[1];
    j["jerk"]["Z"]  = MAX_AXIS_JERK[2];
    j["jerk"]["E0"] = MAX_AXIS_JERK[3];

    j["max_temps"]["BED"] = MAX_TEMP[HEATER_BED];
    j["max_temps"]["E0"]  = MAX_TEMP[HEATER_E0];

    j["steps_per_unit"]["X"]  = DEFAULT_AXIS_STEPS_PER_UNIT[0];
    j["steps_per_unit"]["Y"]  = DEFAULT_AXIS_STEPS_PER_UNIT[1];
    j["steps_per_unit"]["Z"]  = DEFAULT_AXIS_STEPS_PER_UNIT[2];
    j["steps_per_unit"]["E0"] = DEFAULT_AXIS_STEPS_PER_UNIT[3];

    j["max_size"]["X"]  = MAX_SIZE[0];
    j["max_size"]["Y"]  = MAX_SIZE[1];
    j["max_size"]["Z"]  = MAX_SIZE[2];

    j["num_extruders"] = NUM_EXTRUDERS;
    j["num_motors"] = NUM_STEPPERS;

    j["motors_inverting"]["X"]  = STEPPERS_INVERTING[0];
    j["motors_inverting"]["Y"]  = STEPPERS_INVERTING[1];
    j["motors_inverting"]["Z"]  = STEPPERS_INVERTING[2];
    j["motors_inverting"]["E0"] = STEPPERS_INVERTING[3];

    j["num_endstops"] = NUM_ENDSTOPS;

    j["endstops_inverting"]["X_MIN"] = ENDSTOPS_INVERTING[0];
    j["endstops_inverting"]["X_MAX"] = ENDSTOPS_INVERTING[1];
    j["endstops_inverting"]["Y_MIN"] = ENDSTOPS_INVERTING[2];
    j["endstops_inverting"]["Y_MAX"] = ENDSTOPS_INVERTING[3];
    j["endstops_inverting"]["Z_MIN"] = ENDSTOPS_INVERTING[4];
    j["endstops_inverting"]["Z_MAX"] = ENDSTOPS_INVERTING[5];

    j["barend_inverting"] = BAR_END_ENDSTOP_INVERTING[0];

    ofstream file(toSettings);
    file << j;
    file.close();
}

void PrinterController::writeToPipe(string s) {
    ofstream outfile(toPipe);
    outfile << s;
    outfile.close();
}

string PrinterController::readFromPipe() {
    string alls = "";
    string s = "";
    ifstream myfile(fromPipe);
    if (myfile.is_open()) {
        usleep(1000);
        getline(myfile, alls);
        myfile.close();
    }
    transform(alls.begin(), alls.end(), alls.begin(), ::toupper);

    ofstream outfile(fromPipe);
    if (outfile.is_open()){
        outfile << "";
        outfile.close();
    }

    return alls;
}