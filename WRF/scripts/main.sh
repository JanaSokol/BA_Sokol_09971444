#!/bin/bash

#################################
# input
#################################
TYPE=$1
STARTDAY=$2
STARTMONTH=$3
STARTYEAR=$4
STARTHOUR=00
ENDHOUR=120 # default 120
time_step=12 
time_step_in_seconds=$(($time_step * 3600))

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
CONFIGDIR=$WRFROOT/config/$TYPE
GEOGDIR=$WRFROOT/GEOG

OUTPUTDIR=$WRFDIR/run/$TYPE
rm -rf $OUTPUTDIR
mkdir $OUTPUTDIR

export LIBDIR=$WRFROOT/libs
export LD_LIBRARY_PATH=$LIBDIR/netcdf/lib:$LD_LIBRARY_PATH
export PATH=$LIBDIR/mpich/bin:$PATH
export PATH=$WRFROOT/GrADs/Contents:$PATH

#################################
# remove previous created files
#################################
# clean up WPS
rm -rf $WPSDIR/$TYPE:*
rm -rf $WPSDIR/met_em*
rm -rf $WPSDIR/ungrib.log
rm -rf $WPSDIR/metgrid.log
rm -rf $WPSDIR/GRIBFILE.*
rm -rf $WPSDIR/namelist.wps
rm -rf $WPSDIR/Vtable
rm -rf $WPSDIR/metgrid/METGRID.TBL.ARW
# clean up WRF
rm -rf $WRFDIR/run/wrfout*
rm -rf $WRFDIR/run/wrfbdy*
rm -rf $WRFDIR/run/wrfinput*
rm -rf $WRFDIR/run/rsl.*
rm -rf $WRFDIR/run/met_em*
rm -rf $WRFDIR/run/namelist.input

#################################
# calculating end
#################################
OLDENDHOUR=$ENDHOUR
TEMPENDHOUR=$(($ENDHOUR % 24))
TEMP=$(($ENDHOUR/24))
ENDHOUR=`printf "%02d\n" "${TEMPENDHOUR}"`
ENDDAY=$(($TEMP+STARTDAY))
ENDMONTH=$STARTMONTH
ENDYEAR=$STARTYEAR

case $STARTMONTH  in
    "1"|"3"|"5"|"7"|"8"|"10")
         if (($ENDDAY > 31 )) 
         then 
            echo "case 1"
            ENDDAY=$(($ENDDAY-31))
            ENDMONTH=$(($ENDMONTH+1))
         fi;;
    "4"|"6"|"9"|"11") 
         if (($ENDDAY > 30 )) 
         then 
            echo "case 2"
            ENDDAY=$(($ENDDAY-30))
            ENDMONTH=$(($ENDMONTH+1))
         fi;;
    "2") 
         if (($ENDDAY > 28 )) 
         then 
            echo "case 3"
            ENDDAY=$(($ENDDAY-28))
            ENDMONTH=$(($ENDMONTH+1))
         fi;;
    "12") 
         if (($ENDDAY > 31 )) 
         then 
            echo "case 4"
            ENDDAY=$(($ENDDAY-31))
            ENDMONTH=1
            ENDYEAR=$(($STARTYEAR+1))
         fi;;
    *) echo "Wrong Month"; exit 1 ;;
esac
#################################
# update namelist.wps
#################################
cp $CONFIGDIR/namelist.wps $WPSDIR/namelist.wps
sed -i "s/STARTYEAR/$STARTYEAR/g" $WPSDIR/namelist.wps
sed -i "s/STARTDAY/$STARTDAY/g" $WPSDIR/namelist.wps
sed -i "s/STARTMONTH/$STARTMONTH/g" $WPSDIR/namelist.wps
sed -i "s/STARTHOUR/$STARTHOUR/g" $WPSDIR/namelist.wps

sed -i "s/ENDYEAR/$ENDYEAR/g" $WPSDIR/namelist.wps
sed -i "s/ENDMONTH/$ENDMONTH/g" $WPSDIR/namelist.wps
sed -i "s/ENDDAY/$ENDDAY/g" $WPSDIR/namelist.wps
sed -i "s/ENDHOUR/$ENDHOUR/g" $WPSDIR/namelist.wps

sed -i "s|GEOGPATH|$GEOGDIR|g" $WPSDIR/namelist.wps
sed -i "s/INTERVAL/$time_step_in_seconds/g" $WPSDIR/namelist.wps

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
fi

ln -s ungrib/Variable_Tables/Vtable.$TYPE ./Vtable
#################################
# ungrib and metgrid
#################################
./link_grib.csh $WRFROOT/DATA/$TYPE/
cp $CONFIGDIR/METGRID.TBL.ARW $WPSDIR/metgrid/METGRID.TBL.ARW
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

sed -i "s/ENDYEAR/$ENDYEAR/g" $WRFDIR/run/namelist.input
sed -i "s/ENDDAY/$ENDDAY/g" $WRFDIR/run/namelist.input
sed -i "s/ENDMONTH/$ENDMONTH/g" $WRFDIR/run/namelist.input
sed -i "s/ENDHOUR/$ENDHOUR/g" $WRFDIR/run/namelist.input

sed -i "s/INTERVAL/$time_step_in_seconds/g" $WRFDIR/run/namelist.input
sed -i "s/RUNHOURS/$OLDENDHOUR/g" $WRFDIR/run/namelist.input

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
mv -v wrfout* $OUTPUTDIR
