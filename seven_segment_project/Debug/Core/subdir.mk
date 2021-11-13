################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_SRCS += \
../Core/seven_segment_project.s 

OBJS += \
./Core/seven_segment_project.o 

S_DEPS += \
./Core/seven_segment_project.d 


# Each subdirectory must supply rules for building sources it contributes
Core/%.o: ../Core/%.s Core/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m0plus -g3 -DDEBUG -c -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@" "$<"

