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

  Future<Map<String, String>?> initiateTransaction(
      {required TransactionParams payload}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
