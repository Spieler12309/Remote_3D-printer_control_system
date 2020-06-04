#!/usr/bin/env python
"""Django's command-line utility for administrative tasks."""
import os
import sys


def main():
    #rbf file execution
    # os.system('cat printer.rbf > /dev/fpga0')

    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'printer_management.settings')
    try:
        from django.core.management import execute_from_command_line
    except ImportError as exc:
        raise ImportError(
            "Couldn't import Django. Are you sure it's installed and "
            "available on your PYTHONPATH environment variable? Did you "
            "forget to activate a virtual environment?"
        ) from exc
    execute_from_command_line(sys.argv)

import psi.process
if __name__ == '__main__':
    for p in psi.process.ProcessTable().values():
        if(p.command == '/home/root/printer_management/PrinterSystem'):
            os.system('kill '+str(p.pid))
    os.system('sudo rm -f /home/root/printer_management/inputPipe.msg')
    os.system('sudo rm -f /home/root/printer_management/outputPipe.msg')
    os.system('sudo chmod 777 /home/root/printer_management/PrinterSystem')
    os.system('/home/root/printer_management/PrinterSystem > /home/root/printer_management/logs.txt &')
    # print(os.system('/home/root/printer_management/PrinterSystem &'))
    #test
    main()
