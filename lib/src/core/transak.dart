import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:transak/src/core/transak_enum.dart';
import 'package:transak/src/core/transak_event.dart';
import 'package:transak/src/core/transak_session.dart';
import 'package:transak/src/core/transak_transaction.dart';
import 'package:transak/src/platform/transak_platform_interface.dart';

import 'transak_config.dart';
import 'transak_exception.dart';

class Transak {
  static final StreamController<Map> pusherEvents =
      StreamController<Map>.broadcast();

  StreamSubscription? _pluginEventSubscription;
  PusherChannelsFlutter? _pusher;
  String? _channelName;

  Stream<dynamic> get transactionEvents => pusherEvents.stream;
  TransakConfigParams get getSessionData {
    if (SessionConfig.config != null) {
      return SessionConfig.config!;
    }
    throw TransakException(
        "Transak not configured. Did you forget to call Transak.config?");
  }

  TransakEnvironment get getEnvironment {
    if (SessionConfig.environment != null) {
      return SessionConfig.environment!;
    }

    throw TransakException(
        "Transak not configured. Did you forget to call Transak.config?");
  }

  Future<void> config({
    required String apiKey,
    String iosModalTitle = "Transak",
    TransakEnvironment environment = TransakEnvironment.production,
    String? exchangeScreenTitle,
    String productsAvailed = "BUY,SELL",
    String? defaultFiatCurrency,
    String? countryCode,
    String? excludeFiatCurrencies,
    String? defaultNetwork,
    String? defaultPaymentMethod,
    String? paymentMethod,
    String? disablePaymentMethods,
    String? defaultCryptoCurrency,
    String? cryptoCurrencyList,
    bool isFeeCalculationHidden = false,
    bool hideExchangeScreen = false,
    bool disableWalletAddressForm = false,
    bool isAutoFillUserData = false,
    String? themeColor,
    bool hideMenu = false,
    required String redirectURL,
    bool walletRedirection = false,
    String? networks,
    int? defaultFiatAmount,
  }) async {
    _setUpPusher();
    SessionConfig.sessionConfig(
        TransakConfigParams(
          apiKey: apiKey,
          exchangeScreenTitle: exchangeScreenTitle,
          productsAvailed: productsAvailed,
          defaultFiatCurrency: defaultFiatCurrency,
          countryCode: countryCode,
          excludeFiatCurrencies: excludeFiatCurrencies,
          defaultNetwork: defaultNetwork,
          defaultPaymentMethod: defaultPaymentMethod,
          paymentMethod: paymentMethod,
          disablePaymentMethods: disablePaymentMethods,
          defaultCryptoCurrency: defaultCryptoCurrency,
          cryptoCurrencyList: cryptoCurrencyList,
          isFeeCalculationHidden: isFeeCalculationHidden,
          hideExchangeScreen: hideExchangeScreen,
          disableWalletAddressForm: disableWalletAddressForm,
          isAutoFillUserData: isAutoFillUserData,
          themeColor: themeColor,
          hideMenu: hideMenu,
          redirectURL: redirectURL,
          walletRedirection: walletRedirection,
          networks: networks,
          defaultFiatAmount: defaultFiatAmount,
        ),
        modalTitle: iosModalTitle,
        environment: environment);

    return;
  }

  void _setUpPusher() async {
    _pusher ??= PusherChannelsFlutter.getInstance();
    try {
      await _pusher?.init(
        apiKey: "1d9ffac87de599c61283",
        cluster: "ap2",
        onError: _onError,
        onEvent: _onEvent,
      );
    } catch (e) {
      log("ERROR in Pusher setup: $e", name: "Pusher Error");
    }
  }

  void _onError(String message, int? code, dynamic error) {
    pusherEvents.add({
      "eventName": "TRANSAK_PUSHER_ERROR",
      "data": {"message": message, "code": code, "error": error},
    });
  }

  void _onEvent(PusherEvent event) {
    pusherEvents.add({
      "eventName": event.eventName,
      "data": event.data,
    });
  }

  Future<Map<String, String>?> initiateTransaction({
    required TransactionParams payload,
  }) async {
    _eventListener();
    try {
      final response =
          await TransakPlatform.instance.initiateTransaction(payload: payload);
      return response;
    } on PlatformException catch (e) {
      throw TransakException(e.message.toString(), errorCode: e.code);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> initiateTransactionWithStream(TransactionParams payload,
      {required StreamController<TransakEvent> streamController,
      TransactionEventName? filterEvent}) async {
    _eventListener(
        streamController: streamController, filterEvent: filterEvent);
    try {
      await TransakPlatform.instance
          .initiateTransactionStream(payload: payload);
    } on PlatformException catch (e) {
      throw TransakException(e.message.toString(), errorCode: e.code);
    } catch (e) {
      rethrow;
    }
  }

  void _eventListener({
    StreamController<TransakEvent>? streamController,
    TransactionEventName? filterEvent,
  }) {
    _pluginEventSubscription?.cancel();
    _pluginEventSubscription = TransakPlatform.instance.onEvent.listen(
      (event) => handleEvents(event, streamController, filterEvent),
      onError: (error) {
        pusherEvents.add({
          "eventName": "TRANSAK_ERROR",
          "data": error.toString(),
        });
      },
    );
  }

  void handleEvents(
    dynamic event,
    StreamController<TransakEvent>? streamController,
    TransactionEventName? filterEvent,
  ) {
    if (streamController != null && event is Map) {
      final transactionId = Map.from(event)['orderId'];
      _unsubscribeFromPusher();
      _subscribeToPusher(transactionId, streamController, filterEvent);
      _connectToPusher();
    }
    log("Event coming $event", name: "from plugin");
  }

  void _unsubscribeFromPusher() {
    if (_channelName != null) {
      _pusher!.unsubscribe(channelName: _channelName!);
      _channelName = null;
    }
  }

  void _subscribeToPusher(
    String? transactionId,
    StreamController<TransakEvent>? streamController,
    TransactionEventName? filterEvent,
  ) {
    if (transactionId != null) {
      _pusher?.subscribe(
        channelName: transactionId,
        onEvent: (dynamic event) {
          if (event == null) return;

          final transakEvent = TransakEvent.fromPusherEvent(event);
          if (transakEvent.transactionEventName != null &&
              (filterEvent == null ||
                  transakEvent.transactionEventName == filterEvent)) {
            streamController?.add(transakEvent);
          }
        },
      );
    }
  }

  void _connectToPusher() {
    _pusher?.connect();
  }

  // void _eventListener(
  //     {StreamController<TransakEvent>? streamController,
  //     TransactionEventName? filterEvent}) {
  //   _pluginEventSubscription?.cancel();
  //   _pluginEventSubscription =
  //       TransakPlatform.instance.onEvent.listen((event) async {
  //     if (streamController != null) {
  //       if (event is Map) {
  //         final transactionId = Map.from(event)['orderId'];
  //         channelName != null
  //             ? await _pusher!.unsubscribe(channelName: channelName!)
  //             : null;
  //         channelName = (await _pusher?.subscribe(
  //                 channelName: transactionId,
  //                 onEvent: (dynamic event) {
  //                   if (event != null) {
  //                     final transakEvent = TransakEvent.fromPusherEvent(event);
  //                     if (transakEvent.transactionEventName != null) {
  //                       if (filterEvent != null) {
  //                         transakEvent.transactionEventName == filterEvent
  //                             ? streamController.add(transakEvent)
  //                             : null;
  //                       } else {
  //                         streamController.add(transakEvent);
  //                       }
  //                     }
  //                   }
  //                 }))
  //             ?.channelName;
  //         await _pusher?.connect();
  //       }
  //       log("Event coming $event", name: "from plugin");
  //     }
  //   }, onError: (error) {
  //     pusherEvents.add({
  //       "eventName": "TRANSAK_ERROR",
  //       "data": error.toString(),
  //     });
  //   });
  // }

  void dispose() {
    _pluginEventSubscription?.cancel();
    pusherEvents.close();
    _pusher?.disconnect();
  }
}
