cmake_minimum_required(VERSION 3.12)
project(3d_printer)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED on)

add_executable(3d_printer
        main.cpp

        mechanics/Controller/Commands.cpp
        mechanics/Controller/MechanicsController.cpp
        mechanics/Controller/MechanicsController.h
        mechanics/Controller/GCODE_CODES.h
        mechanics/HPS_HEADER.h

        printer/Controller/PrinterController.cpp
        printer/Controller/PrinterController.h
        printer/Controller/GCodeCommands.cpp
        printer/Controller/ServerCommands.cpp
        printer/GCodeParser/GCodeParser.cpp
        printer/GCodeParser/GCodeParser.h
        printer/FileManager/FileManager.cpp
        printer/FileManager/FileManager.h
        printer/dict.h
        printer/types.h
        printer/configuration.h
        )
