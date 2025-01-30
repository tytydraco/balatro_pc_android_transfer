#!/usr/bin/env bash

PC_DIR="/home/tytydraco/.local/share/Steam/steamapps/compatdata/2379780/pfx/drive_c/users/steamuser/AppData/Roaming/Balatro/"

pc_to_android() {
    adb push "$PC_DIR" "/data/local/tmp"
    adb shell run-as com.unofficial.balatro rm -rf "files/save/game/"
    adb shell run-as com.unofficial.balatro mkdir "files/save/game/"
    adb shell run-as com.unofficial.balatro cp -r "/data/local/tmp/Balatro/*" "files/save/game/"
    adb shell "rm -rf /data/local/tmp/Balatro"
}

android_to_pc() {
    adb shell "mkdir /sdcard/Download/Balatro_tmp"
    adb shell run-as com.unofficial.balatro cp -r "files/save/game/" "/sdcard/Download/Balatro_tmp/"

    adb pull "/sdcard/Download/Balatro_tmp/game" .
    adb shell "rm -rf /sdcard/Download/Balatro_tmp"

    rm -rf "${PC_DIR:?}/*"
    cp -r game/* "$PC_DIR"

    rm -rf "game"
}

usage() {
	echo -n "Usage: $(basename "$0") [OPTIONS] [COMMAND]

Options:
  -p			Transfer from Android to PC
  -a			Transfer from PC to Android
  -h			Show usage
"
}

while getopts "pah" opt; do
	case $opt in
		p)
			android_to_pc
            exit 0
			;;
        a)
			pc_to_android
            exit 0
			;;
		h)
			usage
			exit 0
			;;
		*)
			usage
			exit 1
			;;
	esac
done
shift $((OPTIND - 1))

usage
exit 1
