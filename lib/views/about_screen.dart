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
        // 서비스 검색
        var services = await connectedDev.device.discoverServices();
        // debugPrint('Services: $services', wrapWidth: 1024);
        debugPrint('Services: $services');
        for (var service in services) {
          for (var characteristic in service.characteristics) {
            // notify 또는 indicate 가능한 특성 찾기
            if (characteristic.properties.notify ||
                characteristic.properties.indicate) {
              debugPrint(
                  'Subscribing to characteristic: ${characteristic.uuid} from service: ${service.uuid}');
              // 특성 구독
              await characteristic.setNotifyValue(true);
              // 데이터 수신 및 출력
              characteristic.lastValueStream.listen((value) {
                debugPrint('Received data from ${characteristic.uuid}: $value');
                String decodedValue = String.fromCharCodes(value);
                debugPrint('Decoded data: $decodedValue');
              });
            }
          }
        }
      } catch (e) {
        debugPrint('Error discovering services or subscribing: $e');
      }
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
                margin: EdgeInsets.only(top: 24),
                child: Text('Read Data'),
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
                padding: EdgeInsets.all(16),
                child: Text('1234'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
