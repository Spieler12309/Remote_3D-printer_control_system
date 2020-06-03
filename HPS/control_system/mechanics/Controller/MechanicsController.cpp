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

template <typename T>
void MechanicsController::printTable(string title,
                int32_t colNum, int32_t rowNum,
                string colNames[], string rowNames[],
                int32_t colWidth[],
                T data[])
{
    int allWidth = colNum + 1;
    for (int i = 0; i <= colNum; i++)
        allWidth += colWidth[i];

    string border = "+";
    for (int i = 0; i <= colNum; i++) {
        border.append(colWidth[i], '-');
        border.append(1, '+');
    }



    cout << title << endl;

    cout << border << endl;
    cout << "|";
    cout.width(colWidth[0]);
    cout << "";
    cout << "|";
    for (int i = 0; i < colNum; i++) {
        cout.width(colWidth[i  + 1]);
        cout << colNames[i];
        cout << "|";
    }
    cout << endl;
    cout << border << endl;
    for (int i = 0; i < rowNum; i++) {
        cout << "|";
        cout.width(colWidth[0]);
        cout << rowNames[i];
        cout << "|";
        for (int j = 0; j < colNum; j++){
            cout.width(colWidth[i + 1]);
            cout << data[i * colNum + j];
            cout << "|";
        }
        cout << endl;
    }
    cout << border << endl;
}

uint32_t MechanicsController::createNumber(bool state, uint32_t count)
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

}

void MechanicsController::initMem() {
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
    command_f_x 		        = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + COMMAND_F_X_BASE)              & (unsigned long)(HW_REGS_MASK)));
    command_f_y 		        = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + COMMAND_F_Y_BASE)              & (unsigned long)(HW_REGS_MASK)));
    command_f_z 		        = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + COMMAND_F_Z_BASE)              & (unsigned long)(HW_REGS_MASK)));
    command_f_e0		        = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + COMMAND_F_E0_BASE)             & (unsigned long)(HW_REGS_MASK)));
    command_f_e1		        = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + COMMAND_F_E1_BASE)             & (unsigned long)(HW_REGS_MASK)));
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


    *command_type 				= uint32_t(0);
    *command_x 				    = int32_t(0);
    *command_y 				    = int32_t(0);
    *command_z                  = int32_t(0);
    *command_e0 			    = int32_t(0);
    *command_e1                 = int32_t(0);
    *command_f_x 		        = uint32_t(0);
    *command_f_y 		        = uint32_t(0);
    *command_f_z 		        = uint32_t(0);
    *command_f_e0		        = uint32_t(0);
    *command_f_e1		        = uint32_t(0);
    *command_t 			        = int32_t(0);
    *command_dt 				= int32_t(0);
    *flags_in                   = uint32_t(0);

    setSettings();
    setTestParameters();
}

void MechanicsController::setSettings()
{
    *settings_max_speed_x       =   uint32_t(printer->printerVariables.settings.movement.max_Speed.x  *
                                             printer->printerVariables.settings.movement.step_per_Unit.x  / 60);
    *settings_max_speed_y       =   uint32_t(printer->printerVariables.settings.movement.max_Speed.y  *
                                                printer->printerVariables.settings.movement.step_per_Unit.y  / 60);
    *settings_max_speed_z 	    =   uint32_t(printer->printerVariables.settings.movement.max_Speed.z  *
                                                printer->printerVariables.settings.movement.step_per_Unit.z  / 60);
    *settings_max_speed_e0 	    =   uint32_t(printer->printerVariables.settings.movement.max_Speed.e0 *
                                                printer->printerVariables.settings.movement.step_per_Unit.e0 / 60);
    *settings_max_speed_e1 	    =   uint32_t(printer->printerVariables.settings.movement.max_Speed.e1 *
                                                printer->printerVariables.settings.movement.step_per_Unit.e1 / 60);

    *settings_acceleration_x	=   uint32_t(printer->printerVariables.settings.movement.max_Acceleration.x  *
                                                printer->printerVariables.settings.movement.step_per_Unit.x  / 3600);
    *settings_acceleration_y	=   uint32_t(printer->printerVariables.settings.movement.max_Acceleration.y  *
                                                printer->printerVariables.settings.movement.step_per_Unit.y  / 3600);
    *settings_acceleration_z 	=   uint32_t(printer->printerVariables.settings.movement.max_Acceleration.z  *
                                                printer->printerVariables.settings.movement.step_per_Unit.z  / 3600);
    *settings_acceleration_e0 	=   uint32_t(printer->printerVariables.settings.movement.max_Acceleration.e0 *
                                                printer->printerVariables.settings.movement.step_per_Unit.e0 / 3600);
    *settings_acceleration_e1   =   uint32_t(printer->printerVariables.settings.movement.max_Acceleration.e1 *
                                                printer->printerVariables.settings.movement.step_per_Unit.e1 / 3600);

    *settings_jerk_x		    =   uint32_t(printer->printerVariables.settings.movement.max_Jerk.x  *
                                                printer->printerVariables.settings.movement.step_per_Unit.x  / 60);
    *settings_jerk_y		    =   uint32_t(printer->printerVariables.settings.movement.max_Jerk.y  *
                                                printer->printerVariables.settings.movement.step_per_Unit.y  / 60);
    *settings_jerk_z 	        =   uint32_t(printer->printerVariables.settings.movement.max_Jerk.z  *
                                                printer->printerVariables.settings.movement.step_per_Unit.z  / 60);
    *settings_jerk_e0 	        =   uint32_t(printer->printerVariables.settings.movement.max_Jerk.e0 *
                                                printer->printerVariables.settings.movement.step_per_Unit.e0 / 60);
    *settings_jerk_e1 	        =   uint32_t(printer->printerVariables.settings.movement.max_Jerk.e1 *
                                                printer->printerVariables.settings.movement.step_per_Unit.e1 / 60);

    *settings_max_temp_e0		=   int32_t(printer->printerVariables.settings.heaters.max_Temp.e0);
    *settings_max_temp_e1		=   int32_t(printer->printerVariables.settings.heaters.max_Temp.e1);
    *settings_max_temp_bed 	    =   int32_t(printer->printerVariables.settings.heaters.max_Temp.bed);

    setFlags(flags_in_num, flags_in_inversion_steppers_base + 0, printer->printerVariables.settings.movement.invertion.motors.x == "true");
    setFlags(flags_in_num, flags_in_inversion_steppers_base + 1, printer->printerVariables.settings.movement.invertion.motors.y == "true");
    setFlags(flags_in_num, flags_in_inversion_steppers_base + 2, printer->printerVariables.settings.movement.invertion.motors.z == "true");
    setFlags(flags_in_num, flags_in_inversion_steppers_base + 3, printer->printerVariables.settings.movement.invertion.motors.e0 == "true");
    setFlags(flags_in_num, flags_in_inversion_steppers_base + 4, printer->printerVariables.settings.movement.invertion.motors.e1 == "true");

    setFlags(flags_in_num, flags_in_inversion_endstops_base + 0, printer->printerVariables.settings.movement.invertion.endstops.xmin == "true");
    setFlags(flags_in_num, flags_in_inversion_endstops_base + 1, printer->printerVariables.settings.movement.invertion.endstops.xmax == "true");
    setFlags(flags_in_num, flags_in_inversion_endstops_base + 2, printer->printerVariables.settings.movement.invertion.endstops.ymin == "true");
    setFlags(flags_in_num, flags_in_inversion_endstops_base + 3, printer->printerVariables.settings.movement.invertion.endstops.ymax == "true");
    setFlags(flags_in_num, flags_in_inversion_endstops_base + 4, printer->printerVariables.settings.movement.invertion.endstops.zmin == "true");
    setFlags(flags_in_num, flags_in_inversion_endstops_base + 5, printer->printerVariables.settings.movement.invertion.endstops.zmax == "true");

    setFlags(flags_in_num, flags_in_inversion_bar_end, printer->printerVariables.settings.movement.invertion.barend.e0 == "true");

    setFlags(flags_in_num, flags_in_reset, true);
    usleep(10);
    setFlags(flags_in_num, flags_in_reset, false);
}

void MechanicsController::setTestParameters() {
    params_x_0 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + PARAMS_X_0_BASE) & (unsigned long)(HW_REGS_MASK)));
    params_x_1 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + PARAMS_X_1_BASE) & (unsigned long)(HW_REGS_MASK)));
    params_x_2 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + PARAMS_X_2_BASE) & (unsigned long)(HW_REGS_MASK)));
    params_x_3 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + PARAMS_X_3_BASE) & (unsigned long)(HW_REGS_MASK)));
    params_x_4 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + PARAMS_X_4_BASE) & (unsigned long)(HW_REGS_MASK)));

    params_y_0 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + PARAMS_Y_0_BASE) & (unsigned long)(HW_REGS_MASK)));
    params_y_1 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + PARAMS_Y_1_BASE) & (unsigned long)(HW_REGS_MASK)));
    params_y_2 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + PARAMS_Y_2_BASE) & (unsigned long)(HW_REGS_MASK)));
    params_y_3 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + PARAMS_Y_3_BASE) & (unsigned long)(HW_REGS_MASK)));
    params_y_4 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + PARAMS_Y_4_BASE) & (unsigned long)(HW_REGS_MASK)));

    params_z_0 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + PARAMS_Z_0_BASE) & (unsigned long)(HW_REGS_MASK)));
    params_z_1 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + PARAMS_Z_1_BASE) & (unsigned long)(HW_REGS_MASK)));
    params_z_2 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + PARAMS_Z_2_BASE) & (unsigned long)(HW_REGS_MASK)));
    params_z_3 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + PARAMS_Z_3_BASE) & (unsigned long)(HW_REGS_MASK)));
    params_z_4 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + PARAMS_Z_4_BASE) & (unsigned long)(HW_REGS_MASK)));

    params_e0_0 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + PARAMS_E0_0_BASE) & (unsigned long)(HW_REGS_MASK)));
    params_e0_1 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + PARAMS_E0_1_BASE) & (unsigned long)(HW_REGS_MASK)));
    params_e0_2 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + PARAMS_E0_2_BASE) & (unsigned long)(HW_REGS_MASK)));
    params_e0_3 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + PARAMS_E0_3_BASE) & (unsigned long)(HW_REGS_MASK)));
    params_e0_4 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + PARAMS_E0_4_BASE) & (unsigned long)(HW_REGS_MASK)));

    params_e1_0 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + PARAMS_E1_0_BASE) & (unsigned long)(HW_REGS_MASK)));
    params_e1_1 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + PARAMS_E1_1_BASE) & (unsigned long)(HW_REGS_MASK)));
    params_e1_2 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + PARAMS_E1_2_BASE) & (unsigned long)(HW_REGS_MASK)));
    params_e1_3 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + PARAMS_E1_3_BASE) & (unsigned long)(HW_REGS_MASK)));
    params_e1_4 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + PARAMS_E1_4_BASE) & (unsigned long)(HW_REGS_MASK)));


    timings_x_0 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + TIMING_X_0_BASE) & (unsigned long)(HW_REGS_MASK)));
    timings_x_1 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + TIMING_X_1_BASE) & (unsigned long)(HW_REGS_MASK)));
    timings_x_2 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + TIMING_X_2_BASE) & (unsigned long)(HW_REGS_MASK)));
    timings_x_3 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + TIMING_X_3_BASE) & (unsigned long)(HW_REGS_MASK)));

    timings_y_0 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + TIMING_Y_0_BASE) & (unsigned long)(HW_REGS_MASK)));
    timings_y_1 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + TIMING_Y_1_BASE) & (unsigned long)(HW_REGS_MASK)));
    timings_y_2 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + TIMING_Y_2_BASE) & (unsigned long)(HW_REGS_MASK)));
    timings_y_3 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + TIMING_Y_3_BASE) & (unsigned long)(HW_REGS_MASK)));

    timings_z_0 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + TIMING_Z_0_BASE) & (unsigned long)(HW_REGS_MASK)));
    timings_z_1 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + TIMING_Z_1_BASE) & (unsigned long)(HW_REGS_MASK)));
    timings_z_2 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + TIMING_Z_2_BASE) & (unsigned long)(HW_REGS_MASK)));
    timings_z_3 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + TIMING_Z_3_BASE) & (unsigned long)(HW_REGS_MASK)));

    timings_e0_0 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST +TIMING_E0_0_BASE) & (unsigned long)(HW_REGS_MASK)));
    timings_e0_1 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST +TIMING_E0_1_BASE) & (unsigned long)(HW_REGS_MASK)));
    timings_e0_2 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST +TIMING_E0_2_BASE) & (unsigned long)(HW_REGS_MASK)));
    timings_e0_3 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST +TIMING_E0_3_BASE) & (unsigned long)(HW_REGS_MASK)));

    timings_e1_0 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST +TIMING_E1_0_BASE) & (unsigned long)(HW_REGS_MASK)));
    timings_e1_1 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST +TIMING_E1_1_BASE) & (unsigned long)(HW_REGS_MASK)));
    timings_e1_2 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST +TIMING_E1_2_BASE) & (unsigned long)(HW_REGS_MASK)));
    timings_e1_3 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST +TIMING_E1_3_BASE) & (unsigned long)(HW_REGS_MASK)));


    new_params_x_0 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + NEW_RPARAMS_X_0_BASE) & (unsigned long)(HW_REGS_MASK)));
    new_params_x_1 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + NEW_RPARAMS_X_1_BASE) & (unsigned long)(HW_REGS_MASK)));
    new_params_x_2 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + NEW_RPARAMS_X_2_BASE) & (unsigned long)(HW_REGS_MASK)));
    new_params_x_3 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + NEW_RPARAMS_X_3_BASE) & (unsigned long)(HW_REGS_MASK)));
    new_params_x_4 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + NEW_RPARAMS_X_4_BASE) & (unsigned long)(HW_REGS_MASK)));

    new_params_y_0 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + NEW_RPARAMS_Y_0_BASE) & (unsigned long)(HW_REGS_MASK)));
    new_params_y_1 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + NEW_RPARAMS_Y_1_BASE) & (unsigned long)(HW_REGS_MASK)));
    new_params_y_2 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + NEW_RPARAMS_Y_2_BASE) & (unsigned long)(HW_REGS_MASK)));
    new_params_y_3 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + NEW_RPARAMS_Y_3_BASE) & (unsigned long)(HW_REGS_MASK)));
    new_params_y_4 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + NEW_RPARAMS_Y_4_BASE) & (unsigned long)(HW_REGS_MASK)));

    new_params_z_0 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + NEW_RPARAMS_Z_0_BASE) & (unsigned long)(HW_REGS_MASK)));
    new_params_z_1 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + NEW_RPARAMS_Z_1_BASE) & (unsigned long)(HW_REGS_MASK)));
    new_params_z_2 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + NEW_RPARAMS_Z_2_BASE) & (unsigned long)(HW_REGS_MASK)));
    new_params_z_3 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + NEW_RPARAMS_Z_3_BASE) & (unsigned long)(HW_REGS_MASK)));
    new_params_z_4 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + NEW_RPARAMS_Z_4_BASE) & (unsigned long)(HW_REGS_MASK)));

    new_params_e0_0 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + NEW_RPARAMS_E0_0_BASE) & (unsigned long)(HW_REGS_MASK)));
    new_params_e0_1 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + NEW_RPARAMS_E0_1_BASE) & (unsigned long)(HW_REGS_MASK)));
    new_params_e0_2 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + NEW_RPARAMS_E0_2_BASE) & (unsigned long)(HW_REGS_MASK)));
    new_params_e0_3 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + NEW_RPARAMS_E0_3_BASE) & (unsigned long)(HW_REGS_MASK)));
    new_params_e0_4 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + NEW_RPARAMS_E0_4_BASE) & (unsigned long)(HW_REGS_MASK)));

    new_params_e1_0 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + NEW_RPARAMS_E1_0_BASE) & (unsigned long)(HW_REGS_MASK)));
    new_params_e1_1 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + NEW_RPARAMS_E1_1_BASE) & (unsigned long)(HW_REGS_MASK)));
    new_params_e1_2 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + NEW_RPARAMS_E1_2_BASE) & (unsigned long)(HW_REGS_MASK)));
    new_params_e1_3 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + NEW_RPARAMS_E1_3_BASE) & (unsigned long)(HW_REGS_MASK)));
    new_params_e1_4 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + NEW_RPARAMS_E1_4_BASE) & (unsigned long)(HW_REGS_MASK)));

    max_timings_0 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + MAX_TIMING_0_BASE) & (unsigned long)(HW_REGS_MASK)));
    max_timings_1 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + MAX_TIMING_1_BASE) & (unsigned long)(HW_REGS_MASK)));
    max_timings_2 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + MAX_TIMING_2_BASE) & (unsigned long)(HW_REGS_MASK)));
    max_timings_3 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + MAX_TIMING_3_BASE) & (unsigned long)(HW_REGS_MASK)));

    max_params_0 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + MAX_PARAMS_0_BASE) & (unsigned long)(HW_REGS_MASK)));
    max_params_1 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + MAX_PARAMS_1_BASE) & (unsigned long)(HW_REGS_MASK)));
    max_params_2 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + MAX_PARAMS_2_BASE) & (unsigned long)(HW_REGS_MASK)));
    max_params_3 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + MAX_PARAMS_3_BASE) & (unsigned long)(HW_REGS_MASK)));
    max_params_4 = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + MAX_PARAMS_4_BASE) & (unsigned long)(HW_REGS_MASK)));

    step_x_now  = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + STEP_X_NOW_BASE) & (unsigned long)(HW_REGS_MASK)));
    step_y_now  = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + STEP_Y_NOW_BASE) & (unsigned long)(HW_REGS_MASK)));
    step_z_now  = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + STEP_Z_NOW_BASE) & (unsigned long)(HW_REGS_MASK)));
    step_e0_now = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + STEP_E0_NOW_BASE) & (unsigned long)(HW_REGS_MASK)));
    step_e1_now = (uint32_t *) (virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + STEP_E1_NOW_BASE) & (unsigned long)(HW_REGS_MASK)));

}

void MechanicsController::printTestParameters() {
    usleep(10);

    string parametersColNames[5] = {"N", "nn", "t0", "tna", "delta"};
    string motorsNames[5] = {"Motor X ", "Motor Y ", "Motor Z ", "Motor E0", "Motor E1"};
    int32_t colWidth[5 + 1] = {10, 10, 10, 10, 10, 10};
    uint32_t data[5 * 5] = {
            *params_x_0 , *params_x_1 , *params_x_2 , *params_x_3 , *params_x_4 ,
            *params_y_0 , *params_y_1 , *params_y_2 , *params_y_3 , *params_y_4 ,
            *params_z_0 , *params_z_1 , *params_z_2 , *params_z_3 , *params_z_4 ,
            *params_e0_0, *params_e0_1, *params_e0_2, *params_e0_3, *params_e0_4,
            *params_e1_0, *params_e1_1, *params_e1_2, *params_e1_3, *params_e1_4};
    printTable( "Начальные параметры движения",
                5,   5,
                parametersColNames, motorsNames,
                colWidth, data);
    cout << endl;


    string timingsColNames[4] = {"t1", "t2", "t3", "tt"};
    double data2[5 * 4] = {
            (*timings_x_0 ) / 50000000.0, (*timings_x_1 ) / 50000000.0, (*timings_x_2 ) / 50000000.0, (*timings_x_3 ) / 50000000.0,
            (*timings_y_0 ) / 50000000.0, (*timings_y_1 ) / 50000000.0, (*timings_y_2 ) / 50000000.0, (*timings_y_3 ) / 50000000.0,
            (*timings_z_0 ) / 50000000.0, (*timings_z_1 ) / 50000000.0, (*timings_z_2 ) / 50000000.0, (*timings_z_3 ) / 50000000.0,
            (*timings_e0_0) / 50000000.0, (*timings_e0_1) / 50000000.0, (*timings_e0_2) / 50000000.0, (*timings_e0_3) / 50000000.0,
            (*timings_e1_0) / 50000000.0, (*timings_e1_1) / 50000000.0, (*timings_e1_2) / 50000000.0, (*timings_e1_3) / 50000000.0,};
    printTable( "Время движения в секундах",
                4,   5,
                timingsColNames, motorsNames,
                colWidth, data2);
    cout << endl;


    string maxTimingsRowNames[1] = {"maxTimings"};
    double data3[1 * 4] = {
            (*max_timings_0) / 50000000.0,
            (*max_timings_1) / 50000000.0,
            (*max_timings_2) / 50000000.0,
            (*max_timings_3) / 50000000.0,};
    printTable( "Максимальное время",
                4,   1,
                timingsColNames, maxTimingsRowNames,
                colWidth, data3);

    string maxParamsRowNames[1] = {"maxParams"};
    uint32_t data4[4 * 5] = {
            *max_params_0 , *max_params_1 , *max_params_2 , *max_params_3 , *max_params_4};
    printTable( "Максимальные параметры",
                5,   1,
                parametersColNames, maxParamsRowNames,
                colWidth, data4);
    cout << endl;


    uint32_t data5[5 * 5] = {
            *new_params_x_0 , *new_params_x_1 , *new_params_x_2 , *new_params_x_3 , *new_params_x_4 ,
            *new_params_y_0 , *new_params_y_1 , *new_params_y_2 , *new_params_y_3 , *new_params_y_4 ,
            *new_params_z_0 , *new_params_z_1 , *new_params_z_2 , *new_params_z_3 , *new_params_z_4 ,
            *new_params_e0_0, *new_params_e0_1, *new_params_e0_2, *new_params_e0_3, *new_params_e0_4,
            *new_params_e1_0, *new_params_e1_1, *new_params_e1_2, *new_params_e1_3, *new_params_e1_4};
    printTable( "Новые параметры движения",
                5,   5,
                parametersColNames, motorsNames,
                colWidth, data5);
    cout << endl;
}

void MechanicsController::printSettings() {

    string settingsColNames[5] = {"X", "Y", "Z", "E0", "E1"};
    string settingsRowNames[3] = {"maxSpeed", "acceleration", "jerk"};
    int32_t colWidth[5 + 1] = {12, 10, 10, 10, 10, 10};
    uint32_t data[5 * 3] = {
            *settings_max_speed_x , *settings_max_speed_y , *settings_max_speed_z , *settings_max_speed_e0 , *settings_max_speed_e1,
            *settings_acceleration_x , *settings_acceleration_y , *settings_acceleration_z , *settings_acceleration_e0 , *settings_acceleration_e1,
            *settings_jerk_x , *settings_jerk_y , *settings_jerk_z , *settings_jerk_e0 , *settings_jerk_e1};
    printTable( "Заданные настройки",
                5,   3,
                settingsColNames, settingsRowNames,
                colWidth, data);
    cout << endl;
}

void MechanicsController::printCommands() {

    string commandsColNames[5] = {"X", "Y", "Z", "E0", "E1"};
    string commandsRowNames[2] = {"steps (mks)", "speed (mks/second)"};
    int32_t colWidth[5 + 1] = {18, 10, 10, 10, 10, 10};
    int32_t data[5 * 2] = {
            *command_x , *command_y , *command_z , *command_e0 , *command_e1,
            *command_f_x , *command_f_y , *command_f_z , *command_f_e0 , *command_f_e1};
    printTable( "Параметры команды",
                5,   2,
                commandsColNames, commandsRowNames,
                colWidth, data);
    cout << endl;
}

// методы работы с памятью
bool MechanicsController::getFlags(uint32_t flag_type, uint32_t bit)
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

void MechanicsController::setFlags(uint32_t flag_type, uint32_t bit, bool state)
{
    if (flag_type == flags_in_num){
        uint32_t flags_value = *flags_in;
        uint32_t a = createNumber(state, bit);
        if (state)
            *flags_in = (a | flags_value);
        else
            *flags_in = (a & flags_value);
    }
}