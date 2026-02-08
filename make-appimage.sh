#!/bin/sh

set -eu

ARCH=$(uname -m)
#VERSION=$(pacman -Q ghostship | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/pixmaps/ghostship.png
#export DESKTOP=/usr/share/applications/ghostship.desktop
export DEPLOY_OPENGL=1

# Deploy dependencies
#mkdir -p ./AppDir/bin
#mv /opt/ghostship/* ./AppDir/bin
#mv /opt/ghostship/ghostship.o2r ./AppDir/bin
#mv /opt/ghostship/config.yml ./AppDir/bin
#mv /opt/ghostship/gamecontrollerdb.txt ./AppDir/bin
#quick-sharun /usr/bin/Ghostship /usr/bin/zenity
quick-sharun ./AppDir/bin/*

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage
