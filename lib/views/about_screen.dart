import 'dart:async';
import 'dart:convert';

import 'package:ble_demo_v4/provider/connected_dev_prov.dart';
import 'package:ble_demo_v4/widgets/base_appbar.dart';
import 'package:ble_demo_v4/widgets/base_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/snackbar.dart';

class AboutScreen extends ConsumerStatefulWidget {
  const AboutScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AboutScreenState();
}

class _AboutScreenState extends ConsumerState<AboutScreen> {
  late BluetoothCharacteristic c;
  AsciiDecoder asciiDecoder = AsciiDecoder();
  List<int> _value = [];
  final List<String> _decodedValue = [];
  StreamSubscription<List<int>>? _lastValueSubscription;
  final int _counter = 0;

  @override
  void initState() {
    super.initState();
    _readAndSubscribeCharacteristics();
  }

  @override
  void dispose() {
    _lastValueSubscription?.cancel();
    super.dispose();
  }

  Future onSubscribe() async {
    try {
      String op = c.isNotifying == false ? "Subscribe" : "Unsubscribe";
      await c.setNotifyValue(true);
      Snackbar.show(ABC.c, "$op : Success", success: true);
      if (c.properties.read) {
        await c.read();
      }
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Subscribe Error:", e),
          success: false);
    }
  }

  String decodeBarcodeData(List<int> data) {
    // 바이트 배열을 문자열로 변환
    String decodedString = String.fromCharCodes(data);

    // 특수문자 제거 (\r 제거)
    String cleanedString = decodedString.trim();

    return cleanedString;
  }

  Future<void> _readAndSubscribeCharacteristics() async {
    final connectedDev = ref.read(connectedDevProvProvider);
    if (connectedDev != null) {
      try {
        // BLE 서비스 검색
        var services = await connectedDev.device.discoverServices();
        // 마지막 characteristic을 찾는 반복문
        for (var service in services) {
          for (var characteristic in service.characteristics) {
            if (characteristic.properties.notify ||
                characteristic.properties.indicate) {
              c = characteristic;
            }
          }
        }
        _lastValueSubscription = c.lastValueStream.listen((value) {
          _value = value;
          // Null 문자(\x00) 제거
          String sanitizedData =
              decodeBarcodeData(_value).replaceAll('\x00', '').trim();
          if (sanitizedData.isNotEmpty) {
            _decodedValue.add(decodeBarcodeData(_value));
          }
          if (mounted) {
            onSubscribe();
            setState(() {});
          }
        });
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
    return PopScope(
      canPop: false,
      child: BaseLayout(
        child: Column(
          children: [
            BaseAppbar(title: connectedDev?.device.platformName ?? 'unknown'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                    'ConnectionState: ${connectedDev?.device.isConnected == true ? 'Connected' : 'Disconnected'}'),
                Text(
                    'Device RemoteId: ${connectedDev?.device.remoteId ?? 'unknown'}'),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: const Text('Read Data'),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  height: 400,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                      child: Text(
                    _decodedValue.join(' '),
                    overflow: TextOverflow.clip,
                  )),
                ),
                ElevatedButton(
                    onPressed: () {
                      _decodedValue.clear();
                      setState(() {});
                    },
                    child: const Text('Clear')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
