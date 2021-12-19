****************************************
* Script to plot WRF output with GrADs *
****************************************
function visualizeWRF( args )

************** Load file ***************
file=subwrd(args,1)
type=subwrd(args,2)
t=subwrd(args,3)

'open 'file

'set display white'     
'set t 't               
'set map 1 1 3'        
'set mpdraw off'        
'set gxout shaded'         
'set clab on'           
'd tc'      
'set mpdset hires'          
'set mpdraw on'  
'draw map' 


lat.1 = 48.21
lon.1 = 16.36
name.1 = Vienna
lat.2 = 47.26
lon.2 = 11.40
name.2 = Innsbruck
lat.3 = 47.81
lon.3 = 13.03
name.3 = Salzburg
lat.4 = 47.07
lon.4 = 12.69
name.4 = Grossglockner
lat.5 = 47.73
lon.5 = 16.86
name.5 = Apetlon



count = 1
while (count <= 5)

    'q w2xy 'lon.count' 'lat.count
    xs = subwrd(result,3)
    ys = subwrd(result,6)
    'set line 1'
    "draw mark 3 "xs" "ys" 0.1"
    'set strsiz 0.10'
    'set string 1 bl 0'
    'draw string 'xs+0.1' 'ys+0.1' 'name.count    

    count = count + 1
endwhile

'cbar'                   
'q time'
fdate=subwrd(result,3)
'draw title 'type' Temperature for 'fdate
'set timelab off'
'set t 1'                  
'q time'
fdate=subwrd(result,3)
'printim  'type'_GrADs_'fdate'_'t'.png x1854 y2400'
'set timelab off'

'clear'

'close 1'
'set grads off'
