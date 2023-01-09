gdb-multiarch -ex 'set architecture arm' -ex 'file ../src/build/kernel' -ex 'target remote tcp:localhost:1234' -ex 'layout regs'
