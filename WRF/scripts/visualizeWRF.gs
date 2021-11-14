function visualizeWRF(file)
'open 'file
*'query file'
'set mpdset hires'
'set gxout shaded'
*'set gxout contour'
'set clab on'
'set ccolor 1'
'd tc'
'cbar'
'draw title Temperature in Celsius'
'printim out.png'
'set grads off'
