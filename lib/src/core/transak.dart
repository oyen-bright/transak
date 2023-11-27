import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:transak/src/core/transak_enum.dart';
import 'package:transak/src/core/transak_session.dart';
import 'package:transak/src/core/transak_transaction.dart';
import 'package:transak/src/platform/transak_platform_interface.dart';

import 'transak_config.dart';
import 'transak_exception.dart';

class Transak {
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

  TransakConfigParams getSessionData() {
    if (SessionConfig.config != null) {
      return SessionConfig.config!;
    }
    throw TransakException(
        "Transak not configured. Did you forget to call Transak.config?");
  }

  TransakEnvironment getEnvironment() {
    if (SessionConfig.environment != null) {
      return SessionConfig.environment!;
    }

    throw TransakException(
        "Transak not configured. Did you forget to call Transak.config?");
  }

  Future<dynamic> initiateTransaction({required TransactionParams payload}) {
    try {
      return TransakPlatform.instance.initiateTransaction(payload: payload);
    } catch (e) {
      if (e is PlatformException) {
        throw TransakException(e.message.toString(), errorCode: e.code);
      } else {
        log("Error during initial transaction: $e", name: 'Transak');
        rethrow;
      }
    }
  }
}
