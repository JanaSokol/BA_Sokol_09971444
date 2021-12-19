#!/bin/bash

#################################
# input
#################################
TYPE=$1
STARTDAY=`printf "%02d\n" "${2}"`
STARTMONTH=`printf "%02d\n" "${3}"`
STARTYEAR=$4
STARTHOUR=00
ENDHOUR=120 # default 120
time_step=12 


ROOTDIR=$(find $HOME -type d -name BA_Sokol_09971444)
WRFROOT=$ROOTDIR/WRF
WRFDIR=$WRFROOT/WRF-ARW


DIR=$WRFDIR/run/$TYPE/wrfout_d01_${STARTYEAR}-${STARTMONTH}-${STARTDAY}_00:00:00.nc

cd $(find $HOME -type d -name anaconda3)/bin/
source activate ncl_stable
cd $WRFROOT/scripts

FILEOUT="${TYPE}_NCL"
TITLE="${TYPE} Temperature for "
cp $WRFROOT/scripts/ncl.ncl $WRFROOT/scripts/ncltemp.ncl
sed -i "s|FILENAME|$DIR|g" $WRFROOT/scripts/ncltemp.ncl
sed -i "s/FILEOUT/$FILEOUT/g" $WRFROOT/scripts/ncltemp.ncl
sed -i "s/TITLE/$TITLE/g" $WRFROOT/scripts/ncltemp.ncl

timeout 10 ncl ncltemp.ncl

rm -rf $WRFROOT/scripts/ncltemp.ncl


TARGETDIR=$ROOTDIR/backend/target/classes/${TYPE}_IMAGES_NCL
rm -rf $TARGETDIR
mkdir $TARGETDIR

mv -v ${TYPE}_*.png $TARGETDIR

cd $TARGETDIR

for i in *.png ; do convert $i -crop 1854x2300+0+0 $i ; done

for i in *.png ; do convert -trim $i $i ; done
