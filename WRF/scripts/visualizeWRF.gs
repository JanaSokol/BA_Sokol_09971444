****************************************
* Script to plot WRF output with GrADs *
****************************************
function visualizeWRF( args )

************** Load file ***************
file=subwrd(args,1)
type=subwrd(args,2)

'open 'file

t=1
while (t<=AMOUNT_OF_FILES)

    'set display white'     
    'set t 't               
    'set map 1 1 3'        
    'set mpdraw off'        
    'set gxout shaded'         
    'set clab on'           
    'd tc'      
    'set mpdset hires'      
    'set ccolor 0'          
    'set cstyle 1'          
    'set cthick 5'          
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

    'printim  'type'_GrADs_'t'.png x1854 y2400'
    'clear'
    t=t+1
endwhile
'close 1'
'set grads off'
