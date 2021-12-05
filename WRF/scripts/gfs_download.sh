#!/bin/bash

ROOTDIR=$(find $HOME -type d -name BA_Sokol_09971444)
inputdir=$ROOTDIR/WRF/DATA/GFS/
rm -rf $inputdir
mkdir $inputdir

day=`printf "%02d\n" "${1}"`
month=`printf "%02d\n" "${2}"`
year=$3
time_step_start=00
time_step_end=120    # max 384, default 120
time_step=12        # must be a multiple of 3
cycle=00


#################################
# error handling
#################################

exit_upon_error(){
    echo "Error: $1"
    exit 1
}

#################################
# downloading gfs data
#################################

for ((i=$time_step_start; i<=$time_step_end; i+=$time_step))
do
    ftime=`printf "%03d\n" "${i}"`
    server=https://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod
    directory=gfs.${year}${month}${day}/${cycle}/atmos
    file=gfs.t${cycle}z.pgrb2.0p50.f${ftime}
    outfile=GFS_${year}${month}${day}${cycle}_${ftime}.grib

    url=${server}/${directory}/${file}

    echo $url

    wget -O ${inputdir}${outfile} ${url} || exit_upon_error "download failed"

done
exit 0
