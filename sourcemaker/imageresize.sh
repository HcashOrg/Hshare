#!/bin/bash

i=0

sizes=(512 256 128 96 80 64 48 32 16)

iconset=source.iconset

mkdir -p $iconset

cp source.png $iconset/icon_${sizes[$i]}x${sizes[$i]}@2x.png

while [ $i -lt ${#sizes[@]} ]; do

base=icon_${sizes[$i]}x${sizes[$i]}

cp $iconset/$base@2x.png $iconset/$base.png

sips —resampleHeightWidth ${sizes[$i]} ${sizes[$i]} $iconset/$base.png &>/dev/null

cp $iconset/$base.png $iconset/icon_${sizes[$i+1]}x${sizes[$i+1]}@2x.png

: $[ i++ ]

done

rm $iconset/icon_{x,6}*

target=../src/qt/res
tcoin=$target/icons

cp $iconset/icon_512x512.png $tcoin/coin_testnet.png
cp $iconset/icon_16x16.png $tcoin/coin_testnet_toolbar.png

cp $iconset/icon_512x512.png $tcoin/coin.png
cp $iconset/icon_16x16.png $tcoin/coin16.png
cp $iconset/icon_32x32.png $tcoin/coin32.png
cp $iconset/icon_48x48.png $tcoin/coin48.png
cp $iconset/icon_80x80.png $tcoin/coin80.png
cp $iconset/icon_128x128.png $tcoin/coin128.png
rm -f $tcoin/coin.ico
convert source.png -define icon:auto-resize=256,128,64,32,16 $tcoin/coin.ico
iconutil -c icns $iconset
cp $iconset/icon_96x96.png $target/images/header.png
cp splash.png $target/images/splash3.png
rm -rf $iconset
rm -rf source.icns
