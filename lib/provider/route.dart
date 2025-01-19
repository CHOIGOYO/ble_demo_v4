import 'package:ble_demo_v4/views/about_screen.dart';
import 'package:ble_demo_v4/views/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => AboutScreen(),
      )
    ],
  );
});
