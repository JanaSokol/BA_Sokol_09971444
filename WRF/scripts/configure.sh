#!/bin/bash


#################################
# directory paths
#################################
ROOTDIR=$(find $HOME -type d -name BA_Sokol_09971444)
WRFROOT=$ROOTDIR/WRF
DOWNLOADSDIR=$WRFROOT/downloads
LIBSDIR=$WRFROOT/libs
ARWDIR=$WRFROOT/WRF-ARW
POSTDIR=$WRFROOT/ARWpost
WPSDIR=$WRFROOT/WPS

#################################
# error handling
#################################

exit_upon_error(){
    echo "Error: $1"
    exit 1
}

#################################
# installing necessary packages 
#################################
echo "********** installing necessary packages **********"
installed() {
    return $(dpkg-query -W -f '${Status}\n' "${1}" 2>&1|awk '/ok installed/{print 1;exit}{print 0}')
}

#gfortran
if installed gfortran; then
    sudo apt install gfortran
else
    echo "gfortran is already installed."
fi

#g++
if installed g++; then
    sudo apt install g++
else
    echo "g++ is already installed."
fi

#htop
if installed htop; then
    sudo apt install htop
else
    echo "htop is already installed."
fi

#csh
if installed csh; then
    sudo apt install csh
else
    echo "csh is already installed."
fi

#mc
if installed mc; then
    sudo apt install mc
else
    echo "mc is already installed."
fi

#pv
if installed pv; then
    sudo apt install pv
else
    echo "pv is already installed."
fi

#grads
if installed grads; then
    sudo apt install grads
else
    echo "grads is already installed."
fi

#cdo
if installed cdo; then
    sudo apt install cdo
else
    echo "cdo is already installed."
fi

#################################
# unzip dependencies, WRF and WPS
#################################
cd $DOWNLOADSDIR
sudo wget https://github.com/wrf-model/WRF/archive/refs/tags/v4.3.tar.gz -O ${DOWNLOADSDIR}/WRF.tar.gz
sudo wget https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_high_res_mandatory.tar.gz -O ${DOWNLOADSDIR}/GEOG.tar.gz
echo "********** starting to unzip **********"
for i in *.gz ; do pv $i | tar xz ; done
mv -v WPS-4.3/ ../WPS
mv -v WRF-4.3/ ../WRF-ARW
mv -v ARWpost/ ../ARWpost
mv -v opengrads-2.2.1.oga.1/ ../GrADs
mv -v WPS_GEOG/ ../GEOG

#################################
# creating folder hierarchy
#################################
cd $WRFROOT
if [ ! -d "$WRFROOT/GFS" ]; then
    mkdir GFS
fi
if [ ! -d "$LIBSDIR" ]; then
    mkdir libs
    cd libs
    mkdir grib2 mpich netcdf
else
    cd $LIBSDIR
    if [ ! -d "$WRFROOT/libs/grib2" ]; then
        mkdir grib2
    fi

    if [ ! -d "$WRFROOT/libs/mpich" ]; then
        mkdir mpich
    fi

    if [ ! -d "$WRFROOT/libs/netcdf" ]; then
        mkdir netcdf
    fi
fi

export LIBDIR=$WRFROOT/libs

#################################
# zlib
#################################
cd $DOWNLOADSDIR/zlib-1.2.11
./configure --prefix=$LIBDIR/grib2 
make 
make install  || exit_upon_error "zlib compile failed"
cd ..
rm zlib-1.2.11
#################################
# libpng
#################################
cd $DOWNLOADSDIR/libpng-1.6.37
./configure --prefix=$LIBDIR/grib2 LDFLAGS="-L$LIBDIR/grib2/lib" CPPFLAGS="-I$LIBDIR/grib2/include"
make 
make install || exit_upon_error "libpng compile failed"
cd ..
rm libpng-1.6.37

#################################
# jasper
#################################
cd $DOWNLOADSDIR/jasper-1.900.1
./configure --prefix=$LIBDIR/grib2
make 
make install || exit_upon_error "jasper compile failed"
cd ..
rm jasper-1.900.1

#################################
# netcdf
#################################
cd $DOWNLOADSDIR/netcdf-4.1.2
./configure --prefix=$LIBDIR/netcdf --disable-dap --disable-netcdf-4
make 
make install || exit_upon_error "netcdf compile failed"
cd ..
rm netcdf-4.1.2

#################################
# mpich
#################################
cd $DOWNLOADSDIR/mpich-3.3.2
./configure --prefix=$LIBDIR/mpich
make 
make install || exit_upon_error "mpich compile failed"
cd ..
rm mpich-3.3.2

#################################
# WRF
#################################
export LIBDIR=$LIBDIR
export NETCDF=$LIBDIR/netcdf
export PATH=$LIBDIR/mpich/bin:$PATH
export JASPERLIB=$LIBDIR/grib2/lib
export JASPERINC=$LIBDIR/grib2/include
cd $ARWDIR
./configure 
cd ..
./compile em_real || exit_upon_error "wrf compile failed"
export LD_LIBRARY_PATH=$NETCDF/lib:$LD_LIBRARY_PATH

#################################
# WPS
#################################
cd $WPSDIR
export WRF_DIR=$WRFDIR
./configure
./compile || exit_upon_error "wps compile failed"

#################################
# ARWpost
#################################
cd $POSTDIR
./configure
# choose 3
search="-C -P -traditional"
replace="-P -traditional"
sed -i "s/$search/$replace/g" $POSTDIR/configure.arwp

search2="include  -lnetcdf"
replace2="include  -lnetcdff  -lnetcdf"
sed -i "s/$search2/$replace2/g" $POSTDIR/src/Makefile
./compile || exit_upon_error "arwpost compile failed"

#################################
# GRADS
#################################

export PATH=$WRFROOT/GrADs/Contents:$PATH
cp $WRFROOT/scripts/visualizeWRF.gs $WRFROOT/GrADs/Contents/Resources/Scripts/



