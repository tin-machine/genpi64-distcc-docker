#!/bin/bash

aarch64-unknown-linux-gnu-gcc -c -I. -Iproto -DHAVE_CONFIG_H     -mtune=cortex-a72 -march=armv8-a+crc -O2 -pipe -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=1 /hello.c
# distccd --daemon --no-detach --log-level notice --log-stderr --allow-private
# distccd --log-level notice --log-stderr --allow-private
distccd --stats
