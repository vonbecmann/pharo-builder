#! /bin/bash
DIRECTORY=$(dirname $PWD)
guile -L ${DIRECTORY} -l builder.scm
