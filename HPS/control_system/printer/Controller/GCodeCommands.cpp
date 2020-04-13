#include "PrinterController.h"

void PrinterController::gcode_G0(const Parameters& parameters) {
    float dx = 0, dy = 0, dz = 0;
    uint32_t f = DEFAULT_AXIS_SPEED[0];

    if (parameters.find('F'))
        f = static_cast<uint32_t>(parameters['F']);
    if (parameters.find('X')) {
        dx = parameters['X'];
    }
    if (parameters.find('Y')) {
        dy = parameters['Y'];
    }
    if (parameters.find('Z')) {
        dz = parameters['Z'];
    }
    mechanics.move(dx, dy, dz, f);

    bool xmin, xmax, ymin, ymax, zmin, zmax;
     mechanics.get_endstop_states(xmin, xmax, ymin, ymax, zmin, zmax);
    mechanics.set_current_position(xmin, ymin, zmin, false, 0, 0, 0, 0);
}

void PrinterController::gcode_G1(const Parameters& parameters) {
    float dx = 0, dy = 0, dz = 0, de = 0;
    uint32_t f = DEFAULT_AXIS_SPEED[0];

    if (parameters.find('F'))
        f = static_cast<uint32_t>(parameters['F']);
    if (parameters.find('X')) {
        dx = parameters['X'];
    }
    if (parameters.find('Y')) {
        dy = parameters['Y'];
    }
    if (parameters.find('Z')) {
        dz = parameters['Z'];
    }
    if (parameters.find('E')) {
        de = parameters['E'];
    }
    mechanics.move_extrude(dx, dy, dz, de, f);

    bool xmin, xmax, ymin, ymax, zmin, zmax;
     mechanics.get_endstop_states(xmin, xmax, ymin, ymax, zmin, zmax);
    mechanics.set_current_position(xmin, ymin, zmin, false, 0, 0, 0, 0);
}

void PrinterController::gcode_G4(const Parameters &parameters) {
    if (parameters.find('S')) {
        sleep(parameters['S']);
    } else
    {
        if (parameters.find('P')) {
            usleep(parameters['P']);
        }
    }
}

void PrinterController::gcode_G28(const Parameters& parameters) {
    gcode_G91(parameters);
    Parameters par;
    par.insert('F', HOMING_SPEED_FAST[0]);
    par.insert('X', parameters.find('X') * (-500.0));
    par.insert('Y', parameters.find('Y') * (-500.0));
    par.insert('Z', parameters.find('Z') * (-500.0));
    gcode_G0(par);

    Parameters par2;
    par.insert('F', HOMING_SPEED_SLOW[0]);
    par.insert('X', parameters.find('X') * (10));
    par.insert('Y', parameters.find('Y') * (10));
    par.insert('Z', parameters.find('Z') * (10));
    gcode_G0(par2);

    Parameters par3;
    par.insert('F', HOMING_SPEED_SLOW[0]);
    par.insert('X', parameters.find('X') * (-15));
    par.insert('Y', parameters.find('Y') * (-15));
    par.insert('Z', parameters.find('Z') * (-15));
    gcode_G0(par3);

    mechanics.set_current_position(true, true, true, false, 0, 0, 0, 0);
    gcode_G90(par3);
}

void PrinterController::gcode_G90(const Parameters& parameters) {
    mechanics.set_absolute();
}

void PrinterController::gcode_G91(const Parameters& parameters) {
    mechanics.set_relative();
}

void PrinterController::gcode_G92(const Parameters& parameters) {
    bool x = parameters.find('X');
    bool y = parameters.find('Y');
    bool z = parameters.find('Z');
    bool e = parameters.find('E');
    float dx, dy, dz, de;
    if (parameters.find('X'))
        dx = parameters['X'];
    if (parameters.find('Y'))
        dy = parameters['Y'];
    if (parameters.find('Z'))
        dz = parameters['Z'];
    if (parameters.find('E'))
        de = parameters['E'];

    mechanics.set_current_position(x, y, z, e,
            dx, dy, dz, de);
}

void PrinterController::gcode_M6(const Parameters& parameters) {
    if (parameters.find('T'))
        mechanics.change_extruder(parameters['T']);
}

void PrinterController::gcode_M17(const Parameters& parameters) {
    mechanics.enable_steppers();
}

void PrinterController::gcode_M18(const Parameters& parameters) {
    mechanics.disable_steppers();
}

void PrinterController::gcode_M82(const Parameters& parameters) {
    mechanics.set_absolute_extruder();
}

void PrinterController::gcode_M83(const Parameters& parameters) {
    mechanics.set_relative_extruder();
}

void PrinterController::gcode_M104(const Parameters& parameters) {
    if (parameters.find('S')) {
        mechanics.set_temperature(HEATER_E0, parameters['S']);
    }
}

void PrinterController::gcode_M106(const Parameters& parameters) {
    mechanics.start_cooling();
}

void PrinterController::gcode_M107(const Parameters& parameters) {
    mechanics.stop_cooling();
}

void PrinterController::gcode_M109(const Parameters& parameters) {
    if (parameters.find('S')) {
        mechanics.hold_temperature(HEATER_E0, parameters['S']);
    }
}

void PrinterController::gcode_M140(const Parameters& parameters) {
    if (parameters.find('S')) {
        mechanics.set_temperature(HEATER_BED, parameters['S']);
    }
}

void PrinterController::gcode_M190(const Parameters& parameters) {
    if (parameters.find('S')) {
        mechanics.hold_temperature(HEATER_BED, parameters['S']);
    }
}
