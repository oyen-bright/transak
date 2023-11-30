import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

/// Represents the transaction parameters used to initiate a transaction with the Transak widget.
///
/// The [TransactionParams] class encapsulates parameters that are specific to a transaction and may change
/// with each interaction with the Transak widget. These parameters include details such as the fiat amount, fiat currency,
/// user email, user data, wallet address, and more.
///
/// ## Transaction Parameters:
///
/// - [fiatAmount]: An integer amount representing how much the customer wants to spend/receive in fiat currency.
/// - [fiatCurrency]: The code of the fiat currency you want the customer to buy/sell cryptocurrency.
/// - [email]: The email that will be used to identify your customer and their order.
/// - [userData]: User's data like their name, address, date of birth in the object format.
/// - [walletAddress]: The blockchain address of the user's wallet that the purchased cryptocurrency will be sent to.
/// - [walletAddressesData]: Multiple wallet addresses of different cryptocurrencies & networks in the JSON object format.
/// - [defaultCryptoAmount]: An integer amount representing how much crypto the customer wants to buy/sell.
/// - [cryptoAmount]: An integer amount representing how much crypto the customer wants to sell.
/// - [partnerOrderId]: An order ID that will be used to identify the transaction once a webhook is called back to your app.
/// - [partnerCustomerId]: A customer ID that will be used to identify the customer that made the transaction once a webhook is called back to your app.
/// - [cryptoCurrencyCode]: The code of the cryptocurrency you want the customer to buy/sell.
///
/// ## Usage:
///
/// ```dart
/// TransakTransactionParams transactionParams = TransakTransactionParams(
///   fiatAmount: 1000,
///   fiatCurrency: 'USD',
///   email: 'user@example.com',
///   // ... other transaction parameters
/// );
/// ```
///
/// For more information, refer to the [Transak Documentation](https://docs.transak.com/docs/query-parameters).
class TransactionParams {
  /// The amount in fiat currency for the transaction.
  final double? fiatAmount;

  /// The code of the fiat currency for the transaction.
  final String? fiatCurrency;

  /// The email address of the user, used for identification and order tracking.
  final String? email;

  /// Additional user data in a key-value pair format.
  final Map<String, dynamic>? userData;

  /// The blockchain address where the cryptocurrency will be sent.
  final String? walletAddress;

  /// Multiple wallet addresses for different cryptocurrencies and networks in JSON object format.
  final Map<String, dynamic>? walletAddressesData;

  /// The default amount of cryptocurrency for the transaction.
  final double? defaultCryptoAmount;

  /// The fixed amount of cryptocurrency for selling transactions.
  final double? cryptoAmount;

  /// A unique identifier for the order, used for tracking.
  final String? partnerOrderId;

  /// A unique identifier for the customer, used in transaction callbacks.
  final String? partnerCustomerId;

  /// The code of the cryptocurrency for the transaction.
  final String? cryptoCurrencyCode;

  final String? network;

  final String productsAvailed;

  // Private constructor for buying
  TransactionParams._forBuy({
    required double? fiatAmount,
    required String? fiatCurrency,
    required String? email,
    required String? productsAvailed,
    required Map<String, dynamic>? userData,
    required String? walletAddress,
    required Map<String, dynamic>? walletAddressesData,
    required double? defaultCryptoAmount,
    required String? partnerOrderId,
    required double? cryptoAmount,
    required String? partnerCustomerId,
    required String? cryptoCurrencyCode,
  }) : this(
          fiatAmount: fiatAmount,
          fiatCurrency: fiatCurrency,
          email: email,
          userData: userData,
          productsAvailed: productsAvailed ?? "BUY",
          walletAddress: walletAddress,
          walletAddressesData: walletAddressesData,
          defaultCryptoAmount: defaultCryptoAmount,
          cryptoAmount: cryptoAmount,
          partnerOrderId: partnerOrderId,
          partnerCustomerId: partnerCustomerId,
          cryptoCurrencyCode: cryptoCurrencyCode,
        );

  // Private constructor for selling
  TransactionParams._forSell(
      {required double? fiatAmount,
      required String fiatCurrency,
      required String? email,
      required Map<String, dynamic>? userData,
      required String? walletAddress,
      required String? productsAvailed,
      required Map<String, dynamic>? walletAddressesData,
      required double? cryptoAmount,
      required String? partnerOrderId,
      required String? network,
      required String? partnerCustomerId,
      required String cryptoCurrencyCode,
      required double? defaultCryptoAmount})
      : this(
          fiatAmount: fiatAmount,
          fiatCurrency: fiatCurrency,
          email: email,
          network: network,
          userData: userData,
          productsAvailed: productsAvailed ?? "SELL",
          walletAddress: walletAddress,
          walletAddressesData: walletAddressesData,
          defaultCryptoAmount: defaultCryptoAmount,
          cryptoAmount: cryptoAmount,
          partnerOrderId: partnerOrderId,
          partnerCustomerId: partnerCustomerId,
          cryptoCurrencyCode: cryptoCurrencyCode,
        );

  TransactionParams({
    required this.fiatAmount,
    required this.fiatCurrency,
    this.email,
    this.userData,
    this.productsAvailed = "BUY,SELL",
    required this.walletAddress,
    this.walletAddressesData,
    this.defaultCryptoAmount,
    required this.cryptoAmount,
    this.partnerOrderId,
    this.partnerCustomerId,
    this.network,
    required this.cryptoCurrencyCode,
  });

  // Public factory methods for creating instances
  factory TransactionParams.forBuy({
    double? fiatAmount,
    String? fiatCurrency,
    String? email,
    Map<String, dynamic>? userData,
    required String? walletAddress,
    Map<String, dynamic>? walletAddressesData,
    double? defaultCryptoAmount,
    String? productsAvailed,
    double? cryptoAmount,
    String? partnerOrderId,
    String? partnerCustomerId,
    String? cryptoCurrencyCode,
  }) =>
      TransactionParams._forBuy(
        cryptoAmount: cryptoAmount,
        fiatAmount: fiatAmount,
        fiatCurrency: fiatCurrency,
        email: email,
        productsAvailed: productsAvailed,
        userData: userData,
        walletAddress: walletAddress,
        walletAddressesData: walletAddressesData,
        defaultCryptoAmount: defaultCryptoAmount,
        partnerOrderId: partnerOrderId,
        partnerCustomerId: partnerCustomerId,
        cryptoCurrencyCode: cryptoCurrencyCode,
      );

  factory TransactionParams.forSell({
    double? fiatAmount,
    required String fiatCurrency,
    String? email,
    String? productsAvailed,
    Map<String, dynamic>? userData,
    String? walletAddress,
    Map<String, dynamic>? walletAddressesData,
    required double cryptoAmount,
    String? partnerOrderId,
    String? partnerCustomerId,
    required String? network,
    double? defaultCryptoAmount,
    required String cryptoCurrencyCode,
  }) =>
      TransactionParams._forSell(
        fiatAmount: fiatAmount,
        productsAvailed: productsAvailed,
        fiatCurrency: fiatCurrency,
        email: email,
        network: network,
        userData: userData,
        defaultCryptoAmount: defaultCryptoAmount,
        walletAddress: walletAddress,
        walletAddressesData: walletAddressesData,
        cryptoAmount: cryptoAmount,
        partnerOrderId: partnerOrderId,
        partnerCustomerId: partnerCustomerId,
        cryptoCurrencyCode: cryptoCurrencyCode,
      );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fiatAmount': fiatAmount,
      'fiatCurrency': fiatCurrency,
      'email': email,
      'productsAvailed': productsAvailed,
      'userData': userData,
      'walletAddress': walletAddress,
      'walletAddressesData': walletAddressesData,
      'defaultCryptoAmount': defaultCryptoAmount,
      'cryptoAmount': cryptoAmount,
      'partnerOrderId': partnerOrderId,
      'partnerCustomerId': partnerCustomerId,
      'cryptoCurrencyCode': cryptoCurrencyCode,
      'network': network
    };
  }

  factory TransactionParams.fromMap(Map<String, dynamic> map) {
    return TransactionParams(
      fiatAmount: map['fiatAmount'] as double,
      fiatCurrency: map['fiatCurrency'] as String,
      email: map['email'] as String?,
      network: map['network'] as String?,
      userData: map['userData'] as Map<String, dynamic>?,
      walletAddress: map['walletAddress'] as String,
      walletAddressesData: map['walletAddressesData'] as Map<String, dynamic>?,
      defaultCryptoAmount: map['defaultCryptoAmount'] as double?,
      cryptoAmount: map['cryptoAmount'] as double,
      productsAvailed: map['productsAvailed'] as String,
      partnerOrderId: map['partnerOrderId'] as String?,
      partnerCustomerId: map['partnerCustomerId'] as String?,
      cryptoCurrencyCode: map['cryptoCurrencyCode'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionParams.fromJson(String source) =>
      TransactionParams.fromMap(json.decode(source) as Map<String, dynamic>);
}
