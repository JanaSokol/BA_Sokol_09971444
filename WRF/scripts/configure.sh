#!/bin/bash

cd ..
WRFROOT=`pwd`
DOWNLOADSDIR=$WRFROOT/downloads/



for i in *.gz ; do tar xzf $i ; done
for i in *.zip ; do tar xzf $i ; done

export LIBDIR=$WRFROOT/libs
