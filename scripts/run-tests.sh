#!/bin/bash
set -euo pipefail

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    echo "Usage: $0 [simulator-name-or-uuid]"
    echo "Runs all BeerMais Dev tests with coverage (default: iPhone 18 Pro)."
    echo "Uses the selected Xcode; override with DEVELOPER_DIR."
    echo "Override the build cache with BEERMAIS_DERIVED_DATA."
    echo "Set BEERMAIS_TEST_RESULTS_DIR to a parent directory for unique run artifacts."
    exit 0
fi
if [[ $# -gt 1 ]]; then
    echo "Usage: $0 [simulator-name-or-uuid]" >&2
    exit 1
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
export DEVELOPER_DIR="${DEVELOPER_DIR:-$(xcode-select -p)}"
if [[ ! -d "${DEVELOPER_DIR}" ]]; then
    echo "Xcode developer directory not found: ${DEVELOPER_DIR}" >&2
    exit 1
fi

SIMULATOR_TARGET="${1:-iPhone 18 Pro}"
if [[ "${SIMULATOR_TARGET}" =~ ^[[:xdigit:]]{8}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{12}$ ]]; then
    DESTINATION="platform=iOS Simulator,id=${SIMULATOR_TARGET}"
else
    DESTINATION="platform=iOS Simulator,name=${SIMULATOR_TARGET}"
fi

cd -- "${PROJECT_DIR}"
DERIVED_DATA="${BEERMAIS_DERIVED_DATA:-${HOME}/Library/Developer/Xcode/DerivedData/BeerMais-Dev}"
RESULT_PARENT="${BEERMAIS_TEST_RESULTS_DIR:-${TMPDIR:-/tmp}}"
mkdir -p -- "${RESULT_PARENT}"
RESULT_DIR="$(mktemp -d "${RESULT_PARENT%/}/BeerMais-tests.XXXXXX")"
RESULT_BUNDLE="${RESULT_DIR}/Tests.xcresult"
echo "Results: ${RESULT_BUNDLE}"
echo "Log: ${RESULT_DIR}/xcodebuild.log"

# Xcode owns simulator selection, startup, and test installation.
# pipefail preserves test failures while tee keeps live output and a saved log.
if xcodebuild test \
    -project "${PROJECT_DIR}/BeerMais.xcodeproj" \
    -scheme "BeerMais Dev" \
    -configuration Debug \
    -destination "${DESTINATION}" \
    -derivedDataPath "${DERIVED_DATA}" \
    -resultBundlePath "${RESULT_BUNDLE}" \
    -onlyUsePackageVersionsFromResolvedFile \
    -enableCodeCoverage YES \
    -parallel-testing-enabled NO \
    CODE_SIGNING_ALLOWED=NO 2>&1 | tee "${RESULT_DIR}/xcodebuild.log"; then
    echo "Tests passed. Results: ${RESULT_BUNDLE}"
    xcrun xccov view --report "${RESULT_BUNDLE}"
else
    STATUS=$?
    echo "Tests failed (exit ${STATUS}). Results: ${RESULT_BUNDLE}" >&2
    echo "Log: ${RESULT_DIR}/xcodebuild.log" >&2
    exit "${STATUS}"
fi
