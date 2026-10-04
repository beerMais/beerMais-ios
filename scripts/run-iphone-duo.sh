#!/bin/bash
set -euo pipefail

# Usage: ./scripts/run-iphone-duo.sh [simulator-name-or-uuid]
# Overrides: DEVELOPER_DIR, DUO_ID, BEERMAIS_DERIVED_DATA
if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    echo "Usage: $0 [simulator-name-or-uuid]"
    echo "Builds and launches BeerMais Dev without opening Xcode."
    echo "Example: $0 \"iPhone 17 Pro\""
    echo "List simulator names and IDs with: xcrun simctl list devices available"
    exit 0
fi
if [[ $# -gt 1 ]]; then
    echo "Usage: $0 [simulator-name-or-uuid]" >&2
    exit 1
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
export DEVELOPER_DIR="${DEVELOPER_DIR:-/Applications/Xcode.27.1.app/Contents/Developer}"
SIMULATOR_TARGET="${1:-${DUO_ID:-4FFEA079-27DE-42D7-99CD-586544826EA2}}"
# Keep package checkouts out of /tmp, where cleanup can leave stale package state.
DERIVED_DATA="${BEERMAIS_DERIVED_DATA:-${HOME}/Library/Developer/Xcode/DerivedData/BeerMais-Dev}"

if [[ ! -d "${DEVELOPER_DIR}" ]]; then
    echo "Xcode developer directory not found: ${DEVELOPER_DIR}" >&2
    echo "Set DEVELOPER_DIR to your Xcode installation's Contents/Developer directory." >&2
    exit 1
fi

SIMULATOR_ID="$(xcrun simctl list devices available --json | python3 -c '
import json
import sys

target = sys.argv[1]
matches = [
    (runtime, device)
    for runtime, devices in json.load(sys.stdin)["devices"].items()
    for device in devices
    if device["name"] == target or device["udid"].lower() == target.lower()
]
if not matches:
    sys.exit(f"No available simulator matches: {target}")
if len(matches) > 1:
    print(f"Multiple simulators match {target!r}; pass a UUID instead:", file=sys.stderr)
    for runtime, device in matches:
        print("  {} ({})".format(device["udid"], runtime), file=sys.stderr)
    sys.exit(1)
print(matches[0][1]["udid"])
' "${SIMULATOR_TARGET}")"

# Resolve relative output paths consistently, even when invoked outside the repo.
cd -- "${PROJECT_DIR}"
echo "Building BeerMais Dev for simulator ${SIMULATOR_ID}..."
xcodebuild \
    -project "${PROJECT_DIR}/BeerMais.xcodeproj" \
    -scheme "BeerMais Dev" \
    -configuration Debug \
    -destination "platform=iOS Simulator,id=${SIMULATOR_ID}" \
    -derivedDataPath "${DERIVED_DATA}" \
    CODE_SIGNING_ALLOWED=NO \
    build

APP_PATH="${DERIVED_DATA}/Build/Products/Debug-iphonesimulator/BeerMais.app"
BUNDLE_ID="$(/usr/libexec/PlistBuddy -c 'Print CFBundleIdentifier' "${APP_PATH}/Info.plist")"

echo "Waiting for simulator startup..."
# -b boots the simulator if needed and waits for startup; already-booted is OK.
xcrun simctl bootstatus "${SIMULATOR_ID}" -b

echo "Installing ${APP_PATH}..."
xcrun simctl install "${SIMULATOR_ID}" "${APP_PATH}"

echo "Launching ${BUNDLE_ID}..."
xcrun simctl launch --terminate-running-process "${SIMULATOR_ID}" "${BUNDLE_ID}"
echo "BeerMais Dev is running on simulator ${SIMULATOR_ID}."
