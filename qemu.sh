#!/bin/sh
set -e
. ./iso.sh

qemu-system-$(./target-triplet-to-arch.sh $HOST) -m 4G -cdrom build/tinyx.iso -serial telnet:localhost:4321,server,nowait -d int
