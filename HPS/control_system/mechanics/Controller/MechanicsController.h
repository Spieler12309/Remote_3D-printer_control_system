#ifndef INC_3D_PRINTER_MECHANICSCONTROLLER_H
#define INC_3D_PRINTER_MECHANICSCONTROLLER_H

#define HW_REGS_BASE (ALT_STM_OFST)
#define HW_REGS_SPAN (0x04000000)
#define HW_REGS_MASK (HW_REGS_SPAN - 1)

#define bit_count_uint32 32

#include <inttypes.h>
#include <cmath>
#include <fcntl.h>
#include <string>

#include "hwlib.h"
#include "unistd.h"
#include <stdio.h>

// sys
#include "sys/mman.h"

// socal
#include "socal.h"
#include "hps.h"
#include "alt_gpio.h"

#include "HPS_Header.h"
#include "configuration.h"
#include "GCODE_CODES.h"

using namespace std;

//Flags
//=======================================================
// Описание битов флагов
// flags_in[0]:     Выполнить команду с кодом из command_type
// flags_in[1]:     Инверсия двигателя X
// flags_in[2]:     Инверсия двигателя Y
// flags_in[3]:     Инверсия двигателя Z
// flags_in[4]:     Инверсия двигателя E0
// flags_in[5]:     Инверсия двигателя E1
// flags_in[6]:     Инверсия концевого переключателя 0 (xmin)
// flags_in[7]:     Инверсия концевого переключателя 1 (xmax)
// flags_in[8]:     Инверсия концевого переключателя 2 (ymin)
// flags_in[9]:     Инверсия концевого переключателя 3 (ymax)
// flags_in[10]:    Инверсия концевого переключателя 4 (zmin)
// flags_in[11]:    Инверсия концевого переключателя 5 (zmax)
// flags_in[12]:    Инверсия концевого переключателя 6 (bar_end)
// flags_in[13]:    Задание новой позиции для оси X
// flags_in[14]:    Задание новой позиции для оси Y
// flags_in[15]:    Задание новой позиции для оси Z
// flags_in[16]:    Задание новой позиции для оси E0
// flags_in[17]:    Задание новой позиции для оси E1
// -------------
// flags_out[0]:    Данные с концевого переключателя 0 (xmin)
// flags_out[1]:    Данные с концевого переключателя 1 (xmax)
// flags_out[2]:    Данные с концевого переключателя 2 (ymin)
// flags_out[3]:    Данные с концевого переключателя 3 (ymax)
// flags_out[4]:    Данные с концевого переключателя 4 (zmin)
// flags_out[5]:    Данные с концевого переключателя 5 (zmax)
// flags_out[6]:    Данные с концевого переключателя 6 (bar_end)
// flags_out[7]:    Окончание выполнения команды GCODE
// flags_out[12]:   Идет нагрев нагревателя 0
// flags_out[13]:   Идет нагрев нагревателя 1
// flags_out[14]:   Идет нагрев нагревателя 2
// flags_out[15]:   Данные с KEY[0]
// flags_out[16]:   Данные с KEY[1]
// flags_out[17]:   Данные с SW[0]
// flags_out[18]:   Данные с SW[1]
// flags_out[19]:   Данные с SW[2]
// flags_out[20]:   Данные с SW[3]
// flags_out[21]:   Ошибка выполнения команды
// flags_out[22]:   Ошибка движения
//=======================================================

//flags_in
const uint32_t flags_in_num                     = 0;
const uint32_t flags_in_run_command             = 0;
const uint32_t flags_in_inversion_steppers_base = 1;
const uint32_t flags_in_inversion_stepper_x     = 1;
const uint32_t flags_in_inversion_stepper_y     = 2;
const uint32_t flags_in_inversion_stepper_z     = 3;
const uint32_t flags_in_inversion_stepper_e0    = 4;
const uint32_t flags_in_inversion_stepper_e1    = 5;
const uint32_t flags_in_inversion_endstops_base = 6;
const uint32_t flags_in_inversion_xmin          = 6;
const uint32_t flags_in_inversion_xmax          = 7;
const uint32_t flags_in_inversion_ymin          = 8;
const uint32_t flags_in_inversion_ymax          = 9;
const uint32_t flags_in_inversion_zmin          = 10;
const uint32_t flags_in_inversion_zmax          = 11;
const uint32_t flags_in_inversion_bar_end       = 12;
const uint32_t flags_in_set_new_position_base   = 13;
const uint32_t flags_in_set_new_position_x      = 13;
const uint32_t flags_in_set_new_position_y      = 14;
const uint32_t flags_in_set_new_position_z      = 15;
const uint32_t flags_in_set_new_position_e0     = 16;
const uint32_t flags_in_set_new_position_e1     = 17;
const uint32_t flags_in_reset                   = 18;

//flags_out
const uint32_t flags_out_num                    = 1;
const uint32_t flags_out_endstops_base          = 0;
const uint32_t flags_out_xmin                   = 0;
const uint32_t flags_out_xmax                   = 1;
const uint32_t flags_out_ymin                   = 2;
const uint32_t flags_out_ymax                   = 3;
const uint32_t flags_out_zmin                   = 4;
const uint32_t flags_out_zmax                   = 5;
const uint32_t flags_out_bar_end                = 6;
const uint32_t flags_out_command_finish         = 7;
const uint32_t flags_out_heaters_base           = 12;
const uint32_t flags_out_heater_0               = 12;
const uint32_t flags_out_heater_1               = 13;
const uint32_t flags_out_heater_2               = 14;
const uint32_t flags_out_key_base               = 15;
const uint32_t flags_out_key_0                  = 15;
const uint32_t flags_out_key_1                  = 16;
const uint32_t flags_out_sw_base                = 17;
const uint32_t flags_out_sw_0                   = 17;
const uint32_t flags_out_sw_1                   = 18;
const uint32_t flags_out_sw_2                   = 19;
const uint32_t flags_out_sw_3                   = 20;
const uint32_t flags_out_command_error          = 21;
const uint32_t flags_out_driving_error          = 22;
const uint32_t flags_out_position_type          = 23;
const uint32_t flags_out_position_extruder_type = 24;

class PrinterController;

// Класс отвечает за механику, взаимодействие с verilog.
class MechanicsController {

    //Вспомогательные методы
    uint32_t zeroing(uint32_t number, uint32_t count, uint32_t direction);
    uint32_t createNumber(bool state, uint32_t count);

    template <typename T1>
    void printTable(string title,
                    int32_t colNum, int32_t rowNum,
                    string colNames[], string rowNames[],
                    int32_t colWidth[],
                    T1 data[]);

    template <typename T2>
    T2* createVariable(void* virtual_base, unsigned long base);

    //переменные
    int fd = -1;
    void* virtual_base;
    uint32_t *command_type;
    int32_t  *command_x;
    int32_t  *command_y;
    int32_t  *command_z;
    int32_t  *command_e0;
    int32_t  *command_e1;
    uint32_t *command_f_x;
    uint32_t *command_f_y;
    uint32_t *command_f_z;
    uint32_t *command_f_e0;
    uint32_t *command_f_e1;
    int32_t  *command_t;
    int32_t  *command_dt;
    uint32_t *flags_in;
    uint32_t *flags_out;
    uint32_t *settingsMaxSpeedX;
    uint32_t *settingsMaxSpeedY;
    uint32_t *settingsMaxSpeedZ;
    uint32_t *settingsMaxSpeedE0;
    uint32_t *settingsMaxSpeedE1;
    uint32_t *settingsAccelerationX;
    uint32_t *settingsAccelerationY;
    uint32_t *settingsAccelerationZ;
    uint32_t *settingsAccelerationE0;
    uint32_t *settingsAccelerationE1;
    uint32_t *settingsJerkX;
    uint32_t *settingsJerkY;
    uint32_t *settingsJerkZ;
    uint32_t *settingsJerkE0;
    uint32_t *settingsJerkE1;
    int32_t  *settings_max_temp_e0;
    int32_t  *settings_max_temp_e1;
    int32_t  *settings_max_temp_bed;
    int32_t  *temp[2];

    int32_t  *position_x;
    int32_t  *position_y;
    int32_t  *position_z;
    int32_t  *position_e0;
    int32_t  *position_e1;

    //flags

    void setFlags(uint32_t flag_type, uint32_t bit, bool state);



    //test variables
    uint32_t *params_x_0;
    uint32_t *params_x_1;
    uint32_t *params_x_2;
    uint32_t *params_x_3;
    uint32_t *params_x_4;

    uint32_t *params_y_0;
    uint32_t *params_y_1;
    uint32_t *params_y_2;
    uint32_t *params_y_3;
    uint32_t *params_y_4;

    uint32_t *params_z_0;
    uint32_t *params_z_1;
    uint32_t *params_z_2;
    uint32_t *params_z_3;
    uint32_t *params_z_4;

    uint32_t *params_e0_0;
    uint32_t *params_e0_1;
    uint32_t *params_e0_2;
    uint32_t *params_e0_3;
    uint32_t *params_e0_4;

    uint32_t *params_e1_0;
    uint32_t *params_e1_1;
    uint32_t *params_e1_2;
    uint32_t *params_e1_3;
    uint32_t *params_e1_4;


    uint32_t *new_params_x_0;
    uint32_t *new_params_x_1;
    uint32_t *new_params_x_2;
    uint32_t *new_params_x_3;
    uint32_t *new_params_x_4;

    uint32_t *new_params_y_0;
    uint32_t *new_params_y_1;
    uint32_t *new_params_y_2;
    uint32_t *new_params_y_3;
    uint32_t *new_params_y_4;

    uint32_t *new_params_z_0;
    uint32_t *new_params_z_1;
    uint32_t *new_params_z_2;
    uint32_t *new_params_z_3;
    uint32_t *new_params_z_4;

    uint32_t *new_params_e0_0;
    uint32_t *new_params_e0_1;
    uint32_t *new_params_e0_2;
    uint32_t *new_params_e0_3;
    uint32_t *new_params_e0_4;

    uint32_t *new_params_e1_0;
    uint32_t *new_params_e1_1;
    uint32_t *new_params_e1_2;
    uint32_t *new_params_e1_3;
    uint32_t *new_params_e1_4;


    uint32_t *timings_x_0;
    uint32_t *timings_x_1;
    uint32_t *timings_x_2;
    uint32_t *timings_x_3;

    uint32_t *timings_y_0;
    uint32_t *timings_y_1;
    uint32_t *timings_y_2;
    uint32_t *timings_y_3;

    uint32_t *timings_z_0;
    uint32_t *timings_z_1;
    uint32_t *timings_z_2;
    uint32_t *timings_z_3;

    uint32_t *timings_e0_0;
    uint32_t *timings_e0_1;
    uint32_t *timings_e0_2;
    uint32_t *timings_e0_3;

    uint32_t *timings_e1_0;
    uint32_t *timings_e1_1;
    uint32_t *timings_e1_2;
    uint32_t *timings_e1_3;


    uint32_t *max_params_0;
    uint32_t *max_params_1;
    uint32_t *max_params_2;
    uint32_t *max_params_3;
    uint32_t *max_params_4;

    uint32_t *max_timings_0;
    uint32_t *max_timings_1;
    uint32_t *max_timings_2;
    uint32_t *max_timings_3;

    uint32_t  *step_x_now;
    uint32_t  *step_y_now;
    uint32_t  *step_z_now;
    uint32_t  *step_e0_now;
    uint32_t  *step_e1_now;

public:
    PrinterController* printer;

    MechanicsController();

    void initMem();
    void setSettings();
    void setTestParameters();

    void printTestParameters();
    void printSettings();
    void printCommands();

    int32_t extruderNumber = 0;


    //Методы для выполнения GCODE команд
    int32_t move(float dx, float dy, float dz, uint32_t fx, uint32_t fy, uint32_t fz); //G0
    int32_t moveExtrude(float dx, float dy, float dz, float de0, float de1, uint32_t fx, uint32_t fy, uint32_t fz, uint32_t fe0, uint32_t fe1); //G1
    int32_t setAbsolute(); //G90
    int32_t setRelative(); //G91
    int32_t setCurrentPosition(bool x, bool y, bool z, bool e,
                                 float dx, float dy, float dz, float de); //G92

    int32_t changeExtruder(int32_t n); //M6
    int32_t enableMotors(); //M17
    int32_t disableMotors(); //M18
    int32_t setAbsoluteExtruder(); //M82
    int32_t setRelativeExtruder(); //M83
    int32_t startCooling(); //M106
    int32_t stopCooling(); //M107
    int32_t setTemperature(int32_t heater, int32_t t); //M104, M140
    int32_t holdTemperature(int32_t heater, int32_t t); //M109, M190

    //Вспомогательные методы
    void getEndstopsStates(bool& xmin, bool& xmax,
                            bool& ymin, bool& ymax,
                            bool& zmin, bool& zmax,
                            bool& barend);

    void getPositions(float& pos_x, float& pos_y,
                       float& pos_z, float& pos_e0,
                       float& pos_e1);

    int32_t getTemp(uint32_t n);

    bool getFlags(uint32_t flag_type, uint32_t bit);
};

#endif //INC_3D_PRINTER_MECHANICSCONTROLLER_H