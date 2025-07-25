#!/bin/sh -ve
flutter pub add fcm_shared_isolate:0.1.0
sed -i '' 's,//<GOOGLE_SERVICES>,,g' lib/utils/background_push.dart
yq eval '.dependencies.fcm_shared_isolate = "0.1.0"' -i pubspec.yaml # Workaround: 0.2.0 does not work on iOS
flutter clean
flutter pub get
cd ios
rm -rf Pods
rm -f Podfile.lock
pod install
pod update
cd ..
flutter build ios --release
cd ios
bundle update fastlane
bundle exec fastlane beta
cd ..