#ifndef INC_3D_PRINTER_MECHANICSCONTROLLER_H
#define INC_3D_PRINTER_MECHANICSCONTROLLER_H

#define HW_REGS_BASE (ALT_STM_OFST)
#define HW_REGS_SPAN (0x04000000)
#define HW_REGS_MASK (HW_REGS_SPAN - 1)

#define bit_count_uint32 32

#include <inttypes.h>
#include <cmath>
#include <fcntl.h>

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

class PrinterController;

// Класс отвечает за механику, взаимодействие с verilog.
class MechanicsController {

    //Вспомогательные методы
    uint32_t zeroing(uint32_t number, uint32_t count, uint32_t direction);
    uint32_t create_number(bool state, uint32_t count);

    //переменные
    int fd;
    void* virtual_base;
    uint32_t *command_type;
    int32_t  *command_x;
    int32_t  *command_y;
    int32_t  *command_z;
    int32_t  *command_e0;
    int32_t  *command_e1;
    uint32_t *command_f;
    int32_t  *command_t;
    int32_t  *command_dt;
    uint32_t *flags_in;
    uint32_t *flags_out;
    uint32_t *settings_max_speed_x;
    uint32_t *settings_max_speed_y;
    uint32_t *settings_max_speed_z;
    uint32_t *settings_max_speed_e0;
    uint32_t *settings_max_speed_e1;
    uint32_t *settings_acceleration_x;
    uint32_t *settings_acceleration_y;
    uint32_t *settings_acceleration_z;
    uint32_t *settings_acceleration_e0;
    uint32_t *settings_acceleration_e1;
    uint32_t *settings_jerk_x;
    uint32_t *settings_jerk_y;
    uint32_t *settings_jerk_z;
    uint32_t *settings_jerk_e0;
    uint32_t *settings_jerk_e1;
    int32_t  *settings_max_temp_e0;
    int32_t  *settings_max_temp_e1;
    int32_t  *settings_max_temp_bed;
    int32_t  *temp[2];

    int32_t  *position_x;
    int32_t  *position_y;
    int32_t  *position_z;
    int32_t  *position_e0;
    int32_t  *position_e1;
    uint32_t *position_type;
    uint32_t *position_extruder_type;

    //flags
    bool get_flags(uint32_t flag_type, uint32_t bit);
    void set_flags(uint32_t flag_type, uint32_t bit, bool state);

    void set_settings();

public:
    PrinterController* printer;

    MechanicsController();

    int32_t temperature_adc(int32_t volt);
    int32_t extruder_number = 0;


    //Методы для выполнения GCODE команд
    void move(float dx, float dy, float dz, uint32_t f); //G0
    void move_extrude(float dx, float dy, float dz, float de, uint32_t f); //G1
    void set_absolute(); //G90
    void set_relative(); //G91
    void set_current_position(  bool x, bool y, bool z, bool e,
                                float dx, float dy, float dz, float de); //G92
    void change_extruder(int32_t n); //M6
    void enable_steppers(); //M17
    void disable_steppers(); //M18
    void set_absolute_extruder(); //M82
    void set_relative_extruder(); //M83
    void start_cooling(); //M106
    void stop_cooling(); //M107
    void set_temperature(int32_t heater, int32_t t); //M104, M140
    void hold_temperature(int32_t heater, int32_t t); //M109, M190

    //Вспомогательные методы
    void get_endstop_states(bool& xmin, bool& xmax,
                            bool& ymin, bool& ymax,
                            bool& zmin, bool& zmax);

    void get_positions(int32_t& pos_x, int32_t& pos_y,
                       int32_t& pos_z, int32_t& pos_e0,
                       int32_t& pos_e1);

    int32_t get_temp(uint32_t n);
};

#endif //INC_3D_PRINTER_MECHANICSCONTROLLER_H