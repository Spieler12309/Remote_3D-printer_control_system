#include "MechanicsController.h"
#include "PrinterController.h"

void MechanicsController::move(float dx, float dy, float dz, uint32_t f) { //G0

    *command_type = CODE_GCODE_G0;

    *command_x = static_cast<int32_t>(dx * DEFAULT_AXIS_STEPS_PER_UNIT[0] + dy * DEFAULT_AXIS_STEPS_PER_UNIT[1]);
    *command_y = static_cast<int32_t>(dx * DEFAULT_AXIS_STEPS_PER_UNIT[0] - dy * DEFAULT_AXIS_STEPS_PER_UNIT[1]);
    *command_z = static_cast<int32_t>(dz * DEFAULT_AXIS_STEPS_PER_UNIT[2]);
    *command_f = f * DEFAULT_AXIS_STEPS_PER_UNIT[0] / 60;

    set_flags(flags_in_num, flags_in_run_command, true);
    usleep(100);

    while (!get_flags(flags_out_num, flags_out_command_finish))
    {
        usleep(1000);
    }
    set_flags(flags_in_num, flags_in_run_command, false);

    usleep(2);

    *command_type = 0;
    *command_x = 0;
    *command_y = 0;
    *command_z = 0;
    *command_f = 0;
}

void MechanicsController::move_extrude(float dx, float dy, float dz, float de, uint32_t f){ //G1
    *command_type = CODE_GCODE_G0;

    *command_x = static_cast<int32_t>(dx * DEFAULT_AXIS_STEPS_PER_UNIT[0] + dy * DEFAULT_AXIS_STEPS_PER_UNIT[1]);
    *command_y = static_cast<int32_t>(dx * DEFAULT_AXIS_STEPS_PER_UNIT[0] - dy * DEFAULT_AXIS_STEPS_PER_UNIT[1]);
    *command_z = static_cast<int32_t>(dz * DEFAULT_AXIS_STEPS_PER_UNIT[2]);
    switch(extruder_number)
    {
        case 0:
            *command_e0 = static_cast<int32_t>(de * DEFAULT_AXIS_STEPS_PER_UNIT[3]);
            *command_e1 = 0;
            break;
        case 1:
            *command_e0 = 0;
            *command_e1 = static_cast<int32_t>(de * DEFAULT_AXIS_STEPS_PER_UNIT[4]);
            break;
        default:
            *command_e0 = static_cast<int32_t>(de * DEFAULT_AXIS_STEPS_PER_UNIT[3]);
            *command_e1 = 0;
            break;
    }
    *command_f = f * DEFAULT_AXIS_STEPS_PER_UNIT[0] / 60;

    set_flags(flags_in_num, flags_in_run_command, true);
    usleep(100);

    while (!get_flags(flags_out_num, flags_out_command_finish))
    {
        usleep(1000);
    }
    set_flags(flags_in_num, flags_in_run_command, false);

    usleep(2);

    *command_type = 0;
    *command_x = 0;
    *command_y = 0;
    *command_z = 0;
    *command_e0 = 0;
    *command_e1 = 0;
    *command_f = 0;
}

void MechanicsController::set_absolute() { //G90
    *command_type = CODE_GCODE_G90;
    set_flags(flags_in_num, flags_in_run_command, true);
    usleep(100);

    while (!get_flags(flags_out_num, flags_out_command_finish))
    {
        usleep(1000);
    }
    set_flags(flags_in_num, flags_in_run_command, false);
    *command_type = 0;
}

void MechanicsController::set_relative() { //G91
    *command_type = CODE_GCODE_G91;
    set_flags(flags_in_num, flags_in_run_command, true);
    usleep(100);

    while (!get_flags(flags_out_num, flags_out_command_finish))
    {
        usleep(1000);
    }
    set_flags(flags_in_num, flags_in_run_command, false);
    *command_type = 0;
}

void MechanicsController::set_current_position(bool x, bool y, bool z, bool e,
                                               float dx, float dy, float dz, float de) { //G92
    *command_type = CODE_GCODE_G92;

    int32_t pos_x, pos_y, pos_z, pos_e0, pos_e1;
    get_positions(pos_x, pos_y,
              pos_z, pos_e0,
              pos_e1);
    float new_x, new_y, new_z, new_e;
    if (x)
        new_x = dx * DEFAULT_AXIS_STEPS_PER_UNIT[0];
    else
        new_x = (pos_x + pos_y) / 2;
    if (y)
        new_y = dy * DEFAULT_AXIS_STEPS_PER_UNIT[1];
    else
        new_y = (pos_x - pos_y) / 2;
    if (z)
        new_z = dz * DEFAULT_AXIS_STEPS_PER_UNIT[2];
    else
        new_z = pos_z;
    if (z)
        new_e = de * DEFAULT_AXIS_STEPS_PER_UNIT[2];
    else
        if (extruder_number == 0)
            new_e = pos_e0;
        else
            new_e = pos_e1;

    *command_x = static_cast<int32_t>(new_x + new_y);
    *command_y = static_cast<int32_t>(new_x - new_y);
    *command_z = static_cast<int32_t>(dz);
    switch(extruder_number)
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

    set_flags(flags_in_num, flags_in_set_new_position_x, true);
    set_flags(flags_in_num, flags_in_set_new_position_y, true);
    set_flags(flags_in_num, flags_in_set_new_position_z, true);
    set_flags(flags_in_num, flags_in_set_new_position_e0 + extruder_number, true);
    usleep(10000);

    set_flags(flags_in_num, flags_in_set_new_position_x, false);
    set_flags(flags_in_num, flags_in_set_new_position_y, false);
    set_flags(flags_in_num, flags_in_set_new_position_z, false);
    set_flags(flags_in_num, flags_in_set_new_position_e0 + extruder_number, false);

    usleep(2);

    *command_type = 0;
    *command_x = 0;
    *command_y = 0;
    *command_z = 0;
    *command_e0 = 0;
    *command_e1 = 0;
}

void MechanicsController::change_extruder(int32_t n){ //M6
    if (n < NUM_EXTRUDERS)
        extruder_number = n;
}

void MechanicsController::enable_steppers() {
    *command_type = CODE_GCODE_M17;
    set_flags(flags_in_num, flags_in_run_command, true);
    usleep(100);

    while (!get_flags(flags_out_num, flags_out_command_finish))
    {
        usleep(1000);
    }
    set_flags(flags_in_num, flags_in_run_command, false);
    *command_type = 0;
}

void MechanicsController::disable_steppers() {
    *command_type = CODE_GCODE_M18;
    set_flags(flags_in_num, flags_in_run_command, true);
    usleep(100);

    while (!get_flags(flags_out_num, flags_out_command_finish))
    {
        usleep(1000);
    }
    set_flags(flags_in_num, flags_in_run_command, false);
    *command_type = 0;
}

void MechanicsController::set_absolute_extruder() { //M82
    *command_type = CODE_GCODE_M82;
    set_flags(flags_in_num, flags_in_run_command, true);
    usleep(100);

    while (!get_flags(flags_out_num, flags_out_command_finish))
    {
        usleep(1000);
    }
    set_flags(flags_in_num, flags_in_run_command, false);
    *command_type = 0;
}

void MechanicsController::set_relative_extruder() { //M83
    *command_type = CODE_GCODE_M83;
    set_flags(flags_in_num, flags_in_run_command, true);
    usleep(100);

    while (!get_flags(flags_out_num, flags_out_command_finish))
    {
        usleep(1000);
    }
    set_flags(flags_in_num, flags_in_run_command, false);
    *command_type = 0;
}

void MechanicsController::start_cooling() { //M106
    *command_type = CODE_GCODE_M106;
    set_flags(flags_in_num, flags_in_run_command, true);
    usleep(100);

    while (!get_flags(flags_out_num, flags_out_command_finish))
    {
        usleep(1000);
    }
    set_flags(flags_in_num, flags_in_run_command, false);
    *command_type = 0;
}

void MechanicsController::stop_cooling() { //M107
    *command_type = CODE_GCODE_M107;
    set_flags(flags_in_num, flags_in_run_command, true);
    usleep(100);

    while (!get_flags(flags_out_num, flags_out_command_finish))
    {
        usleep(1000);
    }
    set_flags(flags_in_num, flags_in_run_command, false);
    *command_type = 0;
}

void MechanicsController::set_temperature(int32_t heater, int32_t t) {
    if (heater == HEATER_BED) {
        *command_type = CODE_GCODE_M140;
        *command_x = HEATER_BED;
    }
    else {
        *command_type = CODE_GCODE_M104;
        *command_x = HEATER_E0 + extruder_number;
    }
    *command_t = t;
    *command_dt = TEMP_DELTA;

    set_flags(flags_in_num, flags_in_run_command, true);
    usleep(100);

    while (!get_flags(flags_out_num, flags_out_command_finish))
    {
        usleep(1000);
    }
    set_flags(flags_in_num, flags_in_run_command, false);
    *command_type = 0;
    *command_x = 0;
    *command_t = 0;
    *command_dt = 0;
}

void MechanicsController::hold_temperature(int32_t heater, int32_t t) {
    if (heater == HEATER_BED) {
        *command_type = CODE_GCODE_M190;
        *command_x = HEATER_BED;
    }
    else {
        *command_type = CODE_GCODE_M109;
        *command_x = HEATER_E0 + extruder_number;
    }
    *command_t = t;
    *command_dt = TEMP_DELTA;

    set_flags(flags_in_num, flags_in_run_command, true);
    usleep(100);

    while (!get_flags(flags_out_num, flags_out_command_finish))
    {
        usleep(1000);
    }
    set_flags(flags_in_num, flags_in_run_command, false);
    *command_type = 0;
    *command_x = 0;
    *command_t = 0;
    *command_dt = 0;
}
