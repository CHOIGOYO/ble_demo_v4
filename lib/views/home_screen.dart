import 'package:ble_demo_v4/widgets/base_appbar.dart';
import 'package:ble_demo_v4/widgets/base_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

// 홈 화면
class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      child: Column(
        children: [
          // 제목
          BaseAppbar(
            title: 'BLE DEMO V4',
          ),
          // 버튼
        ],
      ),
    );
  }
}
