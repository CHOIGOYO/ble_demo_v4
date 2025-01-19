import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scan_result_prov.g.dart';

@riverpod
class ScanResultProv extends _$ScanResultProv {
  @override
  List<ScanResult> build() {
    return [];
  }

  // 스캔한 결과 저장
  void setScanResult(List<ScanResult> scanResult) {
    state = scanResult;
  }

  // 스캔 결과 초기화
  void clear() {
    state = [];
  }
}
