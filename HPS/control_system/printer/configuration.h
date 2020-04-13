#ifndef INC_3D_PRINTER_CONFIGURATION_H
#define INC_3D_PRINTER_CONFIGURATION_H

#include <cstdint>
static const int32_t NUM_EXTRUDERS                  = 2;
static const int32_t NUM_STEPPERS                   = 5;
static const int32_t NUM_ENDSTOPS                   = 6;
//Инверсия двигателей                                    X      Y      Z     E0    E1
static const bool STEPPERS_INVERTING[NUM_STEPPERS]  = {false, false, false, true, true};
//Инверсия концевиков                                  xmin  xmax  ymin  ymax  zmin  zmax
static const bool ENDSTOPS_INVERTING[NUM_ENDSTOPS]  = {true, true, true, true, true, true};
static const bool BAR_END_ENDSTOP_INVERTING         = true; // set to true to invert the logic of the endstop.

static const float DEFAULT_AXIS_STEPS_PER_UNIT[5] = {(200*16)/(2.0*20), (200*16)/(2.0*20), 200*8/2.0, 92.0, 92.0}; //микрошагов/мм

static const int32_t  HEATERS_NUM           = 3;
static const int32_t  TEMP_DELTA            = 1;
static const int32_t  MAX_TEMP[HEATERS_NUM] = {300, 300, 300};
static const uint32_t HEATER_E0             = 0;
static const uint32_t HEATER_E1             = 1;
static const uint32_t HEATER_BED            = 2;

// Homing speeds (mm/m)
static const float HOMING_SPEED_FAST[3] = {8000, 8000, 2000};
static const float HOMING_SPEED_SLOW[3] = {1000, 1000, 500};

static const float HOMING_SPEED_FAST_MICROSTEPS[3] = {HOMING_SPEED_FAST[0] * DEFAULT_AXIS_STEPS_PER_UNIT[0],
                                                      HOMING_SPEED_FAST[1] * DEFAULT_AXIS_STEPS_PER_UNIT[1],
                                                      HOMING_SPEED_FAST[2] * DEFAULT_AXIS_STEPS_PER_UNIT[2]};
static const float HOMING_SPEED_SLOW_MICROSTEPS[3] = {HOMING_SPEED_SLOW[0] * DEFAULT_AXIS_STEPS_PER_UNIT[0],
                                                      HOMING_SPEED_SLOW[1] * DEFAULT_AXIS_STEPS_PER_UNIT[1],
                                                      HOMING_SPEED_SLOW[2] * DEFAULT_AXIS_STEPS_PER_UNIT[2]};



static const float DEFAULT_AXIS_SPEED[5] = {6000, 6000, 2000, 200, 200}; //стандартная скорость мм/мин
static const float MAX_AXIS_SPEED[5] = {8000, 8000, 2000, 400, 400}; //максимальная скорость мм/мин
static const float MAX_AXIS_ACCELERATION[5] = {2000 * 3600, 2000 * 3600, 1000 * 3600, 100 * 3600, 100 * 3600}; //максимальное ускорение мм/мин^2
static const float MAX_AXIS_JERK[5] = {1000, 1000, 500, 200, 200}; //максимальные рывки мм/мин

static const float DEFAULT_AXIS_SPEED_MICROSTEPS[5] =     {DEFAULT_AXIS_SPEED[0] * DEFAULT_AXIS_STEPS_PER_UNIT[0] / 60,
                                                          DEFAULT_AXIS_SPEED[1] * DEFAULT_AXIS_STEPS_PER_UNIT[1] / 60,
                                                          DEFAULT_AXIS_SPEED[2] * DEFAULT_AXIS_STEPS_PER_UNIT[2] / 60,
                                                          DEFAULT_AXIS_SPEED[3] * DEFAULT_AXIS_STEPS_PER_UNIT[3] / 60,
                                                          DEFAULT_AXIS_SPEED[4] * DEFAULT_AXIS_STEPS_PER_UNIT[4] / 60}; //максимальная скорость микрошагов/с
static const float MAX_AXIS_SPEED_MICROSTEPS[5] =        {MAX_AXIS_SPEED[0] * DEFAULT_AXIS_STEPS_PER_UNIT[0] / 60,
                                                          MAX_AXIS_SPEED[1] * DEFAULT_AXIS_STEPS_PER_UNIT[1] / 60,
                                                          MAX_AXIS_SPEED[2] * DEFAULT_AXIS_STEPS_PER_UNIT[2] / 60,
                                                          MAX_AXIS_SPEED[3] * DEFAULT_AXIS_STEPS_PER_UNIT[3] / 60,
                                                          MAX_AXIS_SPEED[4] * DEFAULT_AXIS_STEPS_PER_UNIT[4] / 60}; //максимальная скорость микрошагов/с
static const float MAX_AXIS_ACCELERATION_MICROSTEPS[5] = {MAX_AXIS_ACCELERATION[0] * DEFAULT_AXIS_STEPS_PER_UNIT[0] / 3600,
                                                          MAX_AXIS_ACCELERATION[1] * DEFAULT_AXIS_STEPS_PER_UNIT[1] / 3600,
                                                          MAX_AXIS_ACCELERATION[2] * DEFAULT_AXIS_STEPS_PER_UNIT[2] / 3600,
                                                          MAX_AXIS_ACCELERATION[3] * DEFAULT_AXIS_STEPS_PER_UNIT[3] / 3600,
                                                          MAX_AXIS_ACCELERATION[4] * DEFAULT_AXIS_STEPS_PER_UNIT[4] / 3600}; //максимальное ускорение микрошагов/с^2
static const float MAX_AXIS_JERK_MICROSTEPS[5] =         {MAX_AXIS_JERK[0] * DEFAULT_AXIS_STEPS_PER_UNIT[0] / 60,
                                                          MAX_AXIS_JERK[1] * DEFAULT_AXIS_STEPS_PER_UNIT[1] / 60,
                                                          MAX_AXIS_JERK[2] * DEFAULT_AXIS_STEPS_PER_UNIT[2] / 60,
                                                          MAX_AXIS_JERK[3] * DEFAULT_AXIS_STEPS_PER_UNIT[3] / 60,
                                                          MAX_AXIS_JERK[4] * DEFAULT_AXIS_STEPS_PER_UNIT[4] / 60}; //максимальные рывки микрошагов/с

#endif //INC_3D_PRINTER_CONFIGURATION_H