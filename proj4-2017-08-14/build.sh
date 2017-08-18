#!/bin/bash
# Copyright 2017 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
. $(dirname $0)/../common.sh

build_lib() {
  rm -rf BUILD
  cp -rf SRC BUILD
  (cd BUILD && ./autogen.sh &&  ./configure  &&  make clean  && make -j $JOBS )
}

get_git_revision https://github.com/OSGeo/proj.4.git d00501750b210a73f9fb107ac97a683d4e3d8e7a SRC
build_lib
build_fuzzer

mkdir seeds
cp -r BUILD/nad/* seeds

$CXX $CXXFLAGS -std=c++11 -I BUILD/src  BUILD/test/fuzzers/standard_fuzzer.cpp  BUILD/src/.libs/libproj.a $LIB_FUZZING_ENGINE -o $EXECUTABLE_NAME_BASE
