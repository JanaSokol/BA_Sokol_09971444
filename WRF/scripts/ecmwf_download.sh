#!/bin/csh

set inputdir=/home/jana/Documents/GitHub/BA_Sokol_09971444/WRF/DATA/ECMWF/
rm -rf $inputdir
mkdir $inputdir


set year=2021
set month=11
set day=11

set pswd = BA_09971444
if(x$pswd == x && `env | grep RDAPSWD` != '') then
 set pswd = $RDAPSWD
endif
if(x$pswd == x) then
 echo
 echo Usage: $0 YourPassword
 echo
 exit 1
endif
set v = `wget -V |grep 'GNU Wget ' | cut -d ' ' -f 3`
set a = `echo $v | cut -d '.' -f 1`
set b = `echo $v | cut -d '.' -f 2`
if(100 * $a + $b > 109) then
 set opt = 'wget --no-check-certificate'
else
 set opt = 'wget'
endif
set opt1 = '-O Authentication.log --save-cookies auth.rda_ucar_edu --post-data'
set opt2 = "email=e09971444@student.tuwien.ac.at&passwd=$pswd&action=login"
$opt $opt1="$opt2" https://rda.ucar.edu/cgi-bin/login
if ( $status == 6 ) then
 echo 'Please check that your password is correct.'
 echo "Usage: $0 YourPassword"
 exit 1
endif
set opt1 = "-N --load-cookies auth.rda_ucar_edu"
set opt2 = "$opt $opt1 https://rda.ucar.edu/data/ds113.1/"

set filelist = ( \
#   Geopotential (m2 s-2)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_129_z.regn1280sc.$year$month$day.grb \
#   Surface pressure (Pa)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_134_sp.regn1280sc.$year$month$day.grb \
#   Soil temperature level 1 (K)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_139_stl1.regn1280sc.$year$month$day.grb \
#   Soil temperature level 2 (K)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_170_stl2.regn1280sc.$year$month$day.grb \
#   Soil temperature level 3 (K)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_183_stl3.regn1280sc.$year$month$day.grb \
#   Soil temperature level 4 (K)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_236_stl4.regn1280sc.$year$month$day.grb \
#   Mean sea-level pressure (Pa)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_151_msl.regn1280sc.$year$month$day.grb \
#   10 metre U wind component (m s-1)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_165_10u.regn1280sc.$year$month$day.grb \
#   10 metre V wind component (m s-1)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_166_10v.regn1280sc.$year$month$day.grb \
#   2 metre temperature (K)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_167_2t.regn1280sc.$year$month$day.grb \
#   Skin temperature (K)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_235_skt.regn1280sc.$year$month$day.grb \
#   Volumetric soil water layer 1
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_039_swvl1.regn1280sc.$year$month$day.grb \
#   Volumetric soil water layer 2
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_040_swvl2.regn1280sc.$year$month$day.grb \
#   Volumetric soil water layer 3
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_041_swvl3.regn1280sc.$year$month$day.grb \
#   Volumetric soil water layer 4
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_042_swvl4.regn1280sc.$year$month$day.grb \
#   2 metre dewpoint temperature (K)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_168_2d.regn1280sc.$year$month$day.grb \
#   Ice surface temperature layer 1
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_035_istl1.regn1280sc.$year$month$day.grb \
#   Ice surface temperature layer 2
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_036_istl2.regn1280sc.$year$month$day.grb \
#   Ice surface temperature layer 3
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_037_istl3.regn1280sc.$year$month$day.grb \
#   Ice surface temperature layer 4
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_038_istl4.regn1280sc.$year$month$day.grb \
#   Temperature of snow layer (K)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_238_tsn.regn1280sc.$year$month$day.grb \
#   Maximum 2 metre temperature since previous post-processing (K)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_201_mx2t.regn1280sc.$year$month$day.grb \
#   Minimum 2 metre temperature since previous post-processing (K)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_202_mn2t.regn1280sc.$year$month$day.grb \
#   Maximum temperature at 2 metres since last 6 hours (K)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_121_mx2t6.regn1280sc.$year$month$day.grb \
#   Minimum temperature at 2 metres since last 6 hours (K)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_122_mn2t6.regn1280sc.$year$month$day.grb \
#   Sea-ice cover
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_031_ci.regn1280sc.$year$month$day.grb \
#   Sea surface temperature (K)
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_034_sstk.regn1280sc.$year$month$day.grb \
#   Snow depth (m of water equivalent)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_141_sd.regn1280sc.$year$month$day.grb \
: '
#   Snow albedo	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_032_asn.regn1280sc.$year$month$day.grb \
#   Snow density
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_033_rsn.regn1280sc.$year$month$day.grb \
#   Snow evaporation (m)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_044_es.regn1280sc.$year$month$day.grb \
#   Snowmelt (m)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_045_smlt.regn1280sc.$year$month$day.grb \
#   Large-scale precipitation fraction (s)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_050_lspf.regn1280sc.$year$month$day.grb \
#   Downward uv radiation at the surface (W m-2)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_057_uvb.regn1280sc.$year$month$day.grb \
#   Photosynthetically active radiation at the surface (W m-2)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_058_par.regn1280sc.$year$month$day.grb \
#   Convective available potential energy (J kg-1)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_059_cape.regn1280sc.$year$month$day.grb \
#   Total column liquid water (kg m-2)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_078_tclw.regn1280sc.$year$month$day.grb \
#   Total column ice water (kg m-2)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_079_tciw.regn1280sc.$year$month$day.grb \
#   Total column water (kg m-2)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_136_tcw.regn1280sc.$year$month$day.grb \
#   Total column water vapour (kg m-2)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_137_tcwv.regn1280sc.$year$month$day.grb \
#   Stratiform precipitation (m)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_142_lsp.regn1280sc.$year$month$day.grb \
#   Convective precipitation (m)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_143_cp.regn1280sc.$year$month$day.grb \
#   Snowfall (convective + stratiform) (m of water equivalent)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_144_sf.regn1280sc.$year$month$day.grb \
#   Boundary layer dissipation (W m-2 s)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_145_bld.regn1280sc.$year$month$day.grb \
#   Surface sensible heat flux (W m-2 s)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_146_sshf.regn1280sc.$year$month$day.grb \
#   Surface latent heat flux (W m-2 s)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_147_slhf.regn1280sc.$year$month$day.grb \
#   Charnock	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_148_chnk.regn1280sc.$year$month$day.grb \
#   Boundary layer height (m)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_159_blh.regn1280sc.$year$month$day.grb \
#   Total cloud cover	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_164_tcc.regn1280sc.$year$month$day.grb \
#   Surface solar radiation downwards (W m-2 s)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_169_ssrd.regn1280sc.$year$month$day.grb \
#   Land/sea mask	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_172_lsm.regn1280sc.$year$month$day.grb \
#   Surface thermal radiation downwards (W m-2 s)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_175_strd.regn1280sc.$year$month$day.grb \
#   Surface solar radiation (W m-2 s)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_176_ssr.regn1280sc.$year$month$day.grb \
#   Surface thermal radiation (W m-2 s)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_177_str.regn1280sc.$year$month$day.grb \
#   Top solar radiation (W m-2 s)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_178_tsr.regn1280sc.$year$month$day.grb \
#   Top thermal radiation (W m-2 s)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_179_ttr.regn1280sc.$year$month$day.grb \
#   East/West surface stress (N m-2 s)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_180_ewss.regn1280sc.$year$month$day.grb \
#   North/South surface stress (N m-2 s)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_181_nsss.regn1280sc.$year$month$day.grb \
#   Evaporation (m of water)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_182_e.regn1280sc.$year$month$day.grb \
#   Low cloud cover	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_186_lcc.regn1280sc.$year$month$day.grb \
#   Medium cloud cover	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_187_mcc.regn1280sc.$year$month$day.grb \
#   High cloud cover	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_188_hcc.regn1280sc.$year$month$day.grb \
#   Sunshine duration (s)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_189_sund.regn1280sc.$year$month$day.grb \
#   Latitudinal component of gravity wave stress (N m-2 s)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_195_lgws.regn1280sc.$year$month$day.grb \
#   Meridional component of gravity wave stress (N m-2 s)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_196_mgws.regn1280sc.$year$month$day.grb \
#   Gravity wave dissipation (W m-2 s)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_197_gwd.regn1280sc.$year$month$day.grb \
#   Skin reservoir content (m of water)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_198_src.regn1280sc.$year$month$day.grb \
#   Runoff (m)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_205_ro.regn1280sc.$year$month$day.grb \
#   Total column ozone (kg m-2)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_206_tco3.regn1280sc.$year$month$day.grb \
#   Top net solar radiation, clear sky (W m-2 s)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_208_tsrc.regn1280sc.$year$month$day.grb \
#   Top net thermal radiation, clear sky (W m-2 s)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_209_ttrc.regn1280sc.$year$month$day.grb \
#   Surface net solar radiation, clear sky (W m-2 s)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_210_ssrc.regn1280sc.$year$month$day.grb \
#   Surface net thermal radiation, clear sky (W m-2 s)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_211_strc.regn1280sc.$year$month$day.grb \
#   Solar insolation (W m-2 s)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_212_si.regn1280sc.$year$month$day.grb \
#   Vertically integrated moisture divergence (kg m-2)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_213_vimd.regn1280sc.$year$month$day.grb \
#   Total precipitation (m)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_228_tp.regn1280sc.$year$month$day.grb \
#   Instantaneous X surface stress (N m-2)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_229_iews.regn1280sc.$year$month$day.grb \
#   Instantaneous Y surface stress (N m-2)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_230_inss.regn1280sc.$year$month$day.grb \
#   Instantaneous surface heat flux (W m-2)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_231_ishf.regn1280sc.$year$month$day.grb \
#   Instantaneous moisture flux (kg m-2 s)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_232_ie.regn1280sc.$year$month$day.grb \
#   Forecast albedo	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_243_fal.regn1280sc.$year$month$day.grb \
#   Forecast surface roughness (m)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_244_fsr.regn1280sc.$year$month$day.grb \
#   Forecast log of surface roughness for heat	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_245_flsr.regn1280sc.$year$month$day.grb \
#   Friction velocity (m s-1)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.228_003_zust.regn1280sc.$year$month$day.grb \
#   Neutral wind at 10 m u-component (m s-1)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.228_131_u10n.regn1280sc.$year$month$day.grb \
#   Neutral wind at 10 m v-component (m s-1)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.228_132_v10n.regn1280sc.$year$month$day.grb \
#   100 metre U wind component (m s-1)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.228_246_100u.regn1280sc.$year$month$day.grb \
#   100 metre V wind component (m s-1)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.228_247_100v.regn1280sc.$year$month$day.grb \
#   Wind gust at 10 metres (m s-1)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_049_10fg.regn1280sc.$year$month$day.grb \
#   10 metre wind gust in the past 6 hours (m s-1)	
    ec.oper.fc.sfc/$year$month/ec.oper.fc.sfc.128_123_10fg6.regn1280sc.$year$month$day.grb \ '
)
while($#filelist > 0)
 set syscmd = "$opt2$filelist[1]"
 echo "$syscmd ..."
 $syscmd
 shift filelist
end

cat *.grb > ecmwf_$day$month$year.grb
rm -f auth.rda_ucar_edu
rm -f Authentication.log
mv -v ecmwf_$day$month$year.grb ../ECMWF
#foreach i (*.grb)
#    rm -f $i
#end

