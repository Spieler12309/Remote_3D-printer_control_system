#include "PrinterController.h"

// Global variable
bool isScreenDebug;

int main(int argc, char *argv[]) {
	// cout flags
	/*for (int i = 1; i < argc; ++i) {
        std::cout << argv[i] << std::endl;
    }*/
	std::cout << "PrinterController started" << std::endl;

  	PrinterController printer;
  	printer.mainLoop();
    return 0;
}
