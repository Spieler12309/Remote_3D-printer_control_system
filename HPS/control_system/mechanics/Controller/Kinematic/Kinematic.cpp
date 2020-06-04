#include "Kinematic.h"

Kinematic::Kinematic(void* vb) {
    for (int i = 0; i < 5; i++)
        motors[i].setVirtualBase();
}

