#ifndef INC_3D_PRINTER_TYPES_H
#define INC_3D_PRINTER_TYPES_H

#include "configuration.h"

struct PrinterVariables {

    /* Types */

    struct Status {
        // Errors / Для индикаторов ошибок
        bool isPadHot           = false; // Статус температуры стола
        bool isRodEmpty         = false; // Пруток закончился
    };

    // Movement settings
    struct Settings {
        struct Heaters {
            struct PID {
                float p = 0.0f;
                float i = 0.0f;
                float d = 0.0f;
            };
            struct MaxTemp {
                int32_t bed = 300;
                int32_t e0  = 300;
                int32_t e1  = 300;
            };
            int32_t delta = 1;
            PID pid;
            MaxTemp maxTemp;
        };

        struct Movement {
            struct DefaultSpeed {
                float x  = 6000.0f;
                float y  = 6000.0f;
                float z  = 2000.0f;
                float e0 =  200.0f;
                float e1 =  200.0f;
            };

            struct MaxSpeed {
                float x  = 6000.0f;
                float y  = 6000.0f;
                float z  = 2000.0f;
                float e0 =  200.0f;
                float e1 =  200.0f;
            };

            struct MaxAcceleration {
                float x  = 7200000.0f;
                float y  = 7200000.0f;
                float z  = 3600000.0f;
                float e0 =  360000.0f;
                float e1 =  360000.0f;
            };

            struct MaxJerk {
                float x  = 1000.0f;
                float y  = 1000.0f;
                float z  =  100.0f;
                float e0 =  200.0f;
                float e1 =  200.0f;
            };

            struct Homing {
                struct Fast {
                    float x = 8000;
                    float y = 8000;
                    float z = 2000;
                };
                struct Slow {
                    float x = 1000;
                    float y = 1000;
                    float z = 500;
                };

                Fast fast;
                Slow slow;
            };

            struct StepsPerUnit {
                float x  =  80.0f;
                float y  =  80.0f;
                float z  = 800.0f;
                float e0 =  92.0f;
                float e1 =  92.0f;
            };

            struct Size{
                float x = 250.0f;
                float y = 250.0f;
                float z = 250.0f;
            };

            int32_t numOfExtruders = 1;
            int32_t numOfEndstops = 1;
            int32_t numOfMotors = 5;
            int32_t numOfBarend = 1;

            struct Invertion {
                struct Motors {
                    string x = "false";
                    string y = "false";
                    string z = "false";
                    string e0 = "false";
                    string e1 = "false";
                };
                struct Endstops {
                    string xmin = "true";
                    string xmax = "true";
                    string ymin = "true";
                    string ymax = "true";
                    string zmin = "true";
                    string zmax = "true";
                };
                struct Barend {
                    string e0 = "false";
                    string e1 = "false";
                };

                Motors motors;
                Endstops endstops;
                Barend barend;
            };


            DefaultSpeed defaultSpeed;
            MaxSpeed maxSpeed;
            MaxAcceleration maxAcceleration;
            MaxJerk maxJerk;
            StepsPerUnit stepsPerUnit;
            Size size;
            Homing homing;
            Invertion invertion;
        };

        Heaters heaters;
        Movement movement;
    };

    Settings settings;
    Status status;
};

/* Helper function */

template<class T>
bool isValueChanged(T firstArg, T secondArg) {
    /*
        Checks is values changed. Use carefully.
    */
    return firstArg != secondArg;
}



#endif //INC_3D_PRINTER_TYPES_H
