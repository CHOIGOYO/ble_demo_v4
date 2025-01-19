import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connected_dev_prov.g.dart';

@Riverpod(keepAlive: true)
class ConnectedDevProv extends _$ConnectedDevProv {
  @override
  ScanResult? build() {
    return null;
  }

  void setConnectedDev(ScanResult connectedDev) {
    state = connectedDev;
  }

  void clear() {
    state = null;
  }
}
