#!/bin/bash

DIR=/home/jana/Documents/GitHub/BA_Sokol_09971444/backend/src/main/resources/TestData/ICON_IMAGES/9_12_2021_GRADS/

cd $DIR

for i in *.png ; do convert $i -crop 1854x2300+0+0 $i ; done

for i in *.png ; do convert -trim $i $i ; done


