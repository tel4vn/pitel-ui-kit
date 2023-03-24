# Homebrew installs LLVM in a place that is not visible to ffigen.
# This explicitly specifies the place where the LLVM dylibs are kept.
llvm_path := if os() == "macos" {
    "--llvm-path /opt/homebrew/opt/llvm"
} else {
    ""
}

build: 
   flutter pub run build_runner build --delete-conflicting-outputs
#  flutter pub run build_runner watch --delete-conflicting-outputs

test_nats: 
   flutter run -d macos test/services/nats_test.dart

clean_and_build_android:
    flutter clean
    ./android/gradlew cleanBuildCache
    ./android/gradlew clean assembleDebug
    flutter pub get
    flutter run -t lib/main.dart  --release 

clean_and_build_ios:
    flutter clean
    rm -Rf ios/Pods
    rm ios/Podfile.lock
    rm -Rf ios/.symlinks
    rm -Rf ios/Flutter/Flutter.framework
    rm -Rf ios/Flutter/Flutter.podspec
    rm pubspec.lock
    rm ios/Runner/GeneratedPluginRegistrant.h
    rm ios/Runner/GeneratedPluginRegistrant.m
    pod repo update
    flutter pub get
    flutter build ipa -t lib/main.dart    

lint:
    cd native && cargo fmt
    dart format .

clean:
    flutter clean
    cd native && cargo clean
    
serve *args='':
    flutter pub run flutter_rust_bridge:serve {{args}}

freezed:
  echo "mason make model_freezed_json --name <your model name> -o <your output path>"

docker_build:
  docker build -t eyeview-web .
docker-run:
  docker run -d -p 1200:80 --name eyeview eyeview-web

web-run:
  flutter run -d chrome --web-renderer html --release
web-build:
  flutter build web --web-renderer html --release
web-skia:
  flutter build web --release --dart-define=FLUTTER_WEB_USE_SKIA=true 
# vim:expandtab:sw=4:ts=4