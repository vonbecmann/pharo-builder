#! /bin/bash
DIRECTORY=$(dirname $PWD)
guile -L ${DIRECTORY} -l console-builder.scm
