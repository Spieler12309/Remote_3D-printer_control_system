
#include <iostream>
#include "MiniPID.h"

using namespace std;

MiniPID pid=MiniPID(3,2,1.8);

int main()
{
    double sensor = 20;
    double target = 300;
    double output=pid.getOutput(sensor,target);
    cout << output;
    return 0;
}