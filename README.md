# flutter_ble_demo_v4

iOS,AOS BLE 통신 테스트 앱

## 개발 환경

```dart
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.27.1, on macOS 15.2 24C101 darwin-arm64, locale ko-KR)
[✓] Android toolchain - develop for Android devices (Android SDK version 35.0.0)
[✓] Xcode - develop for iOS and macOS (Xcode 16.2)
[✓] Chrome - develop for the web
[✓] Android Studio (version 2024.2)
[✓] IntelliJ IDEA Ultimate Edition (version 2024.2.4)
[✓] IntelliJ IDEA Community Edition (version 2024.2.4)
[✓] VS Code (version 1.96.2)
[✓] Network resources
• No issues found!
```

## 안드로이드 권한 설정 (/android/app/src/main/AndroidManifest.xml)

```kotlin
<!-- New Bluetooth permissions in Android 12
https://developer.android.com/about/versions/12/features/bluetooth-permissions -->
<uses-permission android:name="android.permission.BLUETOOTH_SCAN"/>
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />

<!-- legacy for Android 11 or lower -->
<uses-permission android:name="android.permission.BLUETOOTH" android:maxSdkVersion="30" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" android:maxSdkVersion="30" />

<!-- legacy for Android 9 or lower -->
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" android:maxSdkVersion="28" />
```

## iOS 권한 설정 (/ios/Runner/Info.plist)

```swift
<dict>
    <key>NSBluetoothAlwaysUsageDescription</key>
    <string>This app needs Bluetooth to function</string>
	<key>UIBackgroundModes</key>
	<array>
    <string>bluetooth-central</string>
	</array>
    ...
```

## 기능

1. 스캔
2. 연결
3. 연결 해제
4. 구독(Receive data)
5. 구독 해제

## 앱 미리보기
https://github.com/user-attachments/assets/96e9b0dd-25c2-45bd-b2b4-37c25a2012e5

