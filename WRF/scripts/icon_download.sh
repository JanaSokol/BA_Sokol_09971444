#!/bin/bash

# ========================================================================================= #
# This code is inspired by:                                                                 #
# prof. Mariusz Figurski - Gdansk University of Technology METEOPG  meteopg.pl              #
# 2019-05-04                                                                                #
# https://forum.mmm.ucar.edu/phpBB3/viewtopic.php?f=32&t=9391&p=23645#p23645 (16.11.2021)   #
# ========================================================================================= #  
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
day=`printf "%02d\n" "${1}"`
month=`printf "%02d\n" "${2}"`
year=$3
time_step_start=0
time_step_end=120   # max 120, default 120
time_step=12        # must be a multiple of 3
cycle=00

START_DATE=$year$month$day$cycle
ROOTDIR=$(find $HOME -type d -name BA_Sokol_09971444)
dirOutg=$ROOTDIR/WRF/DATA/ICON/
rm -rf $dirOutg
mkdir $dirOutg

#################################
# error handling
#################################

exit_upon_error(){
    echo "Error: $1"
    exit 1
}

for ((i=$time_step_start; i<=$time_step_end; i+=$time_step))
do
    czas=`printf "%03d\n" "${i}"`
    outfilegrib2=${dirOutg}/ICON-EU_${START_DATE}_${czas}.grib
    date=${START_DATE:0:10}
    dirOut="$dirOutg${czas}_tmp"
    
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


   

    #Calculate correct date and time
    TEMPENDHOUR=$(($i % 24))
    TEMP=$(($i/24))
    ENDDAY=$(($TEMP+day))
    ENDMONTH=$month
    ENDYEAR=$year

    case $month  in
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
                ENDYEAR=$(($year+1))
             fi;;
        *) echo "Wrong Month"; exit 1 ;;
    esac    

    ENDHOUR=`printf "%02d\n" "${TEMPENDHOUR}"`
    ENDDAY=`printf "%02d\n" "${ENDDAY}"`
    ENDMONTH=`printf "%02d\n" "${ENDMONTH}"`
    ENDYEAR=`printf "%04d\n" "${ENDYEAR}"`

    start_date=""$ENDYEAR"-"$ENDMONTH"-"$ENDDAY""
    date=$(date +%Y-%m-%d -d "$start_date")

    cat ${dirOut}/*.grib2 > ${dirOut}/ICON-EU_${START_DATE}_${czas}t.grib
    cdo -setdate,"$date" -settime,"$ENDHOUR":00:00 ${dirOut}/ICON-EU_${START_DATE}_${czas}t.grib ${outfilegrib2}
    rm -rf ${dirOut}
done
exit 0
