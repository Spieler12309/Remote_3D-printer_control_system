#include "MechanicsController.h"
#include "PrinterController.h"

// Вспомогательные методы
uint32_t MechanicsController::zeroing(uint32_t number, uint32_t count, uint32_t direction)
//если direction=1, то обнуление левых count битов числа number
//иначе обнуление правых count битов числа number
{
    if (direction==1)
        return (number << count) >> count;
    else
        return (number >> count) << count;
};

uint32_t MechanicsController::create_number(bool state, uint32_t count)
{
    uint32_t a = 1;
    for (uint32_t i = 1; i <= count; i++)
        a *= 2;

    if (state)
        return a;
    else
        return (0xffffffff - a);
};

MechanicsController::MechanicsController() {
    // инициацизация памяти
    if((fd = open( "/dev/mem", (O_RDWR | O_SYNC))) == -1){
        printf("ERROR: could not open \"/dev/mem\"...\n");
    }

    virtual_base = mmap(NULL, HW_REGS_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, HW_REGS_BASE);

    if(virtual_base == MAP_FAILED) {
        printf("ERROR: mmap() failed...\n");
        close(fd);
    }

    command_type 				= (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + COMMAND_TYPE_BASE)             & (unsigned long)(HW_REGS_MASK)));
    command_x 				    = (int32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + COMMAND_X_BASE)                 & (unsigned long)(HW_REGS_MASK)));
    command_y 				    = (int32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + COMMAND_Y_BASE)                 & (unsigned long)(HW_REGS_MASK)));
    command_z 			        = (int32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + COMMAND_Z_BASE)                 & (unsigned long)(HW_REGS_MASK)));
    command_e0 			        = (int32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + COMMAND_E0_BASE)                & (unsigned long)(HW_REGS_MASK)));
    command_e1                  = (int32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + COMMAND_E1_BASE)                & (unsigned long)(HW_REGS_MASK)));
    command_f 			        = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + COMMAND_F_BASE)                & (unsigned long)(HW_REGS_MASK)));
    command_t 			        = (int32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + COMMAND_T_BASE)                 & (unsigned long)(HW_REGS_MASK)));
    command_dt 				    = (int32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + COMMAND_DT_BASE)                & (unsigned long)(HW_REGS_MASK)));

    flags_in	                = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + FLAGS_OUT_BASE)                & (unsigned long)(HW_REGS_MASK)));
    flags_out		            = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + FLAGS_IN_BASE)                 & (unsigned long)(HW_REGS_MASK)));

    settings_max_speed_x        = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + SETTINGS_MAX_SPEED_X_BASE)     & (unsigned long)(HW_REGS_MASK)));
    settings_max_speed_y        = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + SETTINGS_MAX_SPEED_Y_BASE)     & (unsigned long)(HW_REGS_MASK)));
    settings_max_speed_z 	    = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + SETTINGS_MAX_SPEED_Z_BASE)     & (unsigned long)(HW_REGS_MASK)));
    settings_max_speed_e0 	    = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + SETTINGS_MAX_SPEED_E0_BASE)    & (unsigned long)(HW_REGS_MASK)));
    settings_max_speed_e1 	    = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + SETTINGS_MAX_SPEED_E1_BASE)    & (unsigned long)(HW_REGS_MASK)));

    settings_acceleration_x		= (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + SETTINGS_ACCELERATION_X_BASE)  & (unsigned long)(HW_REGS_MASK)));
    settings_acceleration_y		= (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + SETTINGS_ACCELERATION_Y_BASE)  & (unsigned long)(HW_REGS_MASK)));
    settings_acceleration_z 	= (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + SETTINGS_ACCELERATION_Z_BASE)  & (unsigned long)(HW_REGS_MASK)));
    settings_acceleration_e0 	= (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + SETTINGS_ACCELERATION_E0_BASE) & (unsigned long)(HW_REGS_MASK)));
    settings_acceleration_e1 	= (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + SETTINGS_ACCELERATION_E1_BASE) & (unsigned long)(HW_REGS_MASK)));

    settings_jerk_x		        = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + SETTINGS_JERK_X_BASE)          & (unsigned long)(HW_REGS_MASK)));
    settings_jerk_y		        = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + SETTINGS_JERK_Y_BASE)          & (unsigned long)(HW_REGS_MASK)));
    settings_jerk_z 	        = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + SETTINGS_JERK_Z_BASE)          & (unsigned long)(HW_REGS_MASK)));
    settings_jerk_e0 	        = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + SETTINGS_JERK_E0_BASE)         & (unsigned long)(HW_REGS_MASK)));
    settings_jerk_e1 	        = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + SETTINGS_JERK_E1_BASE)         & (unsigned long)(HW_REGS_MASK)));

    settings_max_temp_e0		= (int32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + SETTINGS_MAX_TEMP_E0_BASE)      & (unsigned long)(HW_REGS_MASK)));
    settings_max_temp_e1		= (int32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + SETTINGS_MAX_TEMP_E1_BASE)      & (unsigned long)(HW_REGS_MASK)));
    settings_max_temp_bed 	    = (int32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + SETTINGS_MAX_TEMP_BED_BASE)     & (unsigned long)(HW_REGS_MASK)));

    temp[0]                     = (int32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + TEMP_0_BASE)                    & (unsigned long)(HW_REGS_MASK)));
    temp[1]                     = (int32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + TEMP_1_BASE)                    & (unsigned long)(HW_REGS_MASK)));
    temp[2]                     = (int32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + TEMP_2_BASE)                    & (unsigned long)(HW_REGS_MASK)));

    position_x                  = (int32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + POSITION_X_BASE)                & (unsigned long)(HW_REGS_MASK)));
    position_y                  = (int32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + POSITION_Y_BASE)                & (unsigned long)(HW_REGS_MASK)));
    position_z                  = (int32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + POSITION_Z_BASE)                & (unsigned long)(HW_REGS_MASK)));
    position_e0                 = (int32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + POSITION_E0_BASE)               & (unsigned long)(HW_REGS_MASK)));
    position_e1                 = (int32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + POSITION_E1_BASE)               & (unsigned long)(HW_REGS_MASK)));
    position_type               = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + POSITION_TYPE_BASE)             & (unsigned long)(HW_REGS_MASK)));
    position_extruder_type      = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + POSITION_EXTRUDER_TYPE_BASE)    & (unsigned long)(HW_REGS_MASK)));


    *command_type 				= uint32_t(0);
    *command_x 				    = int32_t(0);
    *command_y 				    = int32_t(0);
    *command_z                  = int32_t(0);
    *command_e0 			    = int32_t(0);
    *command_e1                 = int32_t(0);
    *command_f 			        = uint32_t(0);
    *command_t 			        = int32_t(0);
    *command_dt 				= int32_t(0);

    set_settings();
}

void MechanicsController::set_settings()
{
    *settings_max_speed_x       =   uint32_t(MAX_AXIS_SPEED_MICROSTEPS[0]);
    *settings_max_speed_y       =   uint32_t(MAX_AXIS_SPEED_MICROSTEPS[1]);
    *settings_max_speed_z 	    =   uint32_t(MAX_AXIS_SPEED_MICROSTEPS[2]);
    *settings_max_speed_e0 	    =   uint32_t(MAX_AXIS_SPEED_MICROSTEPS[3]);
    *settings_max_speed_e1 	    =   uint32_t(MAX_AXIS_SPEED_MICROSTEPS[4]);
    *settings_acceleration_x	=   uint32_t(MAX_AXIS_ACCELERATION_MICROSTEPS[0]);
    *settings_acceleration_y	=   uint32_t(MAX_AXIS_ACCELERATION_MICROSTEPS[1]);
    *settings_acceleration_z 	=   uint32_t(MAX_AXIS_ACCELERATION_MICROSTEPS[2]);
    *settings_acceleration_e0 	=   uint32_t(MAX_AXIS_ACCELERATION_MICROSTEPS[3]);
    *settings_acceleration_e1   =   uint32_t(MAX_AXIS_ACCELERATION_MICROSTEPS[4]);
    *settings_jerk_x		    =   uint32_t(MAX_AXIS_JERK_MICROSTEPS[0]);
    *settings_jerk_y		    =   uint32_t(MAX_AXIS_JERK_MICROSTEPS[1]);
    *settings_jerk_z 	        =   uint32_t(MAX_AXIS_JERK_MICROSTEPS[2]);
    *settings_jerk_e0 	        =   uint32_t(MAX_AXIS_JERK_MICROSTEPS[3]);
    *settings_jerk_e1 	        =   uint32_t(MAX_AXIS_JERK_MICROSTEPS[4]);
    *settings_max_temp_e0		=   int32_t(MAX_TEMP[HEATER_E0]);
    *settings_max_temp_e1		=   int32_t(MAX_TEMP[HEATER_E1]);
    *settings_max_temp_bed 	    =   int32_t(MAX_TEMP[HEATER_BED]);

    for (int i = 0; i < NUM_STEPPERS; i++)
        set_flags(flags_in_num, flags_in_inversion_steppers_base + i, STEPPERS_INVERTING[i]);
    for (int i = 0; i < NUM_ENDSTOPS; i++)
        set_flags(flags_in_num, flags_in_inversion_endstops_base + i, ENDSTOPS_INVERTING[i]);
    set_flags(flags_in_num, flags_in_inversion_bar_end, BAR_END_ENDSTOP_INVERTING);
}

// методы работы с памятью
int32_t MechanicsController::get_temp(uint32_t n)
{
    if (n >=0 && n < HEATERS_NUM) {
        uint32_t a = zeroing(*temp[n], bit_count_uint32 - 12, 1) || zeroing(0xffffffff, 12, 0);
        return static_cast<int32_t>(a);
    }
    return -100;
}

bool MechanicsController::get_flags(uint32_t flag_type, uint32_t bit)
{
    uint32_t flags_value;
    if (flag_type == flags_in_num)
        flags_value = *flags_in;
    else
        flags_value = *flags_out;
    flags_value = flags_value << (bit_count_uint32 - bit - 1);
    flags_value = flags_value >> (bit_count_uint32 - 1);
    return (flags_value == 1);
}

void MechanicsController::set_flags(uint32_t flag_type, uint32_t bit, bool state)
{
    if (flag_type == flags_in_num){
        uint32_t flags_value = *flags_in;
        uint32_t a = create_number(state, bit);
        if (state)
            *flags_in = (a | flags_value);
        else
            *flags_in = (a & flags_value);
    }
}

void MechanicsController::get_endstop_states(bool& xmin, bool& xmax,
                                             bool& ymin, bool& ymax,
                                             bool& zmin, bool& zmax)
{
    xmin = get_flags(flags_out_num, flags_out_endstops_base + 0);
    xmax = get_flags(flags_out_num, flags_out_endstops_base + 1);
    ymin = get_flags(flags_out_num, flags_out_endstops_base + 2);
    ymax = get_flags(flags_out_num, flags_out_endstops_base + 3);
    zmin = get_flags(flags_out_num, flags_out_endstops_base + 4);
    zmax = get_flags(flags_out_num, flags_out_endstops_base + 5);
}

void MechanicsController::get_positions(int32_t& pos_x, int32_t& pos_y,
                                        int32_t& pos_z, int32_t& pos_e0,
                                        int32_t& pos_e1)
{
    pos_x  = *position_x;
    pos_y  = *position_y;
    pos_z  = *position_z;
    pos_e0 = *position_e0;
    pos_e1 = *position_e1;
}