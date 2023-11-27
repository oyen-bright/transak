import 'package:flutter/material.dart';
import 'package:transak/transak.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _transakPlugin = Transak();

  @override
  void initState() {
    _transakPlugin.config(
        environment: TransakEnvironment.test,
        productsAvailed: "BUY",
        apiKey: "44c8b47e-613e-47dc-899f-419c567c4438",
        redirectURL: "https://ecomoto.io/");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: TextButton(
              onPressed: () async {
                try {
                  final response = await _transakPlugin.initiateTransaction(
                      payload: TransactionParams.forBuy(
                          fiatAmount: 31.50,
                          email: "oyenbrihight@gmail.com",
                          walletAddress:
                              "0x9ABbDFE98A3f89c493831E1c8f3146378CF49f7E",
                          fiatCurrency: "USD",
                          cryptoCurrencyCode: "ETH"));
                  print("HERE IS THE RESPONSE AND PARAMETERS");
                  print(response);
                  print("HERE IS THE RESPONSE AND PARAMETERS");
                } catch (e) {
                  print(e.toString());
                }
              },
              child: const Text("test transact")),
        ),
      ),
    );
  }
}
