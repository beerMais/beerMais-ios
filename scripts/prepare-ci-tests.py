#!/usr/bin/env python3
"""Supply only the missing Firebase resource for the hostless CI test build."""

import os
from pathlib import Path
import plistlib


def main():
    if os.environ.get("CI") != "true":
        raise SystemExit("This preparation script is only intended for CI builds.")

    project = Path(__file__).resolve().parent.parent
    firebase = project / "BeerMais/Property lists/Dev/GoogleService-Info.plist"
    # Exclusive creation protects existing developer or runner configuration.
    if firebase.exists():
        print("Existing Firebase resource preserved.")
        return
    firebase.parent.mkdir(parents=True, exist_ok=True)
    with firebase.open("xb") as resource:
        plistlib.dump({
            "API_KEY": "ci-placeholder-not-a-real-key",
            "GCM_SENDER_ID": "000000000000",
            "PLIST_VERSION": "1",
            "BUNDLE_ID": "br.com.joseneves.BeerMais.debug",
            "PROJECT_ID": "beermais-ci-placeholder",
            "GOOGLE_APP_ID": "1:000000000000:ios:0000000000000000",
            "IS_ADS_ENABLED": False,
            "IS_ANALYTICS_ENABLED": False,
            "IS_APPINVITE_ENABLED": False,
            "IS_GCM_ENABLED": False,
            "IS_SIGNIN_ENABLED": False,
        }, resource)
    print("Created inert Firebase resource for the hostless test build.")


if __name__ == "__main__":
    main()
