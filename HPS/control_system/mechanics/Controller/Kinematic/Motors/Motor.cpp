#include "Motor.h"
#include "HPS_HEADER.h"

T2* Motors::createVariable(void* virtual_base, unsigned long base);

Motors::Motor() {

}

void setVariables(  void* vb,
                    unsigned long baseMS,
                    unsigned long baseA,
                    unsigned long baseJ,
                    unsigned long baseSteps,
                    unsigned long baseSpeed,
                    unsigned long baseCP) {

    maxSpeed        = createVariable<uint32_t>(vb, baseMS);
    acceleration    = createVariable<uint32_t>(vb, baseA);
    jerk            = createVariable<uint32_t>(vb, baseJ);
    steps           = createVariable<int32_t>(vb, baseSteps);
    speed           = createVariable<uint32_t>(vb, baseSpeed);
    currentPosition = createVariable<int32_t>(vb, baseCP);
}

void setSpeed(uint32_t speed, int stepsType = mm, int timeType = perMinute) {

    *speed =
}

void setMaxSpeed(uint32_t speed, int stepsType = mm, int timeType = perMinute) {

}

void setAcceleration(uint32_t speed, int stepsType = mm, int timeType = perMinute) {

}

void setJerk(uint32_t speed, int stepsType = mm, int timeType = perMinute) {

}

void setSteps(int32_t st, int stepsType = mm) {
    (*steps) = st if (mm == steps)
}

void setStepsPerUnit(uint32_t stepsUnit) {
    (*currentPosition) = stepsPerUnit;
}

int32_t  getCurrentPosition() {
    return (*currentPosition)
}

uint32_t getSpeed() {
    return (*speed);
}

uint32_t getMaxSpeed() {
    return (*maxSpeed);
}

uint32_t getAcceleration() {
    return (*acceleration);
}

uint32_t getJerk() {
    return (*jerk);
}

int32_t  getSteps() {
    return (*steps);
}

uint32_t getStepsPerUnit() {
    return (*stepsPerUnit);
}

