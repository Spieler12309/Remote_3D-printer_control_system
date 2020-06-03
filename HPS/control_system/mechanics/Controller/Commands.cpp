#include "MechanicsController.h"
#include "PrinterController.h"

int32_t MechanicsController::move(float dx, float dy, float dz, uint32_t fx, uint32_t fy, uint32_t fz) { //G0

    *command_type = CODE_GCODE_G0;

    if (KINEMATICS == 0) {
        *command_x = static_cast<int32_t>(dx * printer->printerVariables.settings.movement.step_per_Unit.x +
                                          dy * printer->printerVariables.settings.movement.step_per_Unit.y);
        *command_y = static_cast<int32_t>(dx * printer->printerVariables.settings.movement.step_per_Unit.x -
                                          dy * printer->printerVariables.settings.movement.step_per_Unit.y);
    }
    else
    if (KINEMATICS == 1){
        *command_x = static_cast<int32_t>(dx * printer->printerVariables.settings.movement.step_per_Unit.x);
        *command_y = static_cast<int32_t>(dy * printer->printerVariables.settings.movement.step_per_Unit.y);
    }*command_z = static_cast<int32_t>(dz * printer->printerVariables.settings.movement.step_per_Unit.z);

    *command_f_x  = fx * printer->printerVariables.settings.movement.step_per_Unit.x / 60;
    *command_f_y  = fy * printer->printerVariables.settings.movement.step_per_Unit.y / 60;
    *command_f_z  = fz * printer->printerVariables.settings.movement.step_per_Unit.z / 60;


    setFlags(flags_in_num, flags_in_run_command, true);
    usleep(100);

    while (!getFlags(flags_out_num, flags_out_command_finish)) {
        usleep(1000);
    }

    bool fin, err2, err1;
    err2 = getFlags(flags_out_num, flags_out_driving_error);
    err1 = getFlags(flags_out_num, flags_out_command_error);
    fin = getFlags(flags_out_num, flags_out_command_finish);

    setFlags(flags_in_num, flags_in_run_command, false);

    usleep(2);

    *command_type   = 0;
    *command_x      = 0;
    *command_y      = 0;
    *command_z      = 0;
    *command_f_x    = 0;
    *command_f_y    = 0;
    *command_f_z    = 0;
    *command_f_e0   = 0;
    *command_f_e1   = 0;

    return (4 * err2 + 2 * err1 + fin);
}

int32_t MechanicsController::moveExtrude(  float dx, float dy, float dz, float de0, float de1,
                                            uint32_t fx, uint32_t fy, uint32_t fz, uint32_t fe0, uint32_t fe1){ //G1
    *command_type = CODE_GCODE_G1;
    if (KINEMATICS == 0) {
        *command_x = static_cast<int32_t>(dx * printer->printerVariables.settings.movement.step_per_Unit.x +
                                          dy * printer->printerVariables.settings.movement.step_per_Unit.y);
        *command_y = static_cast<int32_t>(dx * printer->printerVariables.settings.movement.step_per_Unit.x -
                                          dy * printer->printerVariables.settings.movement.step_per_Unit.y);
    }
    else if (KINEMATICS == 1){
        *command_x = static_cast<int32_t>(dx * printer->printerVariables.settings.movement.step_per_Unit.x);
        *command_y = static_cast<int32_t>(dy * printer->printerVariables.settings.movement.step_per_Unit.y);
    }
    *command_z = static_cast<int32_t>(dz * printer->printerVariables.settings.movement.step_per_Unit.z);
    *command_e0 = static_cast<int32_t>(de0 * printer->printerVariables.settings.movement.step_per_Unit.e0);
    *command_e1 = static_cast<int32_t>(de1 * printer->printerVariables.settings.movement.step_per_Unit.e1);

    *command_f_x  = fx * printer->printerVariables.settings.movement.step_per_Unit.x / 60;
    *command_f_y  = fy * printer->printerVariables.settings.movement.step_per_Unit.y / 60;
    *command_f_z  = fz * printer->printerVariables.settings.movement.step_per_Unit.z / 60;
    *command_f_e0 = fe0 * printer->printerVariables.settings.movement.step_per_Unit.e0 / 60;
    *command_f_e1 = fe1 * printer->printerVariables.settings.movement.step_per_Unit.e1 / 60;

    usleep(10);
    setFlags(flags_in_num, flags_in_run_command, true);
    printCommands();

    usleep(100);
    printTestParameters();

    while (!getFlags(flags_out_num, flags_out_command_finish)) {
        usleep(1000);
    }
    usleep(10);
    bool fin, err2, err1;
    err2 = getFlags(flags_out_num, flags_out_driving_error);
    err1 = getFlags(flags_out_num, flags_out_command_error);
    fin = getFlags(flags_out_num, flags_out_command_finish);

    setFlags(flags_in_num, flags_in_run_command, false);

    usleep(2);

    *command_type = 0;
    *command_x = 0;
    *command_y = 0;
    *command_z = 0;
    *command_e0 = 0;
    *command_e1 = 0;
    *command_f_x  = 0;
    *command_f_y  = 0;
    *command_f_z  = 0;
    *command_f_e0 = 0;
    *command_f_e1 = 0;
    cout << "moveExtrude answer: " << (4 * err2 + 2 * err1 + fin) << endl;
    return (4 * err2 + 2 * err1 + fin);
}

int32_t MechanicsController::setAbsolute() { //G90
    *command_type = CODE_GCODE_G90;
    usleep(1);

    setFlags(flags_in_num, flags_in_run_command, true);

    while (!getFlags(flags_out_num, flags_out_command_finish)) {
        usleep(10);
    }
    usleep(100);
    bool fin, err;
    err = getFlags(flags_out_num, flags_out_command_error);
    fin = getFlags(flags_out_num, flags_out_command_finish);
    setFlags(flags_in_num, flags_in_run_command, false);
    *command_type = 0;

    return (2 * err + fin);
}

int32_t MechanicsController::setRelative() { //G91
    *command_type = CODE_GCODE_G91;
    usleep(1);

    setFlags(flags_in_num, flags_in_run_command, true);

    while (!getFlags(flags_out_num, flags_out_command_finish)) {
        usleep(10);
    }
    usleep(100);

    bool fin, err;
    err = getFlags(flags_out_num, flags_out_command_error);
    fin = getFlags(flags_out_num, flags_out_command_finish);
    setFlags(flags_in_num, flags_in_run_command, false);
    *command_type = 0;

    return (2 * err + fin);
}

int32_t MechanicsController::setCurrentPosition(bool x, bool y, bool z, bool e,
                                               float dx, float dy, float dz, float de) { //G92
    *command_type = CODE_GCODE_G92;

    float pos_x, pos_y, pos_z, pos_e0, pos_e1;
    getPositions(  pos_x, pos_y,
                    pos_z, pos_e0,
                    pos_e1);
    float new_x, new_y, new_z, new_e;
    if (x)
        new_x = dx * printer->printerVariables.settings.movement.step_per_Unit.x;
    else
        new_x = pos_x * printer->printerVariables.settings.movement.step_per_Unit.x;
    if (y)
        new_y = dy * printer->printerVariables.settings.movement.step_per_Unit.y;
    else
        new_y = pos_y * printer->printerVariables.settings.movement.step_per_Unit.y;
    if (z)
        new_z = dz * printer->printerVariables.settings.movement.step_per_Unit.z;
    else
        new_z = pos_z * printer->printerVariables.settings.movement.step_per_Unit.z;
    if (e)
        new_e = de * printer->printerVariables.settings.movement.step_per_Unit.e0;
    else
        if (extruderNumber == 0)
            new_e = pos_e0 * printer->printerVariables.settings.movement.step_per_Unit.e0;
        else
            new_e = pos_e1 * printer->printerVariables.settings.movement.step_per_Unit.e1;


    if (KINEMATICS == 0) {
        *command_x = static_cast<int32_t>(new_x + new_y);
        *command_y = static_cast<int32_t>(new_x - new_y);
    }
    else if (KINEMATICS == 1){
        *command_x = static_cast<int32_t>(new_x);
        *command_y = static_cast<int32_t>(new_y);
    }

    *command_z = static_cast<int32_t>(new_z);
    switch(extruderNumber)
    {
        case 0:
            *command_e0 = new_e;
            *command_e1 = 0;
            break;
        case 1:
            *command_e0 = 0;
            *command_e1 = new_e;
            break;
        default:
            *command_e0 = new_e;
            *command_e1 = 0;
            break;
    }

    setFlags(flags_in_num, flags_in_set_new_position_x, true);
    setFlags(flags_in_num, flags_in_set_new_position_y, true);
    setFlags(flags_in_num, flags_in_set_new_position_z, true);
    setFlags(flags_in_num, flags_in_set_new_position_e0 + extruderNumber, true);
    usleep(1000);

    setFlags(flags_in_num, flags_in_set_new_position_x, false);
    setFlags(flags_in_num, flags_in_set_new_position_y, false);
    setFlags(flags_in_num, flags_in_set_new_position_z, false);
    setFlags(flags_in_num, flags_in_set_new_position_e0 + extruderNumber, false);

    usleep(2);

    //TODO: проверка на запись нужна

    *command_type = 0;
    *command_x = 0;
    *command_y = 0;
    *command_z = 0;
    *command_e0 = 0;
    *command_e1 = 0;

    return 1;
}

int32_t MechanicsController::changeExtruder(int32_t n){ //M6
    if (n < NUM_EXTRUDERS) {
        extruderNumber = n;
        return 1;
    }
    return 0;
}

int32_t MechanicsController::enableMotors() {
    *command_type = CODE_GCODE_M17;
    usleep(1);
    setFlags(flags_in_num, flags_in_run_command, true);

    while (!getFlags(flags_out_num, flags_out_command_finish)) {
        usleep(10);
    }
    usleep(100);
    bool fin, err;
    err = getFlags(flags_out_num, flags_out_command_error);
    fin = getFlags(flags_out_num, flags_out_command_finish);
    
    setFlags(flags_in_num, flags_in_run_command, false);
    *command_type = 0;

    return (2 * err + fin);
}

int32_t MechanicsController::disableMotors() {
    *command_type = CODE_GCODE_M18;
    usleep(1);
    setFlags(flags_in_num, flags_in_run_command, true);

    while (!getFlags(flags_out_num, flags_out_command_finish)) {
        usleep(10);
    }
    usleep(100);
    bool fin, err;
    err = getFlags(flags_out_num, flags_out_command_error);
    fin = getFlags(flags_out_num, flags_out_command_finish);
    
    setFlags(flags_in_num, flags_in_run_command, false);
    *command_type = 0;

    return (2 * err + fin);
}

int32_t MechanicsController::setAbsoluteExtruder() { //M82
    *command_type = CODE_GCODE_M82;
    usleep(1);

    setFlags(flags_in_num, flags_in_run_command, true);
    while (!getFlags(flags_out_num, flags_out_command_finish)) {
        usleep(10);
    }
    usleep(100);
    bool fin, err;
    err = getFlags(flags_out_num, flags_out_command_error);
    fin = getFlags(flags_out_num, flags_out_command_finish);

    setFlags(flags_in_num, flags_in_run_command, false);
    *command_type = 0;

    return (2 * err + fin);
}

int32_t MechanicsController::setRelativeExtruder() { //M83
    *command_type = CODE_GCODE_M83;
    usleep(1);

    setFlags(flags_in_num, flags_in_run_command, true);

    while (!getFlags(flags_out_num, flags_out_command_finish)) {
        usleep(10);
    }
    usleep(100);
    bool fin, err;
    err = getFlags(flags_out_num, flags_out_command_error);
    fin = getFlags(flags_out_num, flags_out_command_finish);
    
    setFlags(flags_in_num, flags_in_run_command, false);
    *command_type = 0;

    return (2 * err + fin);
}

int32_t MechanicsController::startCooling() { //M106
    *command_type = CODE_GCODE_M106;
    setFlags(flags_in_num, flags_in_run_command, true);
    usleep(100);

    while (!getFlags(flags_out_num, flags_out_command_finish)) {
        usleep(1000);
    }
    bool fin, err;
    err = getFlags(flags_out_num, flags_out_command_error);
    fin = getFlags(flags_out_num, flags_out_command_finish);
    
    setFlags(flags_in_num, flags_in_run_command, false);
    *command_type = 0;

    return (2 * err + fin);
}

int32_t MechanicsController::stopCooling() { //M107
    *command_type = CODE_GCODE_M107;
    setFlags(flags_in_num, flags_in_run_command, true);
    usleep(100);

    while (!getFlags(flags_out_num, flags_out_command_finish)) {
        usleep(1000);
    }
    bool fin, err;
    err = getFlags(flags_out_num, flags_out_command_error);
    fin = getFlags(flags_out_num, flags_out_command_finish);
    
    setFlags(flags_in_num, flags_in_run_command, false);
    *command_type = 0;

    return (2 * err + fin);
}

int32_t MechanicsController::setTemperature(int32_t heater, int32_t t) {
    if (heater == HEATER_BED) {
        *command_type = CODE_GCODE_M140;
        *command_x = HEATER_BED;
    }
    else {
        *command_type = CODE_GCODE_M104;
        *command_x = HEATER_E0 + extruderNumber;
    }
    *command_t = t;
    *command_dt = TEMP_DELTA;

    setFlags(flags_in_num, flags_in_run_command, true);
    usleep(100);

    while (!getFlags(flags_out_num, flags_out_command_finish)) {
        usleep(1000);
    }
    bool fin, err;
    err = getFlags(flags_out_num, flags_out_command_error);
    fin = getFlags(flags_out_num, flags_out_command_finish);
    
    setFlags(flags_in_num, flags_in_run_command, false);
    *command_type = 0;
    *command_x = 0;
    *command_t = 0;
    *command_dt = 0;

    return (2 * err + fin);
}

int32_t MechanicsController::holdTemperature(int32_t heater, int32_t t) {
    if (heater == HEATER_BED) {
        *command_type = CODE_GCODE_M190;
        *command_x = HEATER_BED;
    }
    else {
        *command_type = CODE_GCODE_M109;
        *command_x = HEATER_E0 + extruderNumber;
    }
    *command_t = t;
    *command_dt = TEMP_DELTA;

    setFlags(flags_in_num, flags_in_run_command, true);
    usleep(100);

    while (!getFlags(flags_out_num, flags_out_command_finish)) {
        usleep(1000);
    }
    bool fin, err;
    err = getFlags(flags_out_num, flags_out_command_error);
    fin = getFlags(flags_out_num, flags_out_command_finish);
    
    setFlags(flags_in_num, flags_in_run_command, false);
    *command_type = 0;
    *command_x = 0;
    *command_t = 0;
    *command_dt = 0;

    return (2 * err + fin);
}

void MechanicsController::getEndstopsStates(bool& xmin, bool& xmax,
                                             bool& ymin, bool& ymax,
                                             bool& zmin, bool& zmax,
                                             bool& barend)
{
    xmin    = getFlags(flags_out_num, flags_out_endstops_base + 0);
    xmax    = getFlags(flags_out_num, flags_out_endstops_base + 1);
    ymin    = getFlags(flags_out_num, flags_out_endstops_base + 2);
    ymax    = getFlags(flags_out_num, flags_out_endstops_base + 3);
    zmin    = getFlags(flags_out_num, flags_out_endstops_base + 4);
    zmax    = getFlags(flags_out_num, flags_out_endstops_base + 5);
    barend  = getFlags(flags_out_num, flags_out_endstops_base + 6);
}

void MechanicsController::getPositions(float& pos_x, float& pos_y,
                                        float& pos_z, float& pos_e0,
                                        float& pos_e1)
{
    if (KINEMATICS == 0) {
        pos_x  = ((*position_x) + (*position_y)) / (2 * printer->printerVariables.settings.movement.step_per_Unit.x);
        pos_y  = ((*position_x) - (*position_y)) / (2 * printer->printerVariables.settings.movement.step_per_Unit.y);
    }
    else if (KINEMATICS == 1){
        pos_x  = (*position_x) / (printer->printerVariables.settings.movement.step_per_Unit.x);
        pos_y  = (*position_x) / (printer->printerVariables.settings.movement.step_per_Unit.y);
    }

    pos_z  = (*position_z) / printer->printerVariables.settings.movement.step_per_Unit.z;
    pos_e0 = (*position_e0) / printer->printerVariables.settings.movement.step_per_Unit.e0;
    pos_e1 = (*position_e1) / printer->printerVariables.settings.movement.step_per_Unit.e1;
}

int32_t MechanicsController::getTemp(uint32_t n)
{
    if (n >=0 && n < HEATERS_NUM) {
        uint32_t a = zeroing(*temp[n], bit_count_uint32 - 12, 1) || zeroing(0xffffffff, 12, 0);
        return static_cast<int32_t>(a);
    }
    return -100;
}