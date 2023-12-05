import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:transak/src/core/transak_config.dart';
import 'package:transak/src/core/transak_transaction.dart';
import 'package:transak/src/utils/generate_url.dart';

import '../core/transak_exception.dart';
import '../core/transak_session.dart';
import 'transak_platform_interface.dart';

/// An implementation of [TransakPlatform] that uses method channels.
class MethodChannelTransak extends TransakPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final MethodChannel methodChannel = const MethodChannel('brinnixs/transak');

  /// The event channel used to receive changes from the native platform.
  @visibleForTesting
  final EventChannel eventChannel =
      const EventChannel('brinnixs/transak/events');

  @override
  Stream<dynamic> get onEvent => eventChannel.receiveBroadcastStream();

  @override
  Future<Map<String, String>?> initiateTransaction(
      {required TransactionParams payload}) async {
    return _initiateTransactionCommon(payload, 'initiateTransaction');
  }

  @override
  Future<Map<String, String>?> initiateTransactionStream(
      {required TransactionParams payload}) async {
    return _initiateTransactionCommon(payload, 'initiateTransactionStream');
  }

  /// Common logic for initiating a transaction.
  Future<Map<String, String>?> _initiateTransactionCommon(
      TransactionParams payload, String method) async {
    final ({
      String? modalTitle,
      TransakConfigParams? params,
      String? url
    })? sessionConfig = SessionConfig.sessionData;
    if (sessionConfig == null) {
      throw TransakException(
          "Transak not configured. Did you forget to call Transak.config?");
    }
    final ({String redirectURL, String url}) urls =
        urlBuilder(sessionConfig.url!, payload, sessionConfig.params!);

    final dynamic response = await methodChannel.invokeMethod<dynamic>(method, {
      'url': urls.url,
      'redirectURL': urls.redirectURL,
      'title': sessionConfig.modalTitle,
    });
    return Map<String, String>.from(response);
  }
}
