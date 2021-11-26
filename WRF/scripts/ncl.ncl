;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Script to plot WRF output with NCL ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
begin

;;;;;;;;;;;;; Load file ;;;;;;;;;;;;;;
filename = "FILENAME"
a        = addfile(filename,"r")

;;;;;;;;;;; Set variables ;;;;;;;;;;;;
fileoutputname  = "FILEOUT"
wks             = gsn_open_wks("png",fileoutputname)

;;;;;;;;;;;;; Get values ;;;;;;;;;;;;;
times = wrf_user_getvar(a,"times",-1)
tc  = wrf_user_getvar(a,"tc",-1)
hgt = wrf_user_getvar(a,"HGT",0)

do timestep=0,120

;;;;;;;;;;;;; Temerature ;;;;;;;;;;;;;
opts            = True
opts@cnFillOn   = True
opts@InitTime   = False 
opts@Footer     = False
contour_t2      = wrf_contour(a,wks,tc(timestep,0,:,:),opts)
delete(opts)

;;;;;;;;;;;;;;; Height ;;;;;;;;;;;;;;;
opts                = True
opts@cnLineColor    = "White"
opts@InitTime       = False 
opts@Footer         = False
contour_hgt         = wrf_contour(a,wks,hgt,opts)
delete(opts)

;;;;;;;;;;;;;;;; Map ;;;;;;;;;;;;;;;;;
res                             = True
res@tiMainString                = "TITLE" + times(timestep)
res@mpFillOn                    = False        ; turn off gray fill
res@mpOutlineBoundarySets       = "National"   ; turn on country boundaries
res@mpNationalLineColor         = "Black"       ; color of cont. outlines
res@mpNationalLineThicknessF    = 3          ; thickness of outlines

pltres                          = True

plot                            = wrf_map_overlays(a,wks,(/contour_t2,contour_hgt/),pltres,res)

timestep=timestep+11
end do

end
