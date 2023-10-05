FC = gfortran

TARGET ?= nohex

BUILD_DIR ?= bin
SRC_DIR ?= src

SRCS := $(shell find $(SRC_DIR) -name '*.f90')
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)

$(BUILD_DIR)/$(TARGET): $(OBJS)
	$(FC) $(OBJS) -o $@

$(BUILD_DIR)/%.f90.o: %.f90
	mkdir -p $(dir $@)
	$(FC) -c $< -o $@

.PHONY: run clean

run: $(BUILD_DIR)/$(TARGET)
	$(BUILD_DIR)/$(TARGET)

clean:
	rm -r $(BUILD_DIR)
