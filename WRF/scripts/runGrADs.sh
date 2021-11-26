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
# calculating end
#################################
TEMPENDHOUR=$(($ENDHOUR % 24))
TEMP=$(($ENDHOUR/24))
AMOUNT_OF_FILES=$(($ENDHOUR/$time_step))
AMOUNT_OF_FILES=$(($AMOUNT_OF_FILES + 1))
ENDHOUR=`printf "%02d\n" "${TEMPENDHOUR}"`
ENDDAY=$(($TEMP+STARTDAY))
ENDMONTH=$STARTMONTH
ENDYEAR=$STARTYEAR

case $STARTMONTH  in
    "1"|"3"|"5"|"7"|"8"|"10")
         if (($ENDDAY > 31 )) 
         then 
            echo "case 1"
            ENDDAY=`printf "%02d\n" "$(($ENDDAY-31))"`
            ENDMONTH=`printf "%02d\n" "$(($ENDMONTH+1))"`
         fi;;
    "4"|"6"|"9"|"11") 
         if (($ENDDAY > 30 )) 
         then 
            echo "case 2"
            ENDDAY=`printf "%02d\n" "$(($ENDDAY-30))"`
            ENDMONTH=`printf "%02d\n" "$(($ENDMONTH+1))"`
         fi;;
    "2") 
         if (($ENDDAY > 28 )) 
         then 
            echo "case 3"
            ENDDAY=`printf "%02d\n" "$(($ENDDAY-28))"`
            ENDMONTH=`printf "%02d\n" "$(($ENDMONTH+1))"`
         fi;;
    "12") 
         if (($ENDDAY > 31 )) 
         then 
            echo "case 4"
            ENDDAY=`printf "%02d\n" "$(($ENDDAY-31))"`
            ENDMONTH=01
            ENDYEAR=$(($STARTYEAR+1))
         fi;;
    *) echo "Wrong Month"; exit 1 ;;
esac

#################################
# update namelist.arwp
#################################
cp $CONFIGDIR/namelist.ARWpost $POSTDIR/namelist.ARWpost
sed -i "s/STARTYEAR/$STARTYEAR/g" $POSTDIR/namelist.ARWpost
sed -i "s/STARTDAY/$STARTDAY/g" $POSTDIR/namelist.ARWpost
sed -i "s/STARTMONTH/$STARTMONTH/g" $POSTDIR/namelist.ARWpost
sed -i "s/STARTHOUR/$STARTHOUR/g" $POSTDIR/namelist.ARWpost

sed -i "s/ENDYEAR/$ENDYEAR/g" $POSTDIR/namelist.ARWpost
sed -i "s/ENDDAY/$ENDDAY/g" $POSTDIR/namelist.ARWpost
sed -i "s/ENDMONTH/$ENDMONTH/g" $POSTDIR/namelist.ARWpost
sed -i "s/ENDHOUR/$ENDHOUR/g" $POSTDIR/namelist.ARWpost
sed -i "s|WRFPATH|$WRFDIR|g" $POSTDIR/namelist.ARWpost

sed -i "s/INTERVAL/$time_step_in_seconds/g" $POSTDIR/namelist.ARWpost

cd $POSTDIR
rm -rf $WRFDIR/run/ARWpost
mkdir $WRFDIR/run/ARWpost

./ARWpost.exe

cd $WRFDIR/run/ARWpost
GADDIR=$WRFROOT/GrADs

export GADDIR=/home/jana/Documents/GitHub/BA_Sokol_09971444/WRF/GrADs/Classic/data/
export GASCRP="$GADDIR/Contents/Resources/Scripts"
export GAUDPT=$WRFROOT/GrADs/udpt

cp $WRFROOT/scripts/visualizeWRF.gs $WRFROOT/GrADs/Contents/Resources/Scripts/visualizeWRF.gs
sed -i "s/AMOUNT_OF_FILES/$AMOUNT_OF_FILES/g" $WRFROOT/GrADs/Contents/Resources/Scripts/visualizeWRF.gs
rm $WRFROOT/GrADs/udpt
cp $WRFROOT/config/udpt $WRFROOT/GrADs/udpt

filename="${TYPE}_arwpost_${STARTYEAR}-${STARTMONTH}-${STARTDAY}_${STARTHOUR}-${ENDYEAR}-${ENDMONTH}-${ENDDAY}_${ENDHOUR}"

grads -bpcx 'visualizeWRF.gs '$filename' '$TYPE
mv -v ${TYPE}_*.png $ROOTDIR/backend/target/classes/${TYPE}_IMAGES
