// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

/// Represents the configuration parameters used to initialize and customize the Transak widget.
///
/// The [TransakConfigParams] class encapsulates various parameters that control the behavior and appearance
/// of the Transak widget during its initialization. These parameters range from API keys to styling options
/// and are essential for tailoring the widget to fit the specific requirements of your application.
///
/// ## Configuration Parameters:
///
/// - [apiKey]: Your Transak API Key.
/// - [exchangeScreenTitle]: Title to change the exchange screen title.
/// - [productsAvailed]: A string representing the services to be availed and returns the exchange screen accordingly.
/// - [defaultFiatCurrency]: The three-letter code of the fiat currency you want the customer to buy/sell cryptocurrency.
/// - [countryCode]: The country's ISO 3166-1 alpha-2 code. The fiat currency will be displayed as per the country code.
/// - [excludeFiatCurrencies]: The fiat currencies passed as comma-separated values here will not be shown in the fiat currencies drop down on the widget.
/// - [defaultNetwork]: The default network you would prefer the customer to purchase/sell on.
/// - [defaultPaymentMethod]: The default payment method you would prefer the customer to buy/sell with.
/// - [paymentMethod]: The payment method you want to show to the customer while buying/selling.
/// - [disablePaymentMethods]: A comma-separated list of payment methods you want to disable and hide from the customers.
/// - [defaultCryptoCurrency]: The default cryptocurrency you would prefer the customer to buy/sell.
/// - [cryptoCurrencyList]: A comma-separated list of cryptoCurrencies that you would allow your customers to buy/sell.
/// - [isFeeCalculationHidden]: When true, then the customer will not see our fee breakdown. The customer will only see the total fee.
/// - [hideExchangeScreen]: When true, then the customer will not see the home screen (exchange screen).
/// - [disableWalletAddressForm]: When true, the customer will not be able to change the destination address of where the cryptocurrency is sent to.
/// - [isAutoFillUserData]: When true, then the email address will be auto-filled, but the screen will not be skipped.
/// - [themeColor]: The theme color code for the widget main color. It is used for buttons, links, and highlighted text.
/// - [hideMenu]: When true, then the customer will not see the menu options. This will hide the menu completely.
/// - [redirectURL]: Transak will redirect back to this URL with additional order info appended to the URL as parameters.
/// - [walletRedirection]: An order ID that will be used to identify the transaction once a webhook is called back to your app.
/// - [networks]: A comma-separated list of crypto networks that you would allow your customers to buy/sell.
/// - [defaultFiatAmount]: An integer amount representing how much the customer wants to spend/receive.
///
/// ## Usage:
///
/// ```dart
/// TransakConfigParams configParams = TransakConfigParams(
///   apiKey: 'your_api_key',
///   // ... other configuration parameters
/// );
/// ```
/// For more information, refer to the [Transak Documentation](https://docs.transak.com/docs/query-parameters).
class TransakConfigParams {
  /// Your Transak API Key.
  final String apiKey;

  /// Title to change the exchange screen title.
  final String? exchangeScreenTitle;

  /// A string representing the services to be availed and returns the exchange screen accordingly.
  /// If only BUY is passed, then users will see the on-ramp widget only.
  /// If SELL is passed then users will see the off-ramp widget only.
  /// Only if BUY,SELL is passed, the users will see both the widgets.
  /// If BUY,SELL is passed then users will see BUY widget first.
  /// Conversely, if SELL,BUY is passed, then users will see the SELL widget first.
  final String productsAvailed;

  /// The three-letter code of the fiat currency you want the customer to buy/sell cryptocurrency.
  /// If the fiat currency is not supported by a specific product type (BUY/SELL) then the default widget will load with all the supported fiat currencies for that product type.
  final String? defaultFiatCurrency;

  /// The country's ISO 3166-1 alpha-2 code. The fiat currency will be displayed as per the country code.
  /// If the country code is not supported by a specific product type (BUY/SELL) then the default widget will load with all the supported countries for that product type.
  final String? countryCode;

  /// The fiat currencies passed as comma-separated values here will not be shown in the fiat currencies drop down on the widget.
  final String? excludeFiatCurrencies;

  /// The default network you would prefer the customer to purchase/sell on.
  /// If you pass this param, the network will be selected by default, but the customer will still be able to select another network.
  /// If the default network selected is not supported by a product type (BUY/SELL) then the default widget with all supported networks will be shown.
  final String? defaultNetwork;

  /// The default payment method you would prefer the customer to buy/sell with.
  /// If you pass this param, the payment method will be selected by default and the customer can also select another payment method.
  final String? defaultPaymentMethod;

  /// The payment method you want to show to the customer while buying/selling.
  /// If you pass this param, then the payment method will be selected by default and the customer won't be able to select another payment method.
  final String? paymentMethod;

  /// A comma-separated list of payment methods you want to disable and hide from the customers.
  final String? disablePaymentMethods;

  /// The default cryptocurrency you would prefer the customer to buy/sell.
  /// If you pass this param, the currency will be selected by default, but the customer will still be able to select another cryptocurrency.
  /// Please ensure that the currency code passed by you is available for the specific product type (BUY/SELL).
  final String? defaultCryptoCurrency;

  /// A comma-separated list of cryptoCurrencies that you would allow your customers to buy/sell.
  /// Only these crypto currencies will be shown in the widget.
  final String? cryptoCurrencyList;

  /// When true, then the customer will not see our fee breakdown. The customer will only see the total fee.
  /// This parameter will be ignored if your fee (on top of us) is more than 1%.
  final bool isFeeCalculationHidden;

  /// When true, then the customer will not see the home screen (exchange screen).
  /// This will hide the exchange screen completely, and the customer won't be able to change the payment method, cryptocurrency, fiat amount, fiat currency, and network.
  final bool hideExchangeScreen;

  /// When true, the customer will not be able to change the destination address of where the cryptocurrency is sent to.
  final bool disableWalletAddressForm;

  /// When true, then the email address will be auto-filled, but the screen will not be skipped.
  /// Users can edit their email address, basic data like first name & the address.
  /// This parameter will be ignored if email or userData are not passed.
  final bool isAutoFillUserData;

  /// The theme color code for the widget main color. It is used for buttons, links, and highlighted text.
  /// Only hexadecimal codes are accepted.
  final String? themeColor;

  /// When true, then the customer will not see the menu options. This will hide the menu completely.
  final bool hideMenu;

  /// Transak will redirect back to this URL with additional order info appended to the URL as parameters,
  /// once the customer has completed their purchase/sell process.
  /// Please pass a valid URL otherwise it will not work.
  final String redirectURL;

  /// An order ID that will be used to identify the transaction once a webhook is called back to your app.
  final bool walletRedirection;

  /// A comma-separated list of crypto networks that you would allow your customers to buy/sell.
  /// Only these networks' cryptocurrencies will be shown in the widget.
  final String? networks;

  /// An integer amount representing how much the customer wants to spend/receive.
  /// Users can change the fiat amount if this is passed.
  /// This parameter will be skipped if fiatCurrency or countryCode is not passed.
  /// This parameter will be skipped if fiatAmount is passed.
  final int? defaultFiatAmount;

  /// Represents the configuration parameters used to initialize and customize the Transak widget.
  TransakConfigParams({
    required this.apiKey,
    required this.exchangeScreenTitle,
    required this.productsAvailed,
    required this.defaultFiatCurrency,
    required this.countryCode,
    required this.excludeFiatCurrencies,
    required this.defaultNetwork,
    required this.defaultPaymentMethod,
    required this.paymentMethod,
    required this.disablePaymentMethods,
    required this.defaultCryptoCurrency,
    required this.cryptoCurrencyList,
    required this.isFeeCalculationHidden,
    required this.hideExchangeScreen,
    required this.disableWalletAddressForm,
    required this.isAutoFillUserData,
    required this.themeColor,
    required this.hideMenu,
    required this.redirectURL,
    required this.walletRedirection,
    required this.networks,
    required this.defaultFiatAmount,
  });

  /// Converts the configuration parameters to a map for serialization.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'apiKey': apiKey,
      'exchangeScreenTitle': exchangeScreenTitle,
      'productsAvailed': productsAvailed,
      'defaultFiatCurrency': defaultFiatCurrency,
      'countryCode': countryCode,
      'excludeFiatCurrencies': excludeFiatCurrencies,
      'defaultNetwork': defaultNetwork,
      'defaultPaymentMethod': defaultPaymentMethod,
      'paymentMethod': paymentMethod,
      'disablePaymentMethods': disablePaymentMethods,
      'defaultCryptoCurrency': defaultCryptoCurrency,
      'cryptoCurrencyList': cryptoCurrencyList,
      'isFeeCalculationHidden': isFeeCalculationHidden,
      'hideExchangeScreen': hideExchangeScreen,
      'disableWalletAddressForm': disableWalletAddressForm,
      'isAutoFillUserData': isAutoFillUserData,
      'themeColor': themeColor,
      'hideMenu': hideMenu,
      'redirectURL': redirectURL,
      'walletRedirection': walletRedirection,
      'networks': networks,
      'defaultFiatAmount': defaultFiatAmount,
    };
  }

  /// Creates a configuration instance from a map.
  factory TransakConfigParams.fromMap(Map<String, dynamic> map) {
    return TransakConfigParams(
      apiKey: map['apiKey'] as String,
      exchangeScreenTitle: map['exchangeScreenTitle'] as String,
      productsAvailed: map['productsAvailed'] as String,
      defaultFiatCurrency: map['defaultFiatCurrency'] as String,
      countryCode: map['countryCode'] as String,
      excludeFiatCurrencies: map['excludeFiatCurrencies'] as String,
      defaultNetwork: map['defaultNetwork'] as String,
      defaultPaymentMethod: map['defaultPaymentMethod'] as String,
      paymentMethod: map['paymentMethod'] as String,
      disablePaymentMethods: map['disablePaymentMethods'] as String,
      defaultCryptoCurrency: map['defaultCryptoCurrency'] as String,
      cryptoCurrencyList: map['cryptoCurrencyList'] as String,
      isFeeCalculationHidden: map['isFeeCalculationHidden'] as bool,
      hideExchangeScreen: map['hideExchangeScreen'] as bool,
      disableWalletAddressForm: map['disableWalletAddressForm'] as bool,
      isAutoFillUserData: map['isAutoFillUserData'] as bool,
      themeColor: map['themeColor'] as String,
      hideMenu: map['hideMenu'] as bool,
      redirectURL: map['redirectURL'] as String,
      walletRedirection: map['walletRedirection'] as bool,
      networks: map['networks'] as String,
      defaultFiatAmount: map['defaultFiatAmount'] as int,
    );
  }

  /// Converts the configuration instance to JSON.
  String toJson() => json.encode(toMap());

  /// Creates a configuration instance from JSON.
  factory TransakConfigParams.fromJson(String source) =>
      TransakConfigParams.fromMap(json.decode(source) as Map<String, dynamic>);
}
