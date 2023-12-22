CC = g++ -lsystemc

Boundary = '../data/Dimenzije.txt'
pathIn = '../data/Input.txt'
pathOut = '../data/Output.txt'
Angle = 0
Direction = left

.PHONY: clean run
.DEFAULT_GOAL := main_d

main_d: main.o vp.o rotation.o cpu.o memory.o interconnect.o
	@$(CC) main.o rotation.o cpu.o vp.o memory.o interconnect.o -o main_d  
	@echo "Making main_d executable"

main.o: main.cpp vp.cpp vp.hpp
	@$(CC) -c main.cpp 
	@echo "Compiling main.cpp"

vp.o: vp.cpp vp.hpp common.hpp cpu.cpp cpu.hpp rotation.cpp rotation.hpp vp_address.hpp memory.hpp memory.cpp
	@$(CC) -c vp.cpp 
	@echo "Compiling vp.cpp"

rotation.o: rotation.cpp common.hpp rotation.hpp vp_address.hpp
	@$(CC) -c rotation.cpp 
	@echo "Compiling rotation.cpp"

cpu.o: cpu.hpp cpu.cpp vp_address.hpp rotation.cpp rotation.hpp common.hpp
	@$(CC) -c cpu.cpp 
	@echo "Compiling cpu.cpp"

memory.o: memory.cpp memory.hpp common.hpp vp_address.hpp cpu.hpp cpu.cpp rotation.hpp rotation.cpp
	@$(CC) -c memory.cpp 
	@echo "Compiling memory.cpp"

interconnect.o: interconnect.cpp interconnect.hpp common.hpp cpu.cpp cpu.hpp rotation.cpp rotation.hpp vp_address.hpp memory.hpp memory.cpp
	@$(CC) -c interconnect.cpp
	@echo "Compiling interconnect.cpp"

run:
	@make main_d
	@echo "Running executable target "
	@./main_d $(Boundary) $(pathIn) $(pathOut) $(Angle) $(Direction)

clean:
	@rm *.o main_d
	@echo "Deleting all .o files"
