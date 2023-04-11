#!/bin/bash

thisDir=$(pwd)
mainDir=$(realpath $thisDir/..)

pushd $mainDir
dwarfdump -l src/.libs/libwolfssl.so.35 >microwalk/libwolfssl.so.35.dwarf
popd

pushd $MAP_GENERATOR_PATH
dotnet MapFileGenerator.dll $mainDir/src/.libs/libwolfssl.so.35 $thisDir/libwolfssl.map
popd

find . -name "target-*.c" -print0 | while read -d $'\0' target
do
  targetName=${target%.*}
  
  gcc main.c $target -g -fno-inline -fno-split-stack -L "$mainDir/src/.libs" -lwolfssl -I "$mainDir" -o $targetName
  
  pushd $MAP_GENERATOR_PATH
  dotnet MapFileGenerator.dll $thisDir/$targetName $thisDir/$targetName.map
  popd
  
  dwarfdump -l $targetName >$targetName.dwarf
done
