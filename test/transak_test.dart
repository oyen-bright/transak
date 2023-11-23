import 'package:flutter_test/flutter_test.dart';
import 'package:transak/transak.dart';
import 'package:transak/transak_platform_interface.dart';
import 'package:transak/transak_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTransakPlatform
    with MockPlatformInterfaceMixin
    implements TransakPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
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
