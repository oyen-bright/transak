import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transak/src/platform/transak_method_channel.dart';
import 'package:transak/transak.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelTransak platform = MethodChannelTransak();
  const MethodChannel channel = MethodChannel('transak');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('initiateTransaction', () async {
    expect(
        await platform.initiateTransaction(
            payload: TransactionParams.forBuy(walletAddress: "")),
        '42');
  });
}
