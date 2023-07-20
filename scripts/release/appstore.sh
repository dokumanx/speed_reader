#!/bin/bash
. scripts/build/ios.sh && source .appstore/.env && xcrun altool --upload-app --type ios -f build/ios/ipa/*.ipa --apiKey $API_KEY --apiIssuer $API_ISSUER