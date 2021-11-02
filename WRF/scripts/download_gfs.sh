#!/bin/bash

ROOTDIR=$(find $HOME -type d -name BA_Sokol_09971444)
inputdir=$ROOTDIR/WRF/GFS/
rm -rf $inputdir
mkdir $inputdir

year=$3
month=$2
day=$1
cycle=$4

for ((i=000; i<=006; i+=3))
do
    ftime=`printf "%03d\n" "${i}"`

    server=https://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod
    directory=gfs.${year}${month}${day}/${cycle}/atmos
    file=gfs.t${cycle}z.pgrb2.0p50.f${ftime}

    url=${server}/${directory}/${file}

    echo $url

    wget -O ${inputdir}/${file} ${url}

done
