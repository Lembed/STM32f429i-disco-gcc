#STM32f429-discovery-gcc


gcc toolchain application template for STM32F429 discovery


## build at docker container

```bash
git clone https://github.com/Lembed/Docker-Arm-Gcc-Toolchain.git STM32F429-GCC
docker build -t="STM32F429-GCC" .
docker run  -v $(pwd):/opt/avr -it STM32F429-GCC bash
make
```

