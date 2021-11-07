#!/bin/bash

ROOTDIR=$(find $HOME -type d -name BA_Sokol_09971444)
WRFROOT=$ROOTDIR/WRF
POSTDIR=$WRFROOT/ARWpost
WRFDIR=$WRFROOT/WRF-ARW
SCRIPTDIR=$WRFROOT/scripts

export LIBDIR=$WRFROOT/libs
export LD_LIBRARY_PATH=$LIBDIR/netcdf/lib:$LD_LIBRARY_PATH
export PATH=$LIBDIR/mpich/bin:$PATH

echo "Here"
cd $POSTDIR
./ARWpost.exe

echo "Here2"
