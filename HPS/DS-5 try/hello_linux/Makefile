# C Application Example for Arm Linux
#
# Copyright (c) 2007-2018 Arm Limited (or its affiliates). All rights reserved.
# Use, modification and redistribution of this file is subject to your possession of a
# valid End User License Agreement for the Arm Product of which these examples are part of 
# and your compliance with all applicable terms and conditions of such licence agreement.
#
# This makefile is intended for use with GNU make
#
# This project builds for hard-float filesystems


TARGET = hello1
ABI = -marm -mfloat-abi=hard
CFLAGS = -O1 -g -fno-omit-frame-pointer -std=c++14
OBJS=$(patsubst %.c,%.o,$(wildcard *.c))

##########################################################################

CC  = arm-linux-gnueabihf-gcc
AR  = arm-linux-gnueabihf-ar
STRIP_APP = arm-linux-gnueabihf-strip -R .comment --strip-all
STRIP_LIB = arm-linux-gnueabihf-strip -R .comment --strip-unneeded


# Select build rules based on Windows or Linux
ifdef WINDIR
#  Building on Windows
RPATH=$$ORIGIN
WINPATH=$(subst /,\,$(1))
DONE=@if exist $(call WINPATH,$(1)) echo Build completed.
define REAL_RM
if exist $(call WINPATH,$(1)) del /q $(call WINPATH,$(1))

endef
RM=$(foreach file,$(1),$(call REAL_RM,$(file)))
SHELL=$(WINDIR)\system32\cmd.exe
MD=if not exist $(1) mkdir $(1)
CP=copy
else
ifdef windir
#  Building on Windows
RPATH=$$ORIGIN
WINPATH=$(subst /,\,$(1))
DONE=@if exist $(call WINPATH,$(1)) echo Build completed.
define REAL_RM
if exist $(call WINPATH,$(1)) del /q $(call WINPATH,$(1))

endef
RM=$(foreach file,$(1),$(call REAL_RM,$(file)))
SHELL=$(windir)\system32\cmd.exe
MD=if not exist $(1) mkdir $(1)
CP=copy

else
#  Building on Linux
RPATH='$$ORIGIN'
DONE=@if [ -f $(1) ]; then echo Build completed.; fi
RM=rm -f $(1)
MD=@if [ ! -d $(1) ]; then mkdir $(1); fi
CP=cp
endif
endif

##########################################################################

all: $(TARGET)
	$(call DONE,$(TARGET))

rebuild: clean all

clean:
	$(call RM,$(OBJS))
	$(call RM,$(TARGET))
	$(call RM,$(TARGET)_stripped)

cleanobjs:
	$(call RM,$(OBJS))

# Compile the sources
$(OBJS): %.o: %.c
	$(CC) -c $(CFLAGS) $(ABI) $< -o $@

# Link the objects together to create an executable
# Strip the host/debug version to create a stripped/nodebug version for downloading to the target
$(TARGET): $(OBJS)
	$(CC) $(OBJS) $(ABI) -o $(TARGET)
	$(STRIP_APP) $(TARGET) -o $(TARGET)_stripped
