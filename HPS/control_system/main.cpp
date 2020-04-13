#include "PrinterController.h"

// Global variable
bool isScreenDebug;

int main(int argc, char *argv[]) {

	std::cout << "OK - main() - Running with flags: ";

	// cout flags
	for (int i = 1; i < argc; ++i) {
        std::cout << argv[i] << std::endl;
    }

	std::cout << "OK - main() - Running regularly" << std::endl;

  	PrinterController printer;
  	printer.main_loop();
    return 0;
}
