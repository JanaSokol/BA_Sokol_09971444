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
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_031_ci.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_032_asn.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_033_rsn.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_034_sstk.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_035_istl1.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_036_istl2.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_037_istl3.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_038_istl4.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_039_swvl1.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_040_swvl2.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_041_swvl3.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_042_swvl4.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_044_es.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_045_smlt.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_049_10fg.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_050_lspf.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_057_uvb.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_058_par.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_059_cape.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_078_tclw.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_079_tciw.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_121_mx2t6.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_122_mn2t6.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_123_10fg6.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_129_z.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_134_sp.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_136_tcw.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_137_tcwv.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_139_stl1.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_141_sd.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_142_lsp.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_143_cp.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_144_sf.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_145_bld.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_146_sshf.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_147_slhf.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_148_chnk.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_151_msl.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_159_blh.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_164_tcc.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_165_10u.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_166_10v.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_167_2t.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_168_2d.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_169_ssrd.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_170_stl2.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_172_lsm.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_175_strd.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_176_ssr.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_177_str.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_178_tsr.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_179_ttr.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_180_ewss.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_181_nsss.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_182_e.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_183_stl3.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_186_lcc.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_187_mcc.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_188_hcc.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_189_sund.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_195_lgws.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_196_mgws.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_197_gwd.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_198_src.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_201_mx2t.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_202_mn2t.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_205_ro.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_206_tco3.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_208_tsrc.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_209_ttrc.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_210_ssrc.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_211_strc.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_212_si.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_213_vimd.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_228_tp.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_229_iews.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_230_inss.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_231_ishf.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_232_ie.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_235_skt.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_236_stl4.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_238_tsn.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_243_fal.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_244_fsr.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.128_245_flsr.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.228_003_zust.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.228_131_u10n.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.228_132_v10n.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.228_246_100u.regn1280sc.20211115.grb \
  ec.oper.fc.sfc/202111/ec.oper.fc.sfc.228_247_100v.regn1280sc.20211115.grb \
)
while($#filelist > 0)
 set syscmd = "$opt2$filelist[1]"
 echo "$syscmd ..."
 $syscmd
 shift filelist
end

