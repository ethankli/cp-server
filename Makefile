# intial setup of our toolchain
CXX := clang++
CXXFLAGS := -pedantic-errors -Wall -Wextra -Werror -g -std=c++17
LDFLAGS := -L/usr/lib -lstdc++ -lm
# store our artifacts and objects
BUILD := ./build
OBJ_DIR := $(BUILD)/objects
EXEC_DIR := $(BUILD)/artifacts
# appname
TARGET := cp-server

# source files
INCLUDE := -Iinclude/
SRC := $(wildcard src/*.cpp)
OBJECTS := $(SRC:%.cpp=$(OBJ_DIR)/%.o)
DEPENDENCIES := $(OBJECTS:.o=.d)

# just in case...
.PHONY: all build clean debug release info

# default
all: build $(EXEC_DIR)/$(TARGET)

# compile and link our objects
$(OBJ_DIR)/%.o: %.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $(INCLUDE) -c $< -MMD -o $@

# compile the program
$(EXEC_DIR)/$(TARGET): $(OBJECTS)
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -o $(EXEC_DIR)/$(TARGET) $^ $(LDFLAGS)

-include $(DEPENDENCIES)

build:
	@mkdir -p $(EXEC_DIR)
	@mkdir -p $(OBJ_DIR)

debug: CXXFLAGS += -DDEBUG -g
debug: all

release: CXXFLAGS += -O2
release: all

# cleanup
clean:
	-@rm -rvf $(OBJ_DIR)/*
	-@rm -rvf $(EXEC_DIR)/*
