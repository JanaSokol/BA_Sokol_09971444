#!/bin/bash


#################################
# input
#################################
TYPE=$1
STARTDAY=$2
STARTMONTH=$3
STARTYEAR=$4
STARTHOUR=$5
ENDHOUR=06

ROOTDIR=$(find $HOME -type d -name BA_Sokol_09971444)
WRFROOT=$ROOTDIR/WRF
POSTDIR=$WRFROOT/ARWpost
WRFDIR=$WRFROOT/WRF-ARW
CONFIGDIR=$WRFROOT/config/$TYPE

export LIBDIR=$WRFROOT/libs
export LD_LIBRARY_PATH=$LIBDIR/netcdf/lib:$LD_LIBRARY_PATH
export PATH=$LIBDIR/mpich/bin:$PATH
export PATH=$WRFROOT/GrADs/Contents:$PATH

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
rm -rf $WRFDIR/run/ARWpost
mkdir $WRFDIR/run/ARWpost

./ARWpost.exe

cd $WRFDIR/run/ARWpost
GADDIR=$WRFROOT/GrADs

export GADDIR=$GADDIR
export GASCRP="$GADDIR/Contents/Resources/Scripts"
export GAUDPT=$GADDIR/udpt

cp $WRFROOT/scripts/visualizeWRF.gs $WRFROOT/GrADs/Contents/Resources/Scripts/visualizeWRF.gs

grads -bpcx 'visualizeWRF.gs arwpost_output'

