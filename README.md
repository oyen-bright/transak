# Transak Flutter Plugin



The Transak Flutter Plugin allows developers to integrate Transak's on-ramp and off-ramp functionality seamlessly into their Flutter applications.

## Installation

To use this plugin, add `transak` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  transak: ^1.0.0
  ````

## Getting Started
1. Import the Transak plugin in your Dart code:

```dart
import 'package:transak/transak.dart';

  ````

2. Configure the Transak plugin with your API key and other necessary parameters:

```dart
import 'package:transak/transak.dart';
final transakPlugin = Transak();

// Configure Transak with your API key and other settings
transakPlugin.config(
  apiKey: 'YOUR_API_KEY',
  environment: TransakEnvironment.production,
  // Add other configuration parameters as needed
).init();
  ````

3. Initiate a transaction to buy or sell crypto:
#### Buy Crypto

```dart
try {
  // Initiate a transaction to buy crypto
  final response = await transakPlugin.initiateTransaction(
    payload: TransactionParams.forBuy(
      fiatAmount: 32.50,
      email: 'example@email.com',
      walletAddress: '0xYourWalletAddress',
      fiatCurrency: 'USD',
      cryptoCurrencyCode: 'ETH',
    ),
  );

  // Handle the response as needed
} on TransakException catch (e) {
  print('Transak Error: ${e.errorMessage}');
} catch (e) {
  print('Unexpected error: $e');
}
```

#### Sell Crypto

```dart
try {
  // Initiate a transaction to sell crypto
  final response = await transakPlugin.initiateTransaction(
    payload: TransactionParams.forSell(
      cryptoAmount: 0, // Set to the amount of crypto to sell
      defaultCryptoAmount: 10, // Set a default crypto amount
      email: 'example@email.com',
      network: 'polygon', // Set the blockchain network
      fiatCurrency: 'USD',
      cryptoCurrencyCode: 'ETH',
    ),
  );

  // Handle the response as needed
} on TransakException catch (e) {
  print('Transak Error: ${e.errorMessage}');
} catch (e) {
  print('Unexpected error: $e');
}
```

## Features
* Buy Crypto: Enable users to buy crypto from fiat currencies.
* Sell Crypto: Allow users to sell crypto and receive fiat.
* Customizable: Highly customizable SDKs for all major platforms and languages.
* Event Handling: Stream transaction events for real-time updates.