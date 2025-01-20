import 'dart:async';

import 'package:ble_demo_v4/provider/connected_dev_prov.dart';
import 'package:ble_demo_v4/provider/scan_result_prov.dart';
import 'package:ble_demo_v4/utils/extra.dart';
import 'package:ble_demo_v4/utils/snackbar.dart';
import 'package:ble_demo_v4/widgets/base_appbar.dart';
import 'package:ble_demo_v4/widgets/base_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

// 홈 화면
class _HomeScreenState extends ConsumerState<HomeScreen> {
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  @override
  void initState() {
    super.initState();
    _adapterStateStateSubscription =
        FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();
    super.dispose();
  }

  void onConnectPressed(BluetoothDevice device, int index) {
    device.connectAndUpdateStream().catchError((e) {
      Snackbar.show(ABC.c, prettyException("Connect Error:", e),
          success: false);
    }).then((_) async {
      if (device.isConnected) {
        ref
            .read(connectedDevProvProvider.notifier)
            .setConnectedDev(ref.read(scanResultProvProvider)[index]);
        debugPrint('Connected to ${device.platformName}');

        context.push('/about');
      } else {
        Snackbar.show(ABC.c, 'Failed to connect', success: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      isHome: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 제목
            BaseAppbar(
              title: 'BLE DEMO V4',
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: ref.watch(scanResultProvProvider).length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          FlutterBluePlus.stopScan();
                          onConnectPressed(
                              ref.watch(scanResultProvProvider)[index].device,
                              index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey.shade300, width: 1))),
                          child: ListTile(
                            title: Text(ref
                                .watch(scanResultProvProvider)[index]
                                .device
                                .platformName),
                            subtitle: Text(
                                'Device RemoteId : ${ref.watch(scanResultProvProvider)[index].device.remoteId}'),
                            trailing: Text(
                                'RSSI : ${ref.watch(scanResultProvProvider)[index].rssi}'),
                          ),
                        ),
                      );
                    })),
            // 버튼
          ],
        ),
      ),
    );
  }
}
