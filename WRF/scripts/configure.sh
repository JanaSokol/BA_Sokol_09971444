#!/bin/bash


#################################
# directory paths
#################################
cd ..
WRFROOT=`pwd`
DOWNLOADSDIR=$WRFROOT/downloads
LIBSDIR=$WRFROOT/libs
WRFDIR=$WRFROOT/WRF

#################################
# unzip dependencies, WRF and WPS
#################################
cd $DOWNLOADSDIR
sudo wget https://github.com/wrf-model/WRF/archive/refs/tags/v4.3.tar.gz -O ${DOWNLOADSDIR}/WRF.tar.gz
sudo wget https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_high_res_mandatory.tar.gz -O ${DOWNLOADSDIR}/GEOG.tar.gz
echo "********** starting to unzip **********"
for i in *.gz ; do tar xzf $i ; done
mv -v WPS-4.3/ ../WPS
mv -v WRF-4.3/ ../WRF
mv -v WPS_GEOG/ ../GEOG

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
make install

#################################
# libpng
#################################
cd $DOWNLOADSDIR/libpng-1.6.37
./configure --prefix=$LIBDIR/grib2 LDFLAGS="-L$LIBDIR/grib2/lib" CPPFLAGS="-I$LIBDIR/grib2/include"
make 
make install
cd ..
rm libpng-1.6.37

#################################
# jasper
#################################
cd $DOWNLOADSDIR/jasper-1.900.1
./configure --prefix=$LIBDIR/grib2
make 
make install
cd ..
rm jasper-1.900.1

#################################
# netcdf
#################################
cd $DOWNLOADSDIR/netcdf-4.1.2
./configure --prefix=$LIBDIR/netcdf --disable-dap --disable-netcdf-4
make 
make install
cd ..
rm netcdf-4.1.2

#################################
# mpich
#################################
cd $DOWNLOADSDIR/mpich-3.3.2
./configure --prefix=$LIBDIR/mpich
make 
make install
cd ..
rm mpich-3.3.2

#################################
# WRF
#################################
cd $WRFDIR
export LIBDIR=$LIBDIR
export NETCDF=$LIBDIR/netcdf
export PATH=$LIBDIR/mpich/bin:$PATH
export JASPERLIB=$LIBDIR/grib2/lib
export JASPERINC=$LIBDIR/grib2/include
./configure
./compile em_real
export LD_LIBRARY_PATH=$NETCDF/lib:$LD_LIBRARY_PATH

#################################
# WPS
#################################
cd $WRFROOT/WPS
export WRF_DIR=$WRFDIR
./configure
./compile














