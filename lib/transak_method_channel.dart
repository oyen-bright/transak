import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'transak_platform_interface.dart';

/// An implementation of [TransakPlatform] that uses method channels.
class MethodChannelTransak extends TransakPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('transak');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
