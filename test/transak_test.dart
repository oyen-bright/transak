import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:transak/src/platform/transak_method_channel.dart';
import 'package:transak/src/platform/transak_platform_interface.dart';
import 'package:transak/transak.dart';

class MockTransakPlatform
    with MockPlatformInterfaceMixin
    implements TransakPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future initiateTransaction({required TransactionParams payload}) {
    // TODO: implement initiateTransaction
    throw UnimplementedError();
  }
}

void main() {
  final TransakPlatform initialPlatform = TransakPlatform.instance;

  test('$MethodChannelTransak is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTransak>());
  });

  test('getPlatformVersion', () async {
    Transak transakPlugin = Transak();
    MockTransakPlatform fakePlatform = MockTransakPlatform();
    TransakPlatform.instance = fakePlatform;

    expect(await transakPlugin.getPlatformVersion(), '42');
  });
}
