#!/bin/bash

STARTHOUR=$4
ENDHOUR=$5

ROOTDIR=$(find $HOME -type d -name BA_Sokol_09971444)
WRFROOT=$ROOTDIR/WRF
CONFIGDIR=$WRFROOT/config/

sed -i "s/STARTYEAR/$STARTYEAR/g" $CONFIGDIR/GFS/namelist.wps
sed -i "s/STARTDAY/$STARTDAY/g" $CONFIGDIR/ICON/namelist.wps

sed -i "s/STARTYEAR/$STARTYEAR/g" $CONFIGDIR/GFS/namelist.input
sed -i "s/STARTDAY/$STARTDAY/g" $CONFIGDIR/ICON/namelist.input

sed -i "s/STARTYEAR/$STARTYEAR/g" $CONFIGDIR/GFS/namelist.ARWpost
sed -i "s/STARTDAY/$STARTDAY/g" $CONFIGDIR/ICON/namelist.ARWpost

