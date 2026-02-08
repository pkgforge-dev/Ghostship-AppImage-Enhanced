#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake         \
    fmt           \
    libzip        \
    ninja         \
    nlohmann-json \
    sdl2          \
    spdlog        \
    tinyxml2

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
make-aur-package zenity-rs-bin

# If the application needs to be manually built that has to be done down here
echo "Making stable build of Ghostship..."
echo "---------------------------------------------------------------"
REPO="https://github.com/HarbourMasters/Ghostship"
VERSION="$(git ls-remote --tags --sort="v:refname" "$REPO" | tail -n1 | sed 's/.*\///; s/\^{}//')"
git clone --branch "$VERSION" --single-branch --recursive --depth 1 "$REPO" ./Ghostship
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./Ghostship
patch -Np1 -i "../ghostship-fix-mtxf_copy-incorrect-values.patch"
cmake . \
    -Bbuild \
    -GNinja \
    -DNON_PORTABLE=On
cmake --build build --config Release
cmake --build build --config Release --target GeneratePortO2R

mv -v build/assets ../AppDir/bin
mv -v build/Ghostship ../AppDir/bin
mv -v build/config.yml ../AppDir/bin
mv -v build/ghostship.o2r ../AppDir/bin
wget -O ../AppDir/bin/gamecontrollerdb.txt https://raw.githubusercontent.com/mdqinc/SDL_GameControllerDB/master/gamecontrollerdb.txt
cp -rv logo.png /usr/share/pixmaps/ghostship.png
