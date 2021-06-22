#!/bin/bash

set -e

cd ..

make clean

if [ "$1" == "fetch" ]; then
	./fetchDependencies --macos --ios --iossim --tvos --tvossim
else
	echo "To fetch dependencies, run ./build_dynamic_xcframework.sh fetch"
fi

make macos
make ios
make iossim
make tvos
make tvossim

cd Package/Release/MoltenVK/dylib

rm -rf MoltenVK.xcframework || true

xcodebuild -create-xcframework -library iOS/libMoltenVK.dylib -library iOS-simulator/libMoltenVK.dylib -library tvOS/libMoltenVK.dylib -library tvOS-simulator/libMoltenVK.dylib -output MoltenVK.xcframework
