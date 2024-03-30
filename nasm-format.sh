#!/bin/sh
if [ $1="i386" ]
then
  echo "elf32"
elif [ $1="x86_64" ]
then
  echo "elf64"
else
  echo "$1" | grep -Eo '^[[:alnum:]_]*'
fi