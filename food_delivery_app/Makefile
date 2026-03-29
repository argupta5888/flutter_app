# ─────────────────────────────────────────────
#  FoodRush – run commands
# ─────────────────────────────────────────────

.PHONY: setup run-android run-web run-web-html build-android build-web clean

## Install dependencies
setup:
	flutter pub get

## Run on Android emulator (debug)
run-android:
	flutter run -d emulator --debug

## Run on Chrome (canvaskit renderer – best fidelity)
run-web:
	flutter run -d chrome --web-renderer canvaskit --web-port 8080

## Run on Chrome (html renderer – faster startup)
run-web-html:
	flutter run -d chrome --web-renderer html --web-port 8080

## List all available devices
devices:
	flutter devices

## Build Android APK (debug)
build-android-debug:
	flutter build apk --debug

## Build Android APK (release)
build-android:
	flutter build apk --release

## Build Web (canvaskit)
build-web:
	flutter build web --web-renderer canvaskit --release

## Run tests
test:
	flutter test

## Clean build artifacts
clean:
	flutter clean
	flutter pub get
