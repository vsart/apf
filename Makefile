FC=gfortran-6.2
FF=-O2 -Wall -Wextra -Wpedantic -Wno-tabs
AR=ar

all: test

test: main.f90 apf.o
	$(FC) $(FF) apf.o main.f90 -o test

apf.o: apf.f90
	$(FC) $(FF) -c apf.f90 -o apf.o
