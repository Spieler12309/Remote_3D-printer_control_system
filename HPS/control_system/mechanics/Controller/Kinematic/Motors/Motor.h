#ifndef CONTROL_SYSTEM_MOTOR_H
#define CONTROL_SYSTEM_MOTOR_H

#include <inttypes.h>

class Motor {
    uint32_t stepsPerUnit = 1;

    uint32_t *maxSpeed;         //микрошагов/секунда
    uint32_t *acceleration;     //микрошагов/секунда^2
    uint32_t *jerk;             //микрошагов/секунда
    int32_t  *steps;            //микрошагов
    uint32_t *speed;            //микрошагов/секунда
    int32_t  *currentPosition;   //микрошагов

    void* virtual_base;

    template <typename T2>
    T2* createVariable(void* virtual_base, unsigned long base);

public:
    Motor();

    void setSpeed(uint32_t speed, int stepsType = mm, int timeType = perMinute);
    void setMaxSpeed(uint32_t speed, int stepsType = mm, int timeType = perMinute);
    void setAcceleration(uint32_t speed, int stepsType = mm, int timeType = perMinute);
    void setJerk(uint32_t speed, int stepsType = mm, int timeType = perMinute);
    void setSteps(int32_t st, int stepsType = mm);
    void setVariables(  void* vb,
                        unsigned long baseMS,
                        unsigned long baseA,
                        unsigned long baseJ,
                        unsigned long baseSteps,
                        unsigned long baseSpeed,
                        unsigned long baseCP);
    void setStepsPerUnit(uint32_t stepsUnit);

    int32_t  getCurrentPosition();
    uint32_t getSpeed();
    uint32_t getMaxSpeed();
    uint32_t getAcceleration();
    uint32_t getJerk();
    int32_t  getSteps();
    uint32_t getStepsPerUnit();
};


#endif //CONTROL_SYSTEM_MOTOR_H
