#include "iostream"
#include <string>
#include <fstream>
#include "TemperatureADC.h"
#include "PrinterController.h"
#include "Configuration.h"
#include "GCodeParser.h"
#include "ctime"
#include "types.h"

using namespace std; 

//класс, который отвечает за работу с лог файлами
class logs{
	
    private:
    	ofstream file;
		void date_time(bool onscreen, bool intofile);
		string fileName;

	public:
		logs(string fileName); //открывает файл
		~logs(); //закрывает файл
		void string1(bool onscreen, bool intofile, string log);
		void stringnum(bool onscreen, bool intofile, string log, int num);
		void temp(bool onscreen, bool intofile);
		void position(bool onscreen, bool intofile);
		void gcode_command(bool onscreen, bool intofile, string command, Parameters parameters);
		void printer_status(bool onscreen, bool intofile, StateType state, Position position);
};