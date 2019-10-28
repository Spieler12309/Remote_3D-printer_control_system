#include "logs.h"

void logs::date_time(bool onscreen, bool intofile)
{
    time_t t = time(0);   // получение текущего времени
    tm* now = localtime(&t);

    //вывод ГГГГ-ММ-ДД (GMT+3) ЧЧ:ММ:СС
    if(onscreen)
     	file << (now->tm_year + 1900) << '-' 
	         << (now->tm_mon + 1) << '-'
	         <<  now->tm_mday << " (GMT+3) "
	         << (now->tm_hour + 3) << ':'
	         <<  now->tm_min << ':'
	         <<  now->tm_sec << endl;
    if(intofile)
    	file << (now->tm_year + 1900) << '-' 
	         << (now->tm_mon + 1) << '-'
	         <<  now->tm_mday << " (GMT+3) "
	         << (now->tm_hour + 3) << ':'
	         <<  now->tm_min << ':'
	         <<  now->tm_sec << endl;
}

logs::logs(string fileName)
{
	this->fileName = fileName;

	if(!file.is_open())
		file.open (fileName);
	date_time(onscreen, intofile);
	cout << "File is open" << endl;
	file << "File is open" << endl;
};

logs::~logs()
{
	date_time(onscreen, intofile);
	cout << "File is closed" << endl;
	file << "File is closed" << endl;
	file.close();
}

void logs::gcode_command(bool onscreen, bool intofile, string command, Parameters parameters;)
{
	date_time(onscreen, intofile);	
	if(onscreen)
		cout << "Команда: " << command, parameters;
	if(intofile)
		file << "Команда: " << command, parameters;

}

void logs::printer_status(bool onscreen, bool intofile, StateType state, Position position)
{
	date_time(onscreen, intofile);
	
	if(onscreen)
	{
	switch(state){
		case StateType.Waiting: cout << "Waiting";
		case StateType.Printing: cout << "Printing";
		case StateType.Pause_Printing: cout << "Pause_Printing";
		case StateType.Stop_Printing: cout << "Stop_Printing";
		case StateType.ShuttingDown: cout << "ShuttingDown";		
		} 
	cout << "Нагрев стола:           " << get_flags_out_heating_bed() << endl;
	cout << "Нагрев экструдера:      " << get_flags_out_heating_extruder() << endl;
	cout << "Температура стола:      " << get_temp_bed() << endl;
	cout << "Температура экструдера: " << get_temp0() << endl;
	cout << "Координаты:             " << position.x << "; " << position.y << "; " << position.z << "; " << position.e << endl;
	}

	if(intofile)
	{
	switch(state){
		case StateType.Waiting: file << "Waiting";
		case StateType.Printing: file << "Printing";
		case StateType.Pause_Printing: file << "Pause_Printing";
		case StateType.Stop_Printing: file << "Stop_Printing";
		case StateType.ShuttingDown: file << "ShuttingDown";		
		}
	file << "Нагрев стола:           " << get_flags_out_heating_bed() << endl;
	file << "Нагрев экструдера:      " << get_flags_out_heating_extruder() << endl;
	file << "Температура стола:      " << get_temp_bed() << endl;
	file << "Температура экструдера: " << get_temp0() << endl;
	file << "Координаты:             " << position.x << "; " << position.y << "; " << position.z << "; " << position.e << endl;
	}
	
}

void logs::string1(bool onscreen, bool intofile, string log)
{
	date_time(onscreen, intofile);
	if(onscreen)
		cout << string << endl;
	if(intofile)
		file << string << endl;
}

void logs::stringnum(bool onscreen, bool intofile, string log, int num)
{
	date_time(onscreen, intofile);
	if(onscreen)
		cout << string << " " << num << endl;
	if(intofile)
		file << string << " " << num << endl;
}

void logs::temp(bool onscreen, bool intofile)
{
	date_time(onscreen, intofile);
	if(onscreen)
	{
		cout << "Нагрев стола:           " << get_flags_out_heating_bed() << endl;
		cout << "Нагрев экструдера:      " << get_flags_out_heating_extruder() << endl;
		cout << "Температура стола:      " << get_temp_bed() << endl;
		cout << "Температура экструдера: " << get_temp0() << endl;
	}
	if(intofile)
	{
		file << "Нагрев стола:           " << get_flags_out_heating_bed() << endl;
		file << "Нагрев экструдера:      " << get_flags_out_heating_extruder() << endl;
		file << "Температура стола:      " << get_temp_bed() << endl;
		file << "Температура экструдера: " << get_temp0() << endl;
	}

}

