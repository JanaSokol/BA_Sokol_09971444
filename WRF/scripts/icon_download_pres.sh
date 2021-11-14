#!/bin/bash
export WKDIR=/mnt/d/wrf/DATA
export Tstad=$Tst
i=1
start_date=""$YYY1"-"$M1"-"$D1""
date=$(date +%Y-%m-%d -d "$start_date")

cd $WKDIR
cd icon
rm ICON_*
for time in {00..24..3}
do 
for levs in 1000 950 925 900 875 850 825 800 775 700 600 500 400 300 250 200 150 100 70 50
do
curl -X GET "https://opendata.dwd.de/weather/nwp/icon-eu/grib/"${Tst}"/t/icon-eu_europe_regular-lat-lon_pressure-level_"${YYY1}""${M1}""${D1}""${Tst}"_0"$time"_"$levs"_T.grib2.bz2" -o $WKDIR/icon/ICON_T_"$time"_"$levs".grib.bz2
bzip2 -d $WKDIR/icon/ICON_T_"$time"_"$levs".grib.bz2
curl -X GET "https://opendata.dwd.de/weather/nwp/icon-eu/grib/"${Tst}"/u/icon-eu_europe_regular-lat-lon_pressure-level_"${YYY1}""${M1}""${D1}""${Tst}"_0"$time"_"$levs"_U.grib2.bz2" -o $WKDIR/icon/ICON_U_"$time"_"$levs".grib.bz2
bzip2 -d $WKDIR/icon/ICON_U_"$time"_"$levs".grib.bz2
curl -X GET "https://opendata.dwd.de/weather/nwp/icon-eu/grib/"${Tst}"/v/icon-eu_europe_regular-lat-lon_pressure-level_"${YYY1}""${M1}""${D1}""${Tst}"_0"$time"_"$levs"_V.grib2.bz2" -o $WKDIR/icon/ICON_V_"$time"_"$levs".grib.bz2
bzip2 -d $WKDIR/icon/ICON_V_"$time"_"$levs".grib.bz2
curl -X GET "https://opendata.dwd.de/weather/nwp/icon-eu/grib/"${Tst}"/relhum/icon-eu_europe_regular-lat-lon_pressure-level_"${YYY1}""${M1}""${D1}""${Tst}"_0"$time"_"$levs"_RELHUM.grib2.bz2" -o $WKDIR/icon/ICON_RH_"$time"_"$levs".grib.bz2
bzip2 -d $WKDIR/icon/ICON_RH_"$time"_"$levs".grib.bz2
curl -X GET "https://opendata.dwd.de/weather/nwp/icon-eu/grib/"${Tst}"/fi/icon-eu_europe_regular-lat-lon_pressure-level_"${YYY1}""${M1}""${D1}""${Tst}"_0"$time"_"$levs"_FI.grib2.bz2" -o $WKDIR/icon/ICON_FI_"$time"_"$levs".grib.bz2
bzip2 -d $WKDIR/icon/ICON_FI_"$time"_"$levs".grib.bz2
cdo aexpr,"z=z/9.80665" ICON_FI_"$time"_"$levs".grib ICON_HGT_"$time"_"$levs".grib
rm ICON_FI_"$time"_"$levs".grib
done
cdo merge ICON_T_"$time"_* ICON_T_"$time".grib
rm ICON_T_"$time"_*
cdo merge ICON_U_"$time"_* ICON_U_"$time".grib
rm ICON_U_"$time"_*
cdo merge ICON_V_"$time"_* ICON_V_"$time".grib
rm ICON_V_"$time"_*
cdo merge ICON_RH_"$time"_* ICON_RH_"$time".grib
rm ICON_RH_"$time"_*
cdo merge ICON_HGT_"$time"_* ICON_HGT_"$time".grib
rm ICON_HGT_"$time"_*
#####################################################
curl -X GET "https://opendata.dwd.de/weather/nwp/icon-eu/grib/"${Tst}"/t_2m/icon-eu_europe_regular-lat-lon_single-level_"${YYY1}""${M1}""${D1}""${Tst}"_0"$time"_T_2M.grib2.bz2" -o $WKDIR/icon/ICON_T2M_"$time".grib.bz2
bzip2 -d $WKDIR/icon/ICON_T2M_"$time".grib.bz2
curl -X GET "https://opendata.dwd.de/weather/nwp/icon-eu/grib/"${Tst}"/u_10m/icon-eu_europe_regular-lat-lon_single-level_"${YYY1}""${M1}""${D1}""${Tst}"_0"$time"_U_10M.grib2.bz2" -o $WKDIR/icon/ICON_U10M_"$time".grib.bz2
bzip2 -d $WKDIR/icon/ICON_U10M_"$time".grib.bz2
curl -X GET "https://opendata.dwd.de/weather/nwp/icon-eu/grib/"${Tst}"/v_10m/icon-eu_europe_regular-lat-lon_single-level_"${YYY1}""${M1}""${D1}""${Tst}"_0"$time"_V_10M.grib2.bz2" -o $WKDIR/icon/ICON_V10M_"$time".grib.bz2
bzip2 -d $WKDIR/icon/ICON_V10M_"$time".grib.bz2
curl -X GET "https://opendata.dwd.de/weather/nwp/icon-eu/grib/"${Tst}"/relhum_2m/icon-eu_europe_regular-lat-lon_single-level_"${YYY1}""${M1}""${D1}""${Tst}"_0"$time"_RELHUM_2M.grib2.bz2" -o $WKDIR/icon/ICON_RH2M_"$time".grib.bz2
bzip2 -d $WKDIR/icon/ICON_RH2M_"$time".grib.bz2
curl -X GET "https://opendata.dwd.de/weather/nwp/icon-eu/grib/"${Tst}"/ps/icon-eu_europe_regular-lat-lon_single-level_"${YYY1}""${M1}""${D1}""${Tst}"_0"$time"_PS.grib2.bz2" -o $WKDIR/icon/ICON_PS_"$time".grib.bz2
bzip2 -d $WKDIR/icon/ICON_PS_"$time".grib.bz2
curl -X GET "https://opendata.dwd.de/weather/nwp/icon-eu/grib/"${Tst}"/pmsl/icon-eu_europe_regular-lat-lon_single-level_"${YYY1}""${M1}""${D1}""${Tst}"_0"$time"_PMSL.grib2.bz2" -o $WKDIR/icon/ICON_PMSL_"$time".grib.bz2
bzip2 -d $WKDIR/icon/ICON_PMSL_"$time".grib.bz2
curl -X GET "https://opendata.dwd.de/weather/nwp/icon-eu/grib/"${Tst}"/fr_land/icon-eu_europe_regular-lat-lon_time-invariant_"${YYY1}""${M1}""${D1}""${Tst}"_FR_LAND.grib2.bz2" -o $WKDIR/icon/ICON_LANDSEA_"$time".grib.bz2
bzip2 -d $WKDIR/icon/ICON_LANDSEA_"$time".grib.bz2
curl -X GET "https://opendata.dwd.de/weather/nwp/icon-eu/grib/"${Tst}"/hsurf/icon-eu_europe_regular-lat-lon_time-invariant_"${YYY1}""${M1}""${D1}""${Tst}"_HSURF.grib2.bz2" -o $WKDIR/icon/ICON_SOILHGT_"$time".grib.bz2
bzip2 -d $WKDIR/icon/ICON_SOILHGT_"$time".grib.bz2
curl -X GET "https://opendata.dwd.de/weather/nwp/icon-eu/grib/"${Tst}"/t_g/icon-eu_europe_regular-lat-lon_single-level_"${YYY1}""${M1}""${D1}""${Tst}"_0"$time"_T_G.grib2.bz2" -o $WKDIR/icon/ICON_TG_"$time".grib.bz2
bzip2 -d $WKDIR/icon/ICON_TG_"$time".grib.bz2
curl -X GET "https://opendata.dwd.de/weather/nwp/icon-eu/grib/"${Tst}"/w_snow/icon-eu_europe_regular-lat-lon_single-level_"${YYY1}""${M1}""${D1}""${Tst}"_0"$time"_W_SNOW.grib2.bz2" -o $WKDIR/icon/ICON_SNOW_"$time".grib.bz2
bzip2 -d $WKDIR/icon/ICON_SNOW_"$time".grib.bz2
curl -X GET "https://opendata.dwd.de/weather/nwp/icon-eu/grib/"${Tst}"/h_snow/icon-eu_europe_regular-lat-lon_single-level_"${YYY1}""${M1}""${D1}""${Tst}"_0"$time"_H_SNOW.grib2.bz2" -o $WKDIR/icon/ICON_SNOWH_"$time".grib.bz2
bzip2 -d $WKDIR/icon/ICON_SNOWH_"$time".grib.bz2
curl -X GET "https://opendata.dwd.de/weather/nwp/icon-eu/grib/"${Tst}"/qv_2m/icon-eu_europe_regular-lat-lon_single-level_"${YYY1}""${M1}""${D1}""${Tst}"_0"$time"_QV_2M.grib2.bz2" -o $WKDIR/icon/ICON_QV2M_"$time".grib.bz2
bzip2 -d $WKDIR/icon/ICON_QV2M_"$time".grib.bz2
###########################
for slevs in 0 2 6 18 54 162 486 1458
do
curl -X GET "https://opendata.dwd.de/weather/nwp/icon-eu/grib/"${Tst}"/t_so/icon-eu_europe_regular-lat-lon_soil-level_"${YYY1}""${M1}""${D1}""${Tst}"_0"$time"_"$slevs"_T_SO.grib2.bz2" -o $WKDIR/icon/ICON_SOILT_"$time"_"$slevs".grib.bz2
bzip2 -d $WKDIR/icon/ICON_SOILT_"$time"_"$slevs".grib.bz2
done
cdo merge ICON_SOILT_"$time"_* ICON_SOILT_"$time".grib
rm ICON_SOILT_"$time"_*
###############################
for slevs in 0 1 3 9 27 81 243 729 
do
curl -X GET "https://opendata.dwd.de/weather/nwp/icon-eu/grib/"${Tst}"/w_so/icon-eu_europe_regular-lat-lon_soil-level_"${YYY1}""${M1}""${D1}""${Tst}"_0"$time"_"$slevs"_W_SO.grib2.bz2" -o $WKDIR/icon/ICON_SMI_"$time"_"$slevs"_t.grib.bz2
bzip2 -d $WKDIR/icon/ICON_SMI_"$time"_"$slevs"_t.grib.bz2
if [ $slevs -eq 0 ] ;then
export multi=$((slevs+10))
else 
export multi=$(((slevs*2)*10))
fi
cdo aexpr,"W_SO=(W_SO/"${multi}")/0.5" ICON_SMI_"$time"_"$slevs"_t.grib ICON_SMI_"$time"_"$slevs".grib
rm ICON_SMI_"$time"_"$slevs"_t.grib
done
cdo merge ICON_SMI_"$time"_* ICON_SMI_"$time".grib
rm ICON_SMI_"$time"_*
################################
cdo merge ICON_*_"$time".grib ICON_"$time"ht
cdo -setdate,"$date" -settime,"$Tstad":00:00 ICON_"$time"ht ICON_"$time"h
rm ICON_"$time"ht
rm ICON_*_"$time".grib
###############################
Tstad=$((Tstad+03))
if [ $Tstad -gt 23 ];then
export Tstad=00
date=$(date +%Y-%m-%d -d "$start_date +$i days")
i=$((i+1))
fi
done

