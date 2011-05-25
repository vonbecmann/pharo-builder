#! /bin/bash
CURRENT_DIRECTORY=$(dirname $(readlink -nf $0))
BASE_DIRECTORY=$(dirname ${CURRENT_DIRECTORY})

guile -L ${BASE_DIRECTORY} -l ${CURRENT_DIRECTORY}/console-builder.scm
