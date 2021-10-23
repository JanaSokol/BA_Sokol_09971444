#!/bin/bash

# input
STARTYEAR=2021
STARTDAY=22
STARTMONTH=10
STARTHOUR=00
RUNLENGTH=6

# enviroment variables
WRFROOT=/home/jana/Documents/GitHub/BA_Sokol_09971444/WRF
WPSDIR=$WRFROOT/WPS
WRFDIR=$WRFROOT/WRF
SCRIPTDIR=$WRFROOT/scripts
CONFIGDIR=$WRFROOT/config

# remove previous created files and logs
# cleanup WPS
rm -rf $WPSDIR/FILE:*
rm -rf $WPSDIR/met_em*
rm -rf $WPSDIR/ungrib.log
rm -rf $WPSDIR/metgrid.log
rm -rf $WPSDIR/GRIBFILE.*
rm -rf $WPSDIR/namelist.wps

#cleanup WRF
rm -rf $WRFDIR/run/wrfout*
rm -rf $WRFDIR/run/wrfbdy*
rm -rf $WRFDIR/run/wrfinput*
rm -rf $WRFDIR/run/rsl.*
rm -rf $WRFDIR/run/met_em*
rm -rf $WRFDIR/run/namelist.input

# downloading GFS
echo "downloading GFS data"
bash $SCRIPTDIR/download_gfs.sh $STARTYEAR $STARTMONTH $STARTDAY $STARTHOUR

# update namelist.wps
echo "setting namelist.wps"
cp $CONFIGDIR/namelist.wps $WPSDIR/namelist.wps
sed -i "/s/STARTYEAR/$STARTYEAR/g" $WPSDIR/namelist.wps
sed -i "/s/STARTDAY/$STARTDAY/g" $WPSDIR/namelist.wps
sed -i "/s/STARTMONTH/$STARTMONTH/g" $WPSDIR/namelist.wps
sed -i "/s/STARTHOUR/$STARTHOUR/g" $WPSDIR/namelist.wps

START="$STARTYEAR-$STARTMONTH-$STARTDAY $STARTHOUR:00:00Z"
END=`date -u --date="$START + $RUNLENGTH hours" + '%Y-%m-%d %H:00:00Z'`
ENDYEAR=`date -u --date="$END" +'%Y'`
ENDDAY=`date -u --date="$END" +'%m'`
ENDMONTH=`date -u --date="$END" +'%d'`
ENDHOUR=`date -u --date="$END" +'%H'`

sed -i "/s/ENDYEAR/$ENDYEAR/g" $WPSDIR/namelist.wps
sed -i "/s/ENDDAY/$ENDDAY/g" $WPSDIR/namelist.wps
sed -i "/s/ENDMONTH/$ENDMONTH/g" $WPSDIR/namelist.wps
sed -i "/s/ENDHOUR/$ENDHOUR/g" $WPSDIR/namelist.wps

# ungrib and metgrid
echo "running ungrib"
cd $WPSDIR
./link_grib.csh $WRFDIR/GFS/
./ungrib.exe
echo "running metgrid"
./metgrid.exe

# update namelist.input
echo "setting namelist.input"
cp $CONFIGDIR/namelist.input $WRFDIR/run/namelist.input
sed -i "/s/STARTYEAR/$STARTYEAR/g" $WRFDIR/run/namelist.input
sed -i "/s/STARTDAY/$STARTDAY/g" $WRFDIR/run/namelist.input
sed -i "/s/STARTMONTH/$STARTMONTH/g" $WRFDIR/run/namelist.input
sed -i "/s/STARTHOUR/$STARTHOUR/g" $WRFDIR/run/namelist.input

sed -i "/s/ENDYEAR/$ENDYEAR/g" $WRFDIR/run/namelist.input
sed -i "/s/ENDDAY/$ENDDAY/g" $WRFDIR/run/namelist.input
sed -i "/s/ENDMONTH/$ENDMONTH/g" $WRFDIR/run/namelist.input
sed -i "/s/ENDHOUR/$ENDHOUR/g" $WRFDIR/run/namelist.input

# wrf
cd $WRSDIR/run
ln -s $WPSDIR/met_em* .
echo "running real"
mpirun -n 2 ./real.exe
echo "running wrf"
mpirun -n 3 ./wrf.exe



