#!/bin/bash


#################################
# input
#################################
STARTYEAR=2021
STARTDAY=07
STARTMONTH=11
STARTHOUR=00
ENDHOUR=06

ROOTDIR=$(find $HOME -type d -name BA_Sokol_09971444)
WRFROOT=$ROOTDIR/WRF
POSTDIR=$WRFROOT/ARWpost
WRFDIR=$WRFROOT/WRF-ARW
CONFIGDIR=$WRFROOT/config

export LIBDIR=$WRFROOT/libs
export LD_LIBRARY_PATH=$LIBDIR/netcdf/lib:$LD_LIBRARY_PATH
export PATH=$LIBDIR/mpich/bin:$PATH

#################################
# update namelist.arwp
#################################
cp $CONFIGDIR/namelist.ARWpost $POSTDIR/namelist.ARWpost
sed -i "s/STARTYEAR/$STARTYEAR/g" $POSTDIR/namelist.ARWpost
sed -i "s/STARTDAY/$STARTDAY/g" $POSTDIR/namelist.ARWpost
sed -i "s/STARTMONTH/$STARTMONTH/g" $POSTDIR/namelist.ARWpost
sed -i "s/STARTHOUR/$STARTHOUR/g" $POSTDIR/namelist.ARWpost

sed -i "s/ENDYEAR/$STARTYEAR/g" $POSTDIR/namelist.ARWpost
sed -i "s/ENDDAY/$STARTDAY/g" $POSTDIR/namelist.ARWpost
sed -i "s/ENDMONTH/$STARTMONTH/g" $POSTDIR/namelist.ARWpost
sed -i "s/ENDHOUR/$ENDHOUR/g" $POSTDIR/namelist.ARWpost
sed -i "s|WRFPATH|$WRFDIR|g" $POSTDIR/namelist.ARWpost


cd $POSTDIR
./ARWpost.exe

