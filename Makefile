.PHONY: all clean 

CXX 	    = g++
LD          = g++
NVCC        = nvcc
CXXFLAGS    = -O3 -I$(INC_DIR) -march=native -Wall -Wextra -fopenmp -ggdb
NVCCFLAGS   = -O3 -arch=native
LDFLAGS     = -fopenmp
SRC_DIR     = ./src
INC_DIR     = ./inc
OBJ_DIR     = ./obj
BIN_DIR     = ./build
TARGET 	    = $(BIN_DIR)/xyz

all: $(TARGET)

$(TARGET): $(OBJ_DIR)/lv.o | $(BIN_DIR)
	$(LD) $(LDFLAGS) $^ -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp $(INC_DIR)/*.h | $(OBJ_DIR)
	$(CXX) -c $(CXXFLAGS) $< -o $@

clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

$(OBJ_DIR) $(BIN_DIR):
	mkdir -p $@