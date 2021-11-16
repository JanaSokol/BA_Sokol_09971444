#!/bin/bash

export field_3d=(relhum u v t fi) 
export field_2d=(td_2m t_2m relhum_2m u_10m v_10m ps pmsl h_snow w_snow t_g)
export field_1d=(hsurf fr_land)
export field_soil=(t_so w_so)

export arry_wso=(0 1 3 9 27 81 243)
export arry_tso=(2 5 6 18 54 162 486)
export levels_3d=(1000 950 925 900 875 850 825 800 775 700 600 500 400 300 250 200 150 100 70 50)

export wget_opt="--no-check-certificate -T 25 -t 3 -nd -nc -np -r -erobots=off --level=1"

setzaxis () {
file_conf=$1
 echo "zaxistype = depth_below_land" > ${file_conf}
 echo "size = 7" >> ${file_conf}
 echo "name = depth" >> ${file_conf}
 echo "longname = depth_below_land" >> ${file_conf}
 echo "units = cm" >> ${file_conf}
 echo "lbounds = 0 1 3 9 27 81 243" >> ${file_conf}
 echo "ubounds = 1 3 9 27 81 243 729" >> ${file_conf}
}

#################################
# input
#################################
year=$3
month=$2
day=$1
cycle=$4
ROOTDIR=$(find $HOME -type d -name BA_Sokol_09971444)
dirOutg=$ROOTDIR/WRF/DATA/ICON/
START_DATE=$year$month$day$cycle
czas=000

outfilegrib2=${dirOutg}/ICON-EU_${START_DATE}_${czas}.grib
date=${START_DATE:0:10}
dirOut="$dirOutg${czas}_tmp"

#################################
# error handling
#################################

exit_upon_error(){
    echo "Error: $1"
    exit 1
}

if [ ! -d ${dirOut} ]; then mkdir ${dirOut}; fi

#################################
# downloading 3D Fields
#################################
for pole in ${field_3d[@]} ; do
    uc_pole=${pole^^}
    mkdir ${dirOut}/${uc_pole}
    url_dir="https://opendata.dwd.de/weather/nwp/icon-eu/grib/${date:8:2}/${pole}"

    for level in ${levels_3d[@]} ; do
        currentlevel=${level^^}
        file=icon-eu_europe_regular-lat-lon_pressure-level_${date}_${czas}_${currentlevel}_${uc_pole}.grib2.bz2
        wget -O ${dirOut}/${uc_pole}/${file} ${url_dir}/${file} || exit_upon_error "download failed"
        bunzip2 ${dirOut}/${uc_pole}/${file}
        if [[ $pole == "fi" ]]; then
            cdo aexpr,"z=z/9.80665" ${dirOut}/${uc_pole}/icon-eu_europe_regular-lat-lon_pressure-level_${date}_${czas}_${currentlevel}_${uc_pole}.grib2 ${dirOut}/${uc_pole}/icon-eu_europe_regular-lat-lon_pressure-level_${date}_${czas}_${currentlevel}_HGT.grib2
        fi
    done
    cat ${dirOut}/${uc_pole}/*${uc_pole}.grib2 > ${dirOut}/${czas}_${pole}.grib2

    if [[ $pole == "fi" ]]; then
        cat ${dirOut}/${uc_pole}/*HGT.grib2 > ${dirOut}/${czas}_hgt.grib2
        rm -rf ${dirOut}/${czas}_fi.grib2
    fi 
    rm -rf ${dirOut}/${uc_pole}
done

#################################
# downloading 2D Fields
#################################
for pole in ${field_2d[@]}; do
    uc_pole=${pole^^}
    mkdir ${dirOut}/${uc_pole}
    url_dir="https://opendata.dwd.de/weather/nwp/icon-eu/grib/${date:8:2}/${pole}"
    file=icon-eu_europe_regular-lat-lon_single-level_${date}_${czas}_${uc_pole}.grib2.bz2
    wget -O ${dirOut}/${uc_pole}/${file} ${url_dir}/${file} || exit_upon_error "download failed"
    bunzip2 ${dirOut}/${uc_pole}/${file}
    cat ${dirOut}/${uc_pole}/*${uc_pole}.grib2 > ${dirOut}/${czas}_${pole}.grib2
    rm -rf ${dirOut}/${uc_pole}
done

#################################
# downloading 1D Fields
#################################
for pole in ${field_1d[@]} ; do
    uc_pole=${pole^^}
    url_dir="https://opendata.dwd.de/weather/nwp/icon-eu/grib/${date:8:2}/${pole}"
    file=icon-eu_europe_regular-lat-lon_time-invariant_${date}_${uc_pole}.grib2.bz2
    wget -O ${dirOut}/${file} ${url_dir}/${file} || exit_upon_error "download failed"
    bunzip2 ${dirOut}/${file}
    cat ${dirOut}/icon-eu_europe_regular-lat-lon_time-invariant_${date}_${uc_pole}.grib2 > ${dirOut}/${czas}_${pole}.grib2
    rm -f ${dirOut}/icon-eu_europe_regular-lat-lon_time-invariant_${date}_${uc_pole}.grib2
done

#################################
# downloading Soil Fields
#################################
for pole in ${field_soil[@]} ; do
    uc_pole=${pole^^}
    mkdir ${dirOut}/${uc_pole}
    in_file="${dirOut}/${uc_pole}/tmp_${date}_${czas}_${uc_pole}.grib2"
    out_file=${dirOut}/${uc_pole}/icon-eu_europe_regular-lat-lon_soil-level_${date}_${czas}_${uc_pole}.grib2
    url_dir="https://opendata.dwd.de/weather/nwp/icon-eu/grib/${date:8:2}/${pole}/"

    ## T_SO
    # temperature interpolation  to levels  0,0.06,0.54,2.43
    if [[ $uc_pole == "T_SO" ]]; then
        for tso in ${arry_tso[@]}; do
            file=icon-eu_europe_regular-lat-lon_soil-level_${date}_${czas}_${tso}_${uc_pole}.grib2.bz2
            wget -O ${dirOut}/${uc_pole}/${file} ${url_dir}/${file} || exit_upon_error "download failed"
            bunzip2 -f ${dirOut}/${uc_pole}/${file}
        done

        linia=""
        for tso in ${arry_tso[@]}; do
            linia="$linia ${dirOut}/${uc_pole}/*_${tso}_${uc_pole}.grib2 "
        done

        cdo merge ${linia} ${in_file}
        #rm -f ${dirOut}/${uc_pole}/icon-eu*.grib2 
        config=${dirOut}/${uc_pole}/t_so.dat
        setzaxis ${config}
        cdo setzaxis,${config} ${in_file} ${out_file} 
        #rm -f  ${config} ${in_file}
    fi

    ## W_SO
    # kg m-2 to fraction (m3 m-3)
    if [[ $uc_pole == "W_SO" ]]; then
        url_dir="https://opendata.dwd.de/weather/nwp/icon-eu/grib/${date:8:2}/${pole}/"
        for wso in ${arry_wso[@]}; do
            wget_file="${dirOut}/${uc_pole}/icon-eu_europe_regular-lat-lon_soil-level_${date}_${czas}_${wso}_${uc_pole}.grib2"
            file=icon-eu_europe_regular-lat-lon_soil-level_${date}_${czas}_${wso}_${uc_pole}.grib2.bz2
            wget -O ${dirOut}/${uc_pole}/${file} ${url_dir}/${file} || exit_upon_error "download failed"
            bunzip2 -f ${dirOut}/${uc_pole}/${file}
            tmp_file=${dirOut}/${uc_pole}/tmp_${date}_${czas}_${wso}_${uc_pole}.grib2

            case $wso in 
                "0") cdo -select,name=W_SO,level=0.005 -divc,10 ${wget_file} ${tmp_file} ;;
                "1") cdo -select,name=W_SO,level=0.02  -divc,20 ${wget_file} ${tmp_file} ;;
                "3") cdo -select,name=W_SO,level=0.06  -divc,60 ${wget_file} ${tmp_file} ;;
                "9") cdo -select,name=W_SO,level=0.18  -divc,180 ${wget_file} ${tmp_file} ;;
                "27") cdo -select,name=W_SO,level=0.54  -divc,540 ${wget_file} ${tmp_file} ;;
                "81") cdo -select,name=W_SO,level=1.62  -divc,1620 ${wget_file} ${tmp_file} ;;
                "243") cdo -select,name=W_SO,level=4.86  -divc,4860 ${wget_file} ${tmp_file} ;;
                *) echo "No level in list."; exit 1 ;;
            esac
            if [[ -s ${tmp_file} ]]; then rm  -f ${wget_file} ; fi
        done

        linia=""
        for wso in ${arry_wso[@]}; do
            linia="$linia ${dirOut}/${uc_pole}/*_${wso}_${uc_pole}.grib2 "
        done
        cdo merge ${linia} ${out_file}

    fi   # end for w_so

    cat ${dirOut}/${uc_pole}/icon-eu_europe_regular-lat-lon_soil-level_${date}_${czas}_*${uc_pole}.grib2 > ${dirOut}/${czas}_${pole}.grib2
done

cat ${dirOut}/*.grib2 > ${outfilegrib2}
rm -rf ${dirOut}
