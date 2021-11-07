#!/bin/bash

#################################
# input
#################################
STARTYEAR=$3
STARTDAY=$1
STARTMONTH=$2
STARTHOUR=$4
ENDHOUR=06

#################################
# error handling
#################################

exit_upon_error(){
    echo "Error: $1"
    exit 1
}

#################################
# enviroment variables
#################################

ROOTDIR=$(find $HOME -type d -name BA_Sokol_09971444)
WRFROOT=$ROOTDIR/WRF
WPSDIR=$WRFROOT/WPS
WRFDIR=$WRFROOT/WRF-ARW
SCRIPTDIR=$WRFROOT/scripts
CONFIGDIR=$WRFROOT/config
GEOGDIR=$WRFROOT/GEOG

export LIBDIR=$WRFROOT/libs
export LD_LIBRARY_PATH=$LIBDIR/netcdf/lib:$LD_LIBRARY_PATH
export PATH=$LIBDIR/mpich/bin:$PATH
export PATH=$WRFROOT/GrADs/Contents:$PATH

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

sed -i "s|GEOGPATH|$GEOGDIR|g" $WPSDIR/namelist.wps

#################################
# geogrid
#################################
echo " " 
echo "*********** Running geogrid *********** "
echo " " 
cd $WPSDIR
FILE=$WPSDIR/geo_em.d01.nc
if test -f "$FILE"; then
    echo "$FILE already exists."
else
    echo "create domain."
    ./geogrid.exe || exit_upon_error "geogrid.exe failed"
    ln -s ungrib/Variable_Tables/Vtable.GFS ./Vtable

    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! "
    echo "!  Successful completion of geogrid.  ! "
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! "
fi


#################################
# ungrib and metgrid
#################################
./link_grib.csh $WRFROOT/GFS/
echo " " 
echo "*********** Running ungrib ************ "
echo " " 
./ungrib.exe || exit_upon_error "ungrib.exe failed"
echo " " 
echo "*********** Running metgrid *********** "
echo " " 
./metgrid.exe || exit_upon_error "metgrid.exe failed"

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
echo "*********** Running real ************** "
echo " "
mpirun -n 2 ./real.exe || exit_upon_error "real.exe failed"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! "
echo "!    Successful completion of real.   ! "
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! "

echo ""
echo "*********** Running WRF *************** "
echo "This might take a few minutes. "
mpirun -n 3 ./wrf.exe || exit_upon_error "wrf.exe failed"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! "
echo "!    Successful completion of WRF.    ! "
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! "
