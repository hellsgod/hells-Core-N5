#!/bin/bash

# Bash Color
green='\033[01;32m'
red='\033[01;31m'
blink_red='\033[05;31m'
restore='\033[0m'

clear

# Resources
THREAD="-j9"
KERNEL="zImage-dtb"
DEFCONFIG="hells_defconfig"

# Kernel Details
BASE_HC_VER="hC"
VER="-b23"
HC_VER="$BASE_HC_VER$VER"

# Vars
export LOCALVERSION=-`echo $HC_VER`
export ARCH=arm
export SUBARCH=arm

# Paths
KERNEL_DIR=`pwd`
REPACK_DIR="${HOME}/Android/Kernel/hC-N5-anykernel"
ZIP_MOVE="${HOME}/Android/Kernel/hC-releases/N5"
ZIMAGE_DIR="${HOME}/Android/Kernel/hells-Core-N5/arch/arm/boot"
DB_FOLDER="${HOME}/Dropbox/Kernel-Betas/N5"

# Functions
function clean_all {
		rm -rf $REPACK_DIR/kernel/zImage
		rm -rf $ZIMAGE_DIR/$KERNEL
		rm -rf $RAMFS.gz
		rm -rf $KERNEL_DIR/dt.img
		rm -rf $KERNEL_DIR/boot.img
		rm -rf $KERNEL_DIR/arch/arm/boot/ramdisk.gz
		make clean && make mrproper
}

function make_kernel {
		make $DEFCONFIG
		make $THREAD
		cp -vr $ZIMAGE_DIR/$KERNEL $REPACK_DIR/kernel
		mv ${HOME}/Android/Kernel/hC-N5-anykernel/kernel/zImage-dtb ${HOME}/Android/Kernel/hC-N5-anykernel/kernel/zImage
}

function make_zip {
		cd $REPACK_DIR
		zip -9 -r `echo $HC_VER`.zip .
		mv  `echo $HC_VER`.zip $ZIP_MOVE
		cd $KERNEL_DIR
}

function copy_dropbox {
		cd $ZIP_MOVE
		cp -vr  `echo $HC_VER`.zip $DB_FOLDER
		cd $KERNEL_DIR
}

DATE_START=$(date +"%s")

echo -e "${green}"
echo "hC Kernel Creation Script:"
echo

echo "---------------"
echo "Kernel Version:"
echo "---------------"

echo -e "${red}"; echo -e "${blink_red}"; echo "$HC_VER"; echo -e "${restore}";

echo -e "${green}"
echo "-----------------"
echo "Making hC Kernel:"
echo "-----------------"
echo -e "${restore}"

while read -p "Please choose your option: [1]clean-build / [2]dirty-build / [3]abort " cchoice
do
case "$cchoice" in
	1 )
		echo -e "${green}"
		echo
		echo "[..........Cleaning up..........]"
		echo
		echo -e "${restore}"
		clean_all
		echo -e "${green}"
		echo
		echo "[....Building `echo $HC_VER`....]"
		echo
		echo -e "${restore}"
		make_kernel
		echo -e "${green}"
		echo
		echo "[....Make `echo $HC_VER`.zip....]"
		echo
		echo -e "${restore}"
		make_zip
		echo -e "${green}"
		echo
		echo "[.....Moving `echo $HC_VER`.....]"
		echo
		echo -e "${restore}"
		copy_dropbox
		break
		;;
	2 )
		echo -e "${green}"
		echo
		echo "[....Building `echo $HC_VER`....]"
		echo
		echo -e "${restore}"
		make_kernel
		echo -e "${green}"
		echo
		echo "[....Make `echo $HC_VER`.zip....]"
		echo
		echo -e "${restore}"
		make_zip
		echo -e "${green}"
		echo
		echo "[.....Moving `echo $HC_VER`.....]"
		echo
		echo -e "${restore}"
		copy_dropbox
		break
		;;
	3 )
		break
		;;
	* )
		echo -e "${red}"
		echo
		echo "Invalid try again!"
		echo
		echo -e "${restore}"
		;;
esac
done

echo -e "${green}"
echo "-------------------"
echo "Build Completed in:"
echo "-------------------"
echo -e "${restore}"

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo

