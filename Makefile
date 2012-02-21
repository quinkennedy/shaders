SRC=first.cpp
OBJ=$(SRC:.cpp=.o)
EXE=$(SRC:.cpp=.exe)
CC=g++

all:
	$(CC) -c -o $(OBJ) $(SRC) -I"C:\Program Files (x86)\Programming\CodeBlocks\MinGW\include"
	$(CC) -o $(EXE) $(OBJ) -L"C:\Program Files (x86)\Programming\CodeBlocks\MinGW\lib" -lfreeglut -lopengl32
clean:
	del $(OBJ)
