
Building
----
Ensure the following dependencies are met:
    - dev86 (tool chain to generate 8086 code): consists of bcc, as86, ld86
    - nasm
    - gcc/g++
    - bochs: for x86 emulation, including GUI debugger
    - cmake

Clone the reposity and build using cmake,
```bash
git clone https://github.com/b63/os16 && cd os16
cmake -Bbuild && cmake --build build
```

To launch bochs, the included `run.sh` script can be used.
```bash
./run.sh
```

References
----
1. [https://pages.cs.wisc.edu/~remzi/OSTEP/](https://pages.cs.wisc.edu/~remzi/OSTEP/)
1. [https://dl.acm.org/doi/10.1145/1539024.1509022](https://dl.acm.org/doi/10.1145/1539024.1509022)
