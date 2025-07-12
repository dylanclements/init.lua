#!/bin/bash

# Test orchestrator for Neovim configuration
# Runs all test_*.sh files in the repository

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Test results tracking
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
FAILED_TEST_NAMES=()

# Function to print colored output
print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  Neovim Config Test Suite${NC}"
    echo -e "${BLUE}================================${NC}"
    echo ""
}

print_footer() {
    echo ""
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  Test Summary${NC}"
    echo -e "${BLUE}================================${NC}"
    echo -e "Total tests run: ${CYAN}$TOTAL_TESTS${NC}"
    echo -e "Passed: ${GREEN}$PASSED_TESTS${NC}"
    echo -e "Failed: ${RED}$FAILED_TESTS${NC}"
    
    if [ $FAILED_TESTS -gt 0 ]; then
        echo ""
        echo -e "${RED}Failed tests:${NC}"
        for test_name in "${FAILED_TEST_NAMES[@]}"; do
            echo -e "  ${RED}❌ $test_name${NC}"
        done
        echo ""
        echo -e "${YELLOW}💡 Some tests failed. Check the output above for details.${NC}"
        exit 1
    else
        echo ""
        echo -e "${GREEN}🎉 All tests passed! Your Neovim config looks good.${NC}"
        exit 0
    fi
}

# Function to run a single test
run_test() {
    local test_file="$1"
    local test_name=$(basename "$test_file" .sh)
    
    echo -e "${CYAN}🧪 Running: $test_name${NC}"
    echo -e "${PURPLE}File: $test_file${NC}"
    echo ""
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    # Run the test and capture output and exit code
    local output
    local exit_code
    
    if output=$(bash "$test_file" 2>&1); then
        exit_code=0
    else
        exit_code=$?
    fi
    
    # Print the test output with indentation
    if [ -n "$output" ]; then
        echo "$output" | sed 's/^/  /'
        echo ""
    fi
    
    # Check if test passed
    if [ $exit_code -eq 0 ]; then
        echo -e "${GREEN}✅ PASS: $test_name${NC}"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        echo -e "${RED}❌ FAIL: $test_name (exit code: $exit_code)${NC}"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        FAILED_TEST_NAMES+=("$test_name")
    fi
    
    echo ""
    echo -e "${BLUE}--------------------------------${NC}"
    echo ""
}

# Main execution
main() {
    print_header
    
    # Find all test_*.sh files
    local test_files=($(find . -name "test_*.sh" -type f | sort))
    
    if [ ${#test_files[@]} -eq 0 ]; then
        echo -e "${YELLOW}⚠️  No test_*.sh files found in the repository.${NC}"
        exit 0
    fi
    
    echo -e "${CYAN}Found ${#test_files[@]} test file(s):${NC}"
    for test_file in "${test_files[@]}"; do
        echo -e "  📄 $test_file"
    done
    echo ""
    
    # Run each test
    for test_file in "${test_files[@]}"; do
        run_test "$test_file"
    done
    
    print_footer
}

# Handle script interruption
trap 'echo -e "\n${YELLOW}⚠️  Test execution interrupted${NC}"; exit 130' INT

# Run the main function
main "$@" 