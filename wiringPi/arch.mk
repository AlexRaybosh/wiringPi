#
# Makefile:
#	wiringPi - Wiring Compatable library for the Raspberry Pi
#
#	Copyright (c) 2012-2015 Gordon Henderson
#################################################################################
# This file is part of wiringPi:
#	https://projects.drogon.net/raspberry-pi/wiringpi/
#
#    wiringPi is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Lesser General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    wiringPi is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Lesser General Public License for more details.
#
#    You should have received a copy of the GNU Lesser General Public License
#    along with wiringPi.  If not, see <http://www.gnu.org/licenses/>.
#################################################################################


# -fvisibility=hidden -fvisibility-inlines-hidden 


LDFLAGS:=-lm -lpthread -lrt -lcrypt

COMMON_CFLAGS=-O2 -g -D_GNU_SOURCE -Wformat=2 -Wall -Wextra -Winline \
	-D_POSIX_C_SOURCE=201712L -D_XOPEN_SOURCE=600 -fpic -pthread \
	-I. -I./src

ifeq "$(ARCH)" "Linux-x86_64"
	TOOLS=
	CFLAGS:=-m64  $(COMMON_CFLAGS)
	STRIP:=strip
else ifeq "$(ARCH)" "Linux-armv6l"
	TOOLS=/opt/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-
	CFLAGS:=$(COMMON_CFLAGS) -march=armv6zk -mcpu=arm1176jz-s -mfpu=vfp -mfloat-abi=hard \
	-mabi=aapcs-linux
else ifeq "$(ARCH)" "Linux-armv7l"
	TOOLS=/opt/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-
	CFLAGS:=$(COMMON_CFLAGS) -mtune=cortex-a7 -mcpu=cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard \
	-mabi=aapcs-linux 
endif


VERSION=$(shell cat ../VERSION)
WIRINGPI_SONAME_SUFFIX=$(shell awk -F'.' '{print $$1}'  ../VERSION)

CC:=$(TOOLS)gcc
STRIP:=$(TOOLS)strip
AR:=$(TOOLS)ar
RANLIB:=$(TOOLS)ranlib


$(info ARCH $(ARCH))

DESTDIR?=/opt/wiringPi
PREFIX?=$(ARCH)




$(info CC $(CC))


###############################################################################
SRC_DIR:=src

SRC:= \
	$(SRC_DIR)/wiringPi.c \
	$(SRC_DIR)/wiringSerial.c \
	$(SRC_DIR)/wiringShift.c \
	$(SRC_DIR)/piHiPri.c \
	$(SRC_DIR)/piThread.c \
	$(SRC_DIR)/wiringPiSPI.c \
	$(SRC_DIR)/wiringPiI2C.c \
	$(SRC_DIR)/softPwm.c \
	$(SRC_DIR)/softTone.c \
	$(SRC_DIR)/mcp23008.c \
	$(SRC_DIR)/mcp23016.c \
	$(SRC_DIR)/mcp23017.c \
	$(SRC_DIR)/mcp23s08.c \
	$(SRC_DIR)/mcp23s17.c \
	$(SRC_DIR)/sr595.c \
	$(SRC_DIR)/pcf8574.c \
	$(SRC_DIR)/pcf8591.c \
	$(SRC_DIR)/mcp3002.c \
	$(SRC_DIR)/mcp3004.c \
	$(SRC_DIR)/mcp4802.c \
	$(SRC_DIR)/mcp3422.c \
	$(SRC_DIR)/max31855.c \
	$(SRC_DIR)/max5322.c \
	$(SRC_DIR)/ads1115.c \
	$(SRC_DIR)/sn3218.c \
	$(SRC_DIR)/bmp180.c \
	$(SRC_DIR)/htu21d.c \
	$(SRC_DIR)/ds18b20.c \
	$(SRC_DIR)/rht03.c \
	$(SRC_DIR)/drcSerial.c \
	$(SRC_DIR)/drcNet.c \
	$(SRC_DIR)/pseudoPins.c \
	$(SRC_DIR)/wpiExtensions.c



HEADERS:=$(wildcard $(SRC_DIR)/*.h)

#HEADERS =	$(shell ls *.h)

BUILD=build/$(ARCH)
OBJS=$(patsubst $(SRC_DIR)/%.c,$(BUILD)/%.o,$(wildcard $(SRC_DIR)/*.c))

STATIC=$(BUILD)/libwiringPi.a
DYNAMIC=$(BUILD)/libwiringPi.so.$(VERSION)

$(info SRC $(SRC))

$(info HEADERS $(HEADERS))
$(info DYNAMIC $(DYNAMIC))
$(info STATIC $(STATIC))
$(info OBJS $(OBJS))

all: $(STATIC) $(DYNAMIC)


$(BUILD)/%.o : $(SRC_DIR)/%.c $(SRC_DIR)/%.h
	echo "Processing " $<
	mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@ 

$(BUILD)/%.o : $(SRC_DIR)/%.c
	echo "Processing " $<
	mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@ 


$(STATIC):	$(OBJS)
	@echo "[Link (Static)]"
	$(TOOLS)ar rcs $@ $^
	$(TOOLS)ranlib $(STATIC)

$(DYNAMIC):	$(OBJS)
	$(CC) -shared -Wl,-soname,libwiringPi.so.$(WIRINGPI_SONAME_SUFFIX) -Wl,-soname,libwiringPi.so -o $@ $^

.PHONY:	clean install all

clean:
	@echo "[Clean]"
	@rm -rf $(BUILD) core


install:	$(DYNAMIC)
	$Q echo "[Install Headers]"
	$Q install -m 0755 -d $(DESTDIR)/include
	$Q install -m 0644 $(HEADERS) $(DESTDIR)/include
	$Q echo "[Install Dynamic Lib]"
	@mkdir -p $(DESTDIR)/$(PREFIX)/lib
	$Q install -m 0755 -d			$(DESTDIR)/$(PREFIX)/lib
	$Q install -m 0755 $(DYNAMIC)	$(DESTDIR)/$(PREFIX)/lib/libwiringPi.so.$(VERSION)
	$Q install -m 0755 $(STATIC)	$(DESTDIR)/$(PREFIX)/lib
	ln -sf $(DESTDIR)/$(PREFIX)/lib/libwiringPi.so.$(VERSION)	$(DESTDIR)/$(PREFIX)/lib/libwiringPi.so.$(WIRINGPI_SONAME_SUFFIX)




