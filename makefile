PROJECTNAME = FreeRTOS

# support library 
SUPPORTDIR = $(TOPDIR)/Library
HAL_DRIVER = $(SUPPORTDIR)/STM32F4xx_HAL_Driver
CMSIS = $(SUPPORTDIR)/CMSIS
BSP = $(SUPPORTDIR)/BSP
FREERTOS = $(SUPPORTDIR)/FreeRTOS
SCRIPTS = $(TOPDIR)/Scripts

# include directionary define
CMSISINC  = $(CMSIS)/Include/
CMSISINC2  = $(CMSIS)/Device/ST/STM32F4xx/Include/
BSPINC = $(BSP)/
FREERTOSINC = $(FREERTOS)/Source/portable/GCC/ARM_CM4F
FREERTOSINC2 = $(FREERTOS)/Source/CMSIS_RTOS/
HAL_DRIVERINC = $(HAL_DRIVER)/Inc/


OBJDIR = obj
OUTDIR = bin
SRCDIR = src

EXTRAINCDIRS  = $(CMSISINC) $(CMSISINC2) $(BSPINC) $(FREERTOSINC) $(FREERTOSINC2) $(HAL_DRIVERINC) $(TOPDIR)

# GNU ARM Embedded Toolchain
CC=arm-none-eabi-gcc
CXX=arm-none-eabi-g++
LD=arm-none-eabi-ld
AR=arm-none-eabi-ar
AS=arm-none-eabi-as
OBJCOPY=arm-none-eabi-objcopy
OD=arm-none-eabi-objdump
NM=arm-none-eabi-nm
SIZE=arm-none-eabi-size


# output file define
BIN = $(OUTDIR)/$(PROJECTNAME).bin
OUT = $(OUTDIR)/$(PROJECTNAME).elf


#User Source files
SRC := $(wildcard $(SRCDIR)/*.c)
SRC += $(wildcard $(SRCDIR)/*.s)

# include library path
CFLAGS += $(patsubst %,-I%,$(EXTRAINCDIRS)) -I.

#Library Source Files
SRC += $(wildcard $(HAL_DRIVER)/Src/*.c)
SRC += $(CMSIS)\Device\ST\STM32F4xx\Source\Templates\gcc\startup_stm32f429xx.s
SRC += $(BSP)/stm32f429i_discovery.c
SRC += $(CMSIS)/system_stm32f4xx.c
SRC += $(FREERTOS)/Source/list.c
SRC += $(FREERTOS)/Source/queue.c
SRC += $(FREERTOS)/Source/tasks.c
SRC += $(FREERTOS)/Source/timers.c
SRC += $(FREERTOS)/Source/CMSIS_RTOS/cmsis_os.c
SRC += $(FREERTOS)/Source/portable/port.c
SRC += $(FREERTOS)/Source/portable/heap_4.c

CFLAGS += --specs=rdimon.specs -lc -lrdimon 

OBJS = $(addprefix $(OBJDIR)/, $(notdir $(addsuffix .o, $(basename $(SRC)))))

# source code search path
VPATH := $(SRCDIR)
VPATH += $(HAL_DRIVER)/Src
VPATH += $(BSP)/
VPATH += $(CMSIS)/
VPATH += $(FREERTOS)/Source
VPATH += $(FREERTOS)/Source/CMSIS_RTOS
VPATH += $(FREERTOS)/Source/portable/GCC/ARM_CM4F
VPATH += $(FREERTOS)/Source/portable/MemMang

#Additional compilation options
CFLAGS += -std=c99 -g -DSTM32F429xx -DARM_MATH_CM4 -D__FPU_PRESENT -DUSE_HAL_DRIVER -DUSE_STM32F429I_DISCO
CFLAGS += -mlittle-endian -mthumb -mcpu=cortex-m4
CFLAGS += -T$(SCRIPTS)/STM32F429ZI_FLASH.ld -mfloat-abi=hard -mfpu=fpv4-sp-d16 -march=armv7e-m -mtune=cortex-m4

$(OBJDIR)/%.o: $(notdir %.c)
	-mkdir $(subst /,\\,$(@D))
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJDIR)/%.o: $(notdir %.s)
	-mkdir $(subst /,\\,$(@D))
	$(CC) $(CFLAGS) -xassembler-with-cpp -c $< -o $@

$(OUT): $(OBJS)
	-mkdir $(subst /,\\,$(@D))
	$(CC) $(CFLAGS) $^ -o $@

all: $(OUT)
	-mkdir $(subst /,\\,$(@D))
	arm-none-eabi-objcopy $(OUT) $(BIN) -O binary

flash:
	openocd -f board/stm32f4discovery.cfg -f $(SCRIPTS)/flash.cfg

debug:
	@echo $(SRC)
