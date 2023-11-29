import 'dart:convert';

import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:transak/transak.dart';

import './transak_enum.dart';

class TransakEvent {
  TransactionEventName? transactionEventName;
  String eventName;
  Map? data;
  TransakEvent({
    required this.eventName,
    required this.transactionEventName,
    this.data,
  });

  @override
  String toString() =>
      '{eventName: $eventName, data: $data, transactionEventName: $transactionEventName}';

  factory TransakEvent.fromMap(Map eventData) {
    final transactionEventName =
        eventData['eventName'].toString().toTransakEvent;
    return TransakEvent(
        transactionEventName: transactionEventName,
        data: eventData["data"],
        eventName: eventData["eventName"]);
  }

  factory TransakEvent.fromPusherEvent(PusherEvent eventData) {
    final transactionEventName = eventData.eventName.toTransakEvent;

    return TransakEvent(
        transactionEventName: transactionEventName,
        data: Map.from(jsonDecode(eventData.data)),
        eventName: eventData.eventName);
  }
}

extension on String {
  TransactionEventName? get toTransakEvent =>
      TransactionEventName.fromString(this);
}
