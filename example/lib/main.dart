import 'dart:async';
import 'dart:developer';

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
        iosModalTitle: "",
        environment: TransakEnvironment.production,
        apiKey: "44c8b47e-613e-47dc-899f-419c567c4438",
        redirectURL: "https://ecomoto.io/");
    super.initState();
  }

  @override
  void dispose() {
    print("disposed");
    _transakPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Center(
              child: TextButton(
                  onPressed: () async {
                    try {
                      _transakPlugin.transactionEvents.listen((event) {
                        log(event["eventName"], name: "pusherEvents");
                      });
                      final StreamController<TransakEvent> transaction =
                          StreamController();
                      await _transakPlugin.initiateTransactionWithStream(
                          TransactionParams.forBuy(
                              fiatAmount: 32.50,
                              email: "oyenbrihight@gmail.com",
                              walletAddress:
                                  "0x9ABbDFE98A3f89c493831E1c8f3146378CF49f7E",
                              fiatCurrency: "USD",
                              cryptoCurrencyCode: "ETH"),
                          streamController: transaction);

                      transaction.stream.listen((event) {
                        log(event.eventName, name: "transactionEventStream");
                      });
                    } on TransakException catch (e) {
                      print(e.errorMessage);
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  child: const Text("test transact")),
            ),
            Center(
              child: TextButton(
                  onPressed: () async {
                    try {
                      final StreamController<TransakEvent> transaction =
                          StreamController();
                      await _transakPlugin.initiateTransactionWithStream(
                          TransactionParams.forSell(
                              cryptoAmount: 0,
                              defaultCryptoAmount: 10,
                              email: "oyenbrihight@gmail.com",
                              network: "polygon",
                              fiatCurrency: "USD",
                              cryptoCurrencyCode: "ETH"),
                          streamController: transaction);

                      transaction.stream.listen((event) {
                        log(event.eventName, name: "transactionEventStream");
                      });
                    } on TransakException catch (e) {
                      print(e.errorMessage);
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  child: const Text("test transact")),
            ),
          ],
        ),
      ),
    );
  }
}
