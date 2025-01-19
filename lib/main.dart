import 'package:ble_demo_v4/provider/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      // URI String & 상태 Go Router에서 사용할 수 있는 형태로 변환
      routeInformationParser: router.routeInformationParser,
      // Go Router에서 사용할 수 있는 형태로 변환된 값을 어떤 라우트로 전달하는지 정의
      routerDelegate: router.routerDelegate,
      // 라우트 정보 전달
      routeInformationProvider: router.routeInformationProvider,
      title: 'BLE DEMO V4',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          buttonTheme: ButtonThemeData(buttonColor: Colors.blue)),
    );
  }
}
