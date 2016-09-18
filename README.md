#STM32f429-discovery-gcc


gcc toolchain application template for STM32F429 discovery


## build at docker container
build docker toolchain
```bash
git clone https://github.com/Lembed/Docker-Arm-Gcc-Toolchain.git STM32F429-GCC
cd STM32F429-GCC
docker build -t="stm32f429gcc" .
```

get source code and build with docker toolchain
```bash
get clone https://github.com/Lembed/STM32f429i-disco-gcc.git source
cd source
docker run  -v $(pwd):/opt/avr -it stm32f429gcc bash
make
```

