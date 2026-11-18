# Realme Buds Tracker (Flutter / Android)

Android app for Realme Air Buds 7. Builds an APK on GitHub Actions.

Status: v0.2. Three screens (Dashboard, Buds, Analytics) with placeholder data. Bluetooth connection, saved history, and export are not wired up yet.

## Get the APK from GitHub

1. Create a GitHub repo and push this folder to the `main` branch.
2. Open the Actions tab. The "Build APK" workflow runs automatically on each push. You can also run it from "Run workflow".
3. When it finishes, open the run and download the `realme-buds-tracker-apk` artifact.
4. Unzip it and copy `app-release.apk` to your phone. Allow installs from unknown sources when Android asks.

## Change your name

Edit `userName` at the top of `lib/main.dart`.

## Run locally (optional)

Install Flutter, then:

    flutter create --platforms=android --project-name realme_buds_tracker .
    python scripts/add_permissions.py android/app/src/main/AndroidManifest.xml
    flutter run

## Notes

- The Bluetooth permissions are added by the workflow script. Android asks for them at runtime when the connection feature is built.
- Realme's protocol is not public. Connection and readings depend on a BLE discovery dump from your buds.
- Dark theme follows the phone setting.
