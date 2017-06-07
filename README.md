# wiringPi

    Reworked the original project as a cross compilation setup for wiringPi
    static/dynamic library build. Set it as a CDT eclipse project, to
    compile/install for PiZero/Pi2 archs, along with future setup for x64
    experiments.

	Reorged wiringPi/wirinPi. Used linaro toolchain. It is hardhoded as /opt/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-
	wiringPi/wirinPi/arch.mk - drives supported architectures and compilation settings.
	My working environment - CentOS6.
