#ifndef INC_3D_PRINTER_CONFIGURATION_H
#define INC_3D_PRINTER_CONFIGURATION_H

#include <cstdint>

enum {CoreXY, Simple};
enum {mm, steps};
enum {perMinute, perSecond};

static const int32_t KINEMATICS = CoreXY;

static const int32_t NUM_EXTRUDERS                  = 2;
static const int32_t NUM_STEPPERS                   = 5;
static const int32_t NUM_ENDSTOPS                   = 6;
static const int32_t NUM_BARENDS                    = 2;
//Инверсия двигателей                                           X      Y      Z     E0    E1
static const bool STEPPERS_INVERTING[NUM_STEPPERS]          = {false, false, false, true, true};
//Инверсия концевиков                                          xmin  xmax  ymin  ymax  zmin  zmax
static const bool ENDSTOPS_INVERTING[NUM_ENDSTOPS]          = {true, true, true, true, true, true};
static const bool BAR_END_ENDSTOP_INVERTING[NUM_BARENDS]    = {true, true};

static const float DEFAULT_AXIS_STEPS_PER_UNIT[5] = {(200*16)/(2.0*20), (200*16)/(2.0*20), 200*8/2.0, 92.0, 92.0}; //микрошагов/мм

static const int32_t  HEATERS_NUM           = 3;
static const float    PID[3]                = {32.5, 3.57, 73.89};
static const int32_t  TEMP_DELTA            = 1;
static const int32_t  MAX_TEMP[HEATERS_NUM] = {300, 300, 300};
static const uint32_t HEATER_E0             = 0;
static const uint32_t HEATER_E1             = 1;
static const uint32_t HEATER_BED            = 2;

// Homing speeds (mm/m)
static const float HOMING_SPEED_FAST[3] = {8000, 8000, 2000};
static const float HOMING_SPEED_SLOW[3] = {1000, 1000, 500};

static const float MAX_SIZE[3]          = {250, 250, 250};

static const float DEFAULT_AXIS_SPEED[5] = {6000, 6000, 2000, 200, 200}; //стандартная скорость мм/мин
static const float MAX_AXIS_SPEED[5] = {8000, 8000, 2000, 400, 400}; //максимальная скорость мм/мин
static const float MAX_AXIS_ACCELERATION[5] = {2000 * 3600, 2000 * 3600, 1000 * 3600, 100 * 3600, 100 * 3600}; //максимальное ускорение мм/мин^2
static const float MAX_AXIS_JERK[5] = {1000, 1000, 500, 200, 200}; //максимальные рывки мм/мин

#endif //INC_3D_PRINTER_CONFIGURATION_H