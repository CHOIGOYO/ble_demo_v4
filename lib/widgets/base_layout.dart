import 'dart:async';

import 'package:ble_demo_v4/provider/scan_result_prov.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BaseLayout extends ConsumerStatefulWidget {
  bool isHome;
  final Widget child;
  BaseLayout({super.key, required this.child, this.isHome = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends ConsumerState<BaseLayout> {
  List<BluetoothDevice> _systemDevices = [];
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  @override
  void initState() {
    super.initState();

    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results
          .where((r) => r.device.platformName.isNotEmpty)
          .toSet()
          .toList();
      ref.read(scanResultProvProvider.notifier).setScanResult(_scanResults);
      if (mounted) {
        setState(() {});
      }
    }, onError: (e) {
      debugPrint('Error: $e');
    });

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    super.dispose();
  }

  Future onScanPressed() async {
    try {
      // `withServices` is required on iOS for privacy purposes, ignored on android.
      var withServices = [Guid("180f")]; // Battery Level Service
      _systemDevices = await FlutterBluePlus.systemDevices(withServices);
    } catch (e) {
      debugPrint('Error: $e');
    }
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    } catch (e) {
      debugPrint('Error: $e');
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: widget.child,
              ),
            ),
          ),
          floatingActionButton: widget.isHome
              ? FloatingActionButton(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.lightBlue,
                  onPressed: () {
                    if (_isScanning) {
                      FlutterBluePlus.stopScan();
                    } else {
                      onScanPressed();
                    }
                  },
                  child: Icon(
                      !_isScanning ? Icons.bluetooth_searching : Icons.stop))
              : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat),
    );
  }
}
