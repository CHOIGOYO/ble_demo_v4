import 'package:ble_demo_v4/provider/connected_dev_prov.dart';
import 'package:ble_demo_v4/widgets/base_appbar.dart';
import 'package:ble_demo_v4/widgets/base_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AboutScreen extends ConsumerStatefulWidget {
  const AboutScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AboutScreenState();
}

class _AboutScreenState extends ConsumerState<AboutScreen> {
  @override
  void initState() {
    super.initState();
    _readAndSubscribeCharacteristics();
  }

  Future<void> _readAndSubscribeCharacteristics() async {
    final connectedDev = ref.read(connectedDevProvProvider);

    if (connectedDev != null) {
      try {
        // BLE 서비스 검색
        var services = await connectedDev.device.discoverServices();
        debugPrint('+++Discovered Services: $services');

        for (var service in services) {
          for (var characteristic in service.characteristics) {
            // Notify 또는 Indicate 가능한 특성 찾기
            if (characteristic.properties.notify ||
                characteristic.properties.indicate) {
              debugPrint(
                  '+++Found characteristic: ${characteristic.uuid} in service: ${service.uuid}');

              // 이미 Notify 설정 여부 확인
              if (!characteristic.isNotifying) {
                try {
                  // 디스크립터 설정 (Notify 활성화 전에 설정 필요)
                  for (var descriptor in characteristic.descriptors) {
                    if (descriptor.uuid.toString() ==
                        '00002902-0000-1000-8000-00805f9b34fb') {
                      await descriptor.write([0x01, 0x00]);
                      debugPrint(
                          '+++Descriptor ${descriptor.uuid} written with [0x01, 0x00]');
                    }
                  }

                  // Notify 활성화
                  await characteristic.setNotifyValue(true);

                  // 데이터 수신
                  characteristic.lastValueStream.listen((value) {
                    debugPrint(
                        '+++Raw data from ${characteristic.uuid}: $value');
                    String decodedValue = String.fromCharCodes(value);
                    debugPrint('+++Decoded data: $decodedValue');
                  });
                } catch (e) {
                  debugPrint(
                      '+++Error setting Notify for characteristic ${characteristic.uuid}: $e');
                }
              } else {
                debugPrint(
                    '+++Characteristic ${characteristic.uuid} is already notifying.');
              }
            } else {
              debugPrint(
                  '+++Characteristic ${characteristic.uuid} does not support Notify or Indicate.');
            }
          }
        }
      } catch (e) {
        debugPrint('+++Error discovering services or subscribing: $e');
      }
    } else {
      debugPrint('+++No connected device found.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final connectedDev = ref.watch(connectedDevProvProvider);

    return BaseLayout(
      child: Column(
        children: [
          BaseAppbar(title: connectedDev?.device.platformName ?? 'unknown'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                  'ConnectionState: ${connectedDev?.device.isConnected == true ? 'Connected' : 'Disconnected'}'),
              Text('MAC: ${connectedDev?.device.remoteId ?? 'unknown'}'),
              Container(
                margin: const EdgeInsets.only(top: 24),
                child: const Text('Read Data'),
              ),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16),
                child: const Text('1234'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
