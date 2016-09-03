FC=gfortran-6.2
FF=-O2 -Wall -Wextra -Wpedantic
AR=ar

all: main.f90 apf.f90
	$(FC) $(FF) -c -fPIC apf.f90 -o apf.o
	$(FC) $(FF) main.f90 apf.o -o test
	$(FC) $(FF) -shared apf.o -o libapf.so
