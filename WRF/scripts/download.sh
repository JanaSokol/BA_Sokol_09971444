#!/bin/csh
#################################################################
# Csh Script to retrieve 90 online Data files of 'ds113.1',
# total 9.54G. This script uses 'wget' to download data.
#
# Highlight this script by Select All, Copy and Paste it into a file;
# make the file executable and run it on command line.
#
# You need pass in your password as a parameter to execute
# this script; or you can set an environment variable RDAPSWD
# if your Operating System supports it.
#
# Contact davestep@ucar.edu (Dave Stepaniak) for further assistance.
#################################################################


set pswd = $1
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
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_129_z.regn1280sc.20211109.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_034_sstk.regn1280sc.20211109.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_167_2t.regn1280sc.20211109.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_168_2d.regn1280sc.20211109.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_235_skt.regn1280sc.20211109.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_165_10u.regn1280sc.20211109.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_166_10v.regn1280sc.20211109.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.228_246_100u.regn1280sc.20211109.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.228_247_100v.regn1280sc.20211109.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_172_lsm.regn1280sc.20211109.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_134_sp.regn1280sc.20211109.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_151_msl.regn1280sc.20211109.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_031_ci.regn1280sc.20211109.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_033_rsn.regn1280sc.20211109.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_141_sd.regn1280sc.20211109.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_139_stl1.regn1280sc.20211109.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_170_stl2.regn1280sc.20211109.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_183_stl3.regn1280sc.20211109.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_236_stl4.regn1280sc.20211109.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_039_swvl1.regn1280sc.20211109.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_040_swvl2.regn1280sc.20211109.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_041_swvl3.regn1280sc.20211109.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_042_swvl4.regn1280sc.20211109.grb \
)
while($#filelist > 0)
 set syscmd = "$opt2$filelist[1]"
 echo "$syscmd ..."
 $syscmd
 shift filelist
end

