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
ENDHOUR=${TEMPENDHOUR}
ENDDAY=$(($TEMP+STARTDAY))
ENDMONTH=${STARTMONTH}
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
            ENDMONTH=01
            ENDYEAR=$(($STARTYEAR+1))
         fi;;
    *) echo "Wrong Month"; exit 1 ;;
esac

#################################
# update namelist.arwp
#################################
sday=`printf "%02d\n" "$STARTDAY"`
eday=`printf "%02d\n" "$ENDDAY"`
smon=`printf "%02d\n" "$STARTMONTH"`
emon=`printf "%02d\n" "$ENDMONTH"`
shour=`printf "%02d\n" "$STARTHOUR"`
ehour=`printf "%02d\n" "$ENDHOUR"`

cp $CONFIGDIR/namelist.ARWpost $POSTDIR/namelist.ARWpost
sed -i "s/STARTYEAR/$STARTYEAR/g" $POSTDIR/namelist.ARWpost
sed -i "s/STARTDAY/$sday/g" $POSTDIR/namelist.ARWpost
sed -i "s/STARTMONTH/$smon/g" $POSTDIR/namelist.ARWpost
sed -i "s/STARTHOUR/$shour/g" $POSTDIR/namelist.ARWpost

sed -i "s/ENDYEAR/$ENDYEAR/g" $POSTDIR/namelist.ARWpost
sed -i "s/ENDDAY/$eday/g" $POSTDIR/namelist.ARWpost
sed -i "s/ENDMONTH/$emon/g" $POSTDIR/namelist.ARWpost
sed -i "s/ENDHOUR/$ehour/g" $POSTDIR/namelist.ARWpost
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

filename="${TYPE}_arwpost_${STARTYEAR}-${smon}-${sday}_${shour}-${ENDYEAR}-${emon}-${eday}_${ehour}"

grads -bpcx 'visualizeWRF.gs '$filename' '$TYPE

TARGETDIR=$ROOTDIR/backend/target/classes/${TYPE}_IMAGES_GRADS
rm -rf $TARGETDIR
mkdir $TARGETDIR
mv -v ${TYPE}_*.png $TARGETDIR

cd $TARGETDIR

for i in *.png ; do convert $i -crop 1854x2300+0+0 $i ; done

for i in *.png ; do convert -trim $i $i ; done






