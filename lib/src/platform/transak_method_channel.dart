import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:transak/src/core/transak_transaction.dart';
import 'package:transak/src/utils/generate_url.dart';

import '../core/transak_exception.dart';
import '../core/transak_session.dart';
import 'transak_platform_interface.dart';

/// An implementation of [TransakPlatform] that uses method channels.
class MethodChannelTransak extends TransakPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('brinnixs/transak');

  @override
  Future<Map<String, String>?> initiateTransaction(
      {required TransactionParams payload}) async {
    final sessionConfig = SessionConfig.sessionData;
    if (sessionConfig == null) {
      throw TransakException(
          "Transak not configured. Did you forget to call Transak.config?");
    } else {
      final urls =
          urlBuilder(sessionConfig.url!, payload, sessionConfig.params!);

      print(urls.toString());

      final parameters =
          await methodChannel.invokeMethod<dynamic>('initiateTransaction', {
        'url': urls.url,
        'redirectURL': urls.redirectURL,
        'title': sessionConfig.modalTitle,
      });
      if (parameters != null) {
        return Map.from(parameters);
      } else {
        return null;
      }
    }
  }
}
