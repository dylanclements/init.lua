#!/bin/bash

set -e

# Run remap tests
if [ -f "test/test_remaps.sh" ]; then
  echo "Running remap tests..."
  ./test/test_remaps.sh
fi

# Run nvim startup tests
if [ -f "test/test_nvim_startup.sh" ]; then
  echo "Running nvim startup tests..."
  ./test/test_nvim_startup.sh
fi

# Run Bazel tests if present
if [ -f "test/bazel/run_bazel_tests.sh" ]; then
  echo "Running Bazel test suite..."
  ./test/bazel/run_bazel_tests.sh
elif [ -f "test/bazel_tests/run_bazel_tests.sh" ]; then
  echo "Running Bazel test suite..."
  ./test/bazel_tests/run_bazel_tests.sh
elif [ -f "test/run_bazel_tests.sh" ]; then
  echo "Running Bazel test suite..."
  ./test/run_bazel_tests.sh
fi 