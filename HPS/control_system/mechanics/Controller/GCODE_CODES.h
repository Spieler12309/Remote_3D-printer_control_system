#ifndef CONTROL_SYSTEM_GCODE_CODES_H
#define CONTROL_SYSTEM_GCODE_CODES_H

static const int32_t CODE_GCODE_G0      = 0;   //Холостой ход
static const int32_t CODE_GCODE_G1      = 1;   //Координированное движение по осям X Y Z E
static const int32_t CODE_GCODE_G4      = 2;   //Пауза в секундах
static const int32_t CODE_GCODE_G28     = 3;   //Команда Home
static const int32_t CODE_GCODE_G90     = 4;   //Установка абсолютных координат
static const int32_t CODE_GCODE_G91     = 5;   //Установка относительных координат
static const int32_t CODE_GCODE_G92     = 6;   //Установка текущей позиции
static const int32_t CODE_GCODE_M6      = 7;   //Выбор экструдера
static const int32_t CODE_GCODE_M17     = 8;   //Подача тока на двигатели
static const int32_t CODE_GCODE_M18     = 9;   //Прекращение подачи тока на двигатели
static const int32_t CODE_GCODE_M82     = 10;  //Установка экструдера в абсолютную систему координат
static const int32_t CODE_GCODE_M83     = 11;  //Установка экструдера в относительную систему координат
static const int32_t CODE_GCODE_M104    = 12;  //Ожидание нагрева экструдера до определенной температуры
static const int32_t CODE_GCODE_M105    = 13;  //Запрос температуры нагревателя
static const int32_t CODE_GCODE_M106    = 14;  //Включение вентилятора обдува детали
static const int32_t CODE_GCODE_M107    = 15;  //Выключение вентилятора обдува детали
static const int32_t CODE_GCODE_M109    = 16;  //Нагрев экструдера и удержание температуры
static const int32_t CODE_GCODE_M114    = 17;  //Запрос текущих координат
static const int32_t CODE_GCODE_M119    = 18;  //Запрос состояния концевых переключателей
static const int32_t CODE_GCODE_M140    = 19;  //Ожидание нагрева стола до определенной температуры
static const int32_t CODE_GCODE_M190    = 20;  //Нагрев стола и удержание температуры

#endif //CONTROL_SYSTEM_GCODE_CODES_H
