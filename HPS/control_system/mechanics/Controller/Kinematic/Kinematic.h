//
// Created by vvzun on 04.06.2020.
//

#ifndef CONTROL_SYSTEM_COREXY_H
#define CONTROL_SYSTEM_COREXY_H

#include "configuration.h

class MechanicsController;

class Kinematic {
    Motor motors[5];
public:
    Kinematic(void* vb);

    void setPositions();
    void setSpeeds();

    void setNewMaxSpeeds();
    void setNewAccelerations();
    void setNewJerks();


};


#endif //CONTROL_SYSTEM_COREXY_H
