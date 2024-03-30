#!/bin/sh
set -e
. ./iso.sh

qemu-system-$(./target-triplet-to-arch.sh $HOST) -cdrom build/tinyx.iso -serial telnet:localhost:4321,server,nowait
