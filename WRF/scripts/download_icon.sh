#!/bin/bash
#
# Downloading ICON-EU grib2 files
# ==============================================================================
# author: prof. Mariusz Figurski - Gdansk University of Technology METEOPG  meteopg.pl
#         2019-05-04
#
# WRF model reads soil temperature up to 10m, levels 0 and 1458 must be removed 
# WRF model reads soil moisture up to 10m, ie the 729 level must be removed.
export arry_wso=(0 1 3 9 27 81 243)
export arry_tso=(2 5 6 18 54 162 486)

export field_3d=(relhum u v t fi)
export field_2d=(td_2m t_2m relhum_2m u_10m v_10m ps pmsl h_snow w_snow t_g)
export field_1d=(hsurf fr_land)
export field_soil=(t_so w_so)

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

# ================================ main part =========================================================
#
# Input parameters. 
# -----------------
  dirOutg=/home/jana/Documents/GitHub/BA_Sokol_09971444/WRF/ICON   # you must change
  START_DATE=2021103100				# you must change
  czas=003					# you must change

  outfilegrib2=${dirOutg}/ICON-EU_${START_DATE}_${czas}.grib

 date=${START_DATE:0:10}
 dirOut="$dirOutg/${czas}_tmp"
if [ ! -d ${dirOut} ]; then mkdir ${dirOut}; fi


for pole in ${field_3d[@]} ; do
 uc_pole=${pole^^}
 url_dir="https://opendata.dwd.de/weather/nwp/icon-eu/grib/${date:8:2}/${pole}/"
 wget ${wget_opt} --accept=icon-eu_europe_regular-lat-lon_pressure-level_${date}_${czas}_*${uc_pole}.grib2.bz2 -P ${dirOut}  ${url_dir}  
 bunzip2 ${dirOut}/icon-eu_europe_regular-lat-lon_pressure-level_${date}_${czas}_*${uc_pole}.grib2.bz2
 rm -f ${dirOut}/${czas}_${pole}.grib2
 cat ${dirOut}/icon-eu_europe_regular-lat-lon_pressure-level_${date}_${czas}_*${uc_pole}.grib2 > ${dirOut}/${czas}_${pole}.grib2
 rm -f ${dirOut}/icon-eu_europe_regular-lat-lon_pressure-level_${date}_${czas}_*${uc_pole}.grib2
done
#
for pole in ${field_2d[@]} ; do
 uc_pole=${pole^^}
 url_dir="https://opendata.dwd.de/weather/nwp/icon-eu/grib/${date:8:2}/${pole}/"
 wget ${wget_opt} --accept=icon-eu_europe_regular-lat-lon_single-level_${date}_${czas}_*${uc_pole}.grib2.bz2 -P ${dirOut}  ${url_dir}  
 bunzip2 ${dirOut}/icon-eu_europe_regular-lat-lon_single-level_${date}_${czas}_*${uc_pole}.grib2.bz2
 rm -f ${dirOut}/${czas}_${pole}.grib2
 cat ${dirOut}/icon-eu_europe_regular-lat-lon_single-level_${date}_${czas}_*${uc_pole}.grib2 > ${dirOut}/${czas}_${pole}.grib2
 rm -f ${dirOut}/icon-eu_europe_regular-lat-lon_single-level_${date}_${czas}_*${uc_pole}.grib2
done

for pole in ${field_1d[@]} ; do
 uc_pole=${pole^^}
 url_dir="https://opendata.dwd.de/weather/nwp/icon-eu/grib/${date:8:2}/${pole}/"
 wget ${wget_opt} --accept=icon-eu_europe_regular-lat-lon_time-invariant_${date}_${uc_pole}.grib2.bz2 -P ${dirOut}  ${url_dir}  
 bunzip2 ${dirOut}/icon-eu_europe_regular-lat-lon_time-invariant_${date}_${uc_pole}.grib2.bz2
 rm -f ${dirOut}/${czas}_${pole}.grib2
 cat ${dirOut}/icon-eu_europe_regular-lat-lon_time-invariant_${date}_${uc_pole}.grib2 > ${dirOut}/${czas}_${pole}.grib2
 rm -f ${dirOut}/icon-eu_europe_regular-lat-lon_time-invariant_${date}_${uc_pole}.grib2

done
#
for pole in ${field_soil[@]} ; do
 uc_pole=${pole^^}
 in_file="${dirOut}/tmp_${date}_${czas}_${uc_pole}.grib2"
 out_file=${dirOut}/icon-eu_europe_regular-lat-lon_soil-level_${date}_${czas}_${uc_pole}.grib2
 url_dir="https://opendata.dwd.de/weather/nwp/icon-eu/grib/${date:8:2}/${pole}/"

# temperature interpolation  to levels  0,0.06,0.54,2.43
 if [[ $uc_pole == "T_SO" ]]; then
#
   for tso in ${arry_tso[@]}; do
    wget ${wget_opt} --accept=icon-eu_europe_regular-lat-lon_soil-level_${date}_${czas}_${tso}_${uc_pole}.grib2.bz2 -P ${dirOut}  ${url_dir}  
    bunzip2 -f ${dirOut}/icon-eu_europe_regular-lat-lon_soil-level_${date}_${czas}_${tso}_${uc_pole}.grib2.bz2
  done
#
    linia=""
    for tso in ${arry_tso[@]}; do
     linia="$linia ${dirOut}/*_${tso}_${uc_pole}.grib2 "
    done
#
    cdo merge ${linia} ${in_file}
    rm -f ${dirOut}/icon-eu*.grib2 
    config=${dirOut}/t_so.dat
    setzaxis ${config}
    cdo setzaxis,${config} ${in_file} ${out_file} 
    rm -f  ${config} ${in_file}
 fi

# kg m-2 to fraction (m3 m-3)
#
 if [[ $uc_pole == "W_SO" ]]; then
   url_dir="https://opendata.dwd.de/weather/nwp/icon-eu/grib/${date:8:2}/${pole}/"
   for wso in ${arry_wso[@]}; do
    wget_file="${dirOut}/icon-eu_europe_regular-lat-lon_soil-level_${date}_${czas}_${wso}_${uc_pole}.grib2"
    wget ${wget_opt} --accept=icon-eu_europe_regular-lat-lon_soil-level_${date}_${czas}_${wso}_${uc_pole}.grib2.bz2 -P ${dirOut}  ${url_dir}  
    bunzip2 -f ${dirOut}/icon-eu_europe_regular-lat-lon_soil-level_${date}_${czas}_${wso}_${uc_pole}.grib2.bz2
    tmp_file=${dirOut}/tmp_${date}_${czas}_${wso}_${uc_pole}.grib2

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
#
    linia=""
    for wso in ${arry_wso[@]}; do
     linia="$linia ${dirOut}/*_${wso}_${uc_pole}.grib2 "
    done
#
    cdo merge ${linia} ${out_file}
    rm -f ${dirOut}/tmp*_${uc_pole}.grib2

 fi   # end for w_so

 cat ${dirOut}/icon-eu_europe_regular-lat-lon_soil-level_${date}_${czas}_*${uc_pole}.grib2 > ${dirOut}/${czas}_${pole}.grib2
 rm -f ${dirOut}/icon-eu_europe_regular-lat-lon_soil-level_${date}_${czas}_*${uc_pole}.grib2
done #  field_soil

#
 cat ${dirOut}/${czas}*.grib2 > ${outfilegrib2}
 rm -rf ${dirOut}

 echo "End process $date $czas"

exit 0
