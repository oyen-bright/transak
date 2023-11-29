import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:transak/src/core/transak_transaction.dart';

import 'transak_method_channel.dart';

abstract class TransakPlatform extends PlatformInterface {
  /// Constructs a TransakPlatform.
  TransakPlatform() : super(token: _token);

  static final Object _token = Object();

  static TransakPlatform _instance = MethodChannelTransak();

  /// The default instance of [TransakPlatform] to use.
  ///
  /// Defaults to [MethodChannelTransak].
  static TransakPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TransakPlatform] when
  /// they register themselves.
  static set instance(TransakPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// A broadcast stream from the native platform
  Stream<dynamic> get onEvent {
    throw UnimplementedError('onEvent has not been implemented.');
  }

  Future<Map<String, String>?> initiateTransaction(
      {required TransactionParams payload}) {
    throw UnimplementedError('initiateTransaction has not been implemented.');
  }

  Future<Map<String, String>?> initiateTransactionStream(
      {required TransactionParams payload}) {
    throw UnimplementedError(
        'initiateTransactionStream has not been implemented.');
  }
}
