#ifndef CONTROL_SYSTEM_GCODE_CODES_H
#define CONTROL_SYSTEM_GCODE_CODES_H

static const int32_t CODE_GCODE_G0      = 0;   //Холостой ход
static const int32_t CODE_GCODE_G1      = 1;   //Координированное движение по осям X Y Z E
static const int32_t CODE_GCODE_G4      = 2;   //Пауза в секундах
static const int32_t CODE_GCODE_G28     = 3;   //Команда Home
static const int32_t CODE_GCODE_G90     = 4;   //Использовать абсолютные координаты
static const int32_t CODE_GCODE_G91     = 5;   //Использовать относительные координаты
static const int32_t CODE_GCODE_G92     = 6;   //Установить текущую позицию
static const int32_t CODE_GCODE_M6      = 7;   //Выбор экструдера
static const int32_t CODE_GCODE_M17     = 8;   //Подать ток на двигатели
static const int32_t CODE_GCODE_M18     = 9;   //Убрать ток с двигателей
static const int32_t CODE_GCODE_M82     = 10;  //Установить экструдер в абсолютную систему координат
static const int32_t CODE_GCODE_M83     = 11;  //Установить экструдер в относительную систему координат
static const int32_t CODE_GCODE_M104    = 12;  //Ожидание нагрева экструдера до определенной температуры
static const int32_t CODE_GCODE_M106    = 13;  //Включение вентилятора обдува детали
static const int32_t CODE_GCODE_M107    = 14;  //Выключение вентилятора обдува детали
static const int32_t CODE_GCODE_M109    = 15;  //Нагреть экструдер и удерживать температуру
static const int32_t CODE_GCODE_M140    = 16;  //Ожидание нагрева стола до определенной температуры
static const int32_t CODE_GCODE_M190    = 17;  //Нагреть стол и удерживать температуру

#endif //CONTROL_SYSTEM_GCODE_CODES_H
