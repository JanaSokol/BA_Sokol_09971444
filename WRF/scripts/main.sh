#!/bin/bash

#################################
# input
#################################
STARTYEAR=2021
STARTDAY=22
STARTMONTH=10
STARTHOUR=00
ENDHOUR=06

#################################
# enviroment variables
#################################
cd ..
WRFROOT=`pwd`
WPSDIR=$WRFROOT/WPS
WRFDIR=$WRFROOT/WRF
SCRIPTDIR=$WRFROOT/scripts
CONFIGDIR=$WRFROOT/config

export LIBDIR=$WRFROOT/libs
export LD_LIBRARY_PATH=$LIBDIR/netcdf/lib:$LD_LIBRARY_PATH
export PATH=$LIBDIR/mpich/bin:$PATH

#################################
# remove previous created files
#################################
# clean up WPS
rm -rf $WPSDIR/FILE:*
rm -rf $WPSDIR/met_em*
rm -rf $WPSDIR/ungrib.log
rm -rf $WPSDIR/metgrid.log
rm -rf $WPSDIR/GRIBFILE.*
rm -rf $WPSDIR/namelist.wps
# clean up WRF
rm -rf $WRFDIR/run/wrfout*
rm -rf $WRFDIR/run/wrfbdy*
rm -rf $WRFDIR/run/wrfinput*
rm -rf $WRFDIR/run/rsl.*
rm -rf $WRFDIR/run/met_em*
rm -rf $WRFDIR/run/namelist.input

#################################
# downloading GFS
#################################
echo " " 
echo "********** Downloading GFS Data **********"
echo " " 
bash $SCRIPTDIR/download_gfs.sh $STARTYEAR $STARTMONTH $STARTDAY $STARTHOUR

#################################
# update namelist.wps
#################################
cp $CONFIGDIR/namelist.wps $WPSDIR/namelist.wps
sed -i "s/STARTYEAR/$STARTYEAR/g" $WPSDIR/namelist.wps
sed -i "s/STARTDAY/$STARTDAY/g" $WPSDIR/namelist.wps
sed -i "s/STARTMONTH/$STARTMONTH/g" $WPSDIR/namelist.wps
sed -i "s/STARTHOUR/$STARTHOUR/g" $WPSDIR/namelist.wps

sed -i "s/ENDYEAR/$STARTYEAR/g" $WPSDIR/namelist.wps
sed -i "s/ENDMONTH/$STARTMONTH/g" $WPSDIR/namelist.wps
sed -i "s/ENDDAY/$STARTDAY/g" $WPSDIR/namelist.wps
sed -i "s/ENDHOUR/$ENDHOUR/g" $WPSDIR/namelist.wps

#################################
# geogrid
#################################
cd $WPSDIR
FILE=$WPSDIR/geo_em.d01.nc
if test -f "$FILE"; then
    echo "$FILE exists."
else
    echo "create domain."
    ./georgrid.exe
fi


#################################
# ungrib and metgrid
#################################
./link_grib.csh $WRFROOT/GFS/
echo " "
echo "********** Running ungrib **********"
echo " "
./ungrib.exe
echo " "
echo "********** Running metgrid **********"
echo " "
./metgrid.exe

#################################
# update namelist.input
#################################
cp $CONFIGDIR/namelist.input $WRFDIR/run/namelist.input
sed -i "s/STARTYEAR/$STARTYEAR/g" $WRFDIR/run/namelist.input
sed -i "s/STARTDAY/$STARTDAY/g" $WRFDIR/run/namelist.input
sed -i "s/STARTMONTH/$STARTMONTH/g" $WRFDIR/run/namelist.input
sed -i "s/STARTHOUR/$STARTHOUR/g" $WRFDIR/run/namelist.input

sed -i "s/ENDYEAR/$STARTYEAR/g" $WRFDIR/run/namelist.input
sed -i "s/ENDDAY/$STARTDAY/g" $WRFDIR/run/namelist.input
sed -i "s/ENDMONTH/$STARTMONTH/g" $WRFDIR/run/namelist.input
sed -i "s/ENDHOUR/$ENDHOUR/g" $WRFDIR/run/namelist.input

#################################
# wrf
#################################
cd $WRFDIR/run
ln -s $WPSDIR/met_em* .
echo " "
echo "********** Running real **********"
echo " "
mpirun -n 2 ./real.exe
echo " "
echo "********** Running WRF **********"
echo " "
mpirun -n 3 ./wrf.exe



