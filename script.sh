#!/bin/bash

TEST_CMD="xctool -project Orchextra.xcodeproj -scheme Orchextra build test -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 6s,OS=9.2' GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES GCC_GENERATE_TEST_COVERAGE_FILES=YES"

which -s xcpretty
XCPRETTY_INSTALLED=$?

if [[ $TRAVIS || $XCPRETTY_INSTALLED == 0 ]]; then
  eval "${TEST_CMD} | xcpretty"
else
  eval "$TEST_CMD"
fi