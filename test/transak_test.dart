import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:transak/src/platform/transak_method_channel.dart';
import 'package:transak/src/platform/transak_platform_interface.dart';
import 'package:transak/transak.dart';

class MockTransakPlatform
    with MockPlatformInterfaceMixin
    implements TransakPlatform {
  @override
  Future<Map<String, String>?> initiateTransaction(
      {required TransactionParams payload}) {
    // TODO: implement initiateTransaction
    throw UnimplementedError();
  }

  @override
  // TODO: implement onEvent
  Stream get onEvent => throw UnimplementedError();

  @override
  Future<Map<String, String>?> initiateTransactionStream(
      {required TransactionParams payload}) {
    // TODO: implement initiateTransactionStream
    throw UnimplementedError();
  }
}

void main() {
  final TransakPlatform initialPlatform = TransakPlatform.instance;

  test('$MethodChannelTransak is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTransak>());
  });

  test('initiateTransaction', () async {
    Transak transakPlugin = Transak();
    MockTransakPlatform fakePlatform = MockTransakPlatform();
    TransakPlatform.instance = fakePlatform;

    expect(
        await transakPlugin.initiateTransaction(
            payload: TransactionParams.forBuy(walletAddress: "walletAddress")),
        '42');
  });
}
