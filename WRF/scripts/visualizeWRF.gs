function visualizeWRF( args )
file=subwrd(args,1)
type=subwrd(args,2)
'open 'file
t=1
while (t<=AMOUNT_OF_FILES)
  'set t 't
    'set map 0 1 10'
    'set mpdraw off'
    'set gxout shaded'
    'set csmooth on'
    'set clab on'
    'd tc'
    'set mpdset hires'
    'set ccolor 1'
    'set cstyle 3'
    'set cthick 8'
    'set gxout contour'
    'set clab masked'
    'd hgt'
    'set mpdraw on'
    'draw map'
    'cbar'
    'q time'
    fdate=subwrd(result,3)
    'draw title 'type' Temperature for 'fdate
    'set timelab off'

    'printim 'type'_'t'.png x1854 y2400'
    'clear'
    t=t+1
endwhile
'close 1'
'set grads off'
