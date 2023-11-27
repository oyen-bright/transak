import '../../transak.dart';
import '../core/transak_config.dart';

({
  String url,
  String redirectURL,
}) urlBuilder(String endpoint, TransactionParams transactionPayload,
    TransakConfigParams sessionConfig) {
  final redirectURL = sessionConfig.redirectURL;
  final payload = {...sessionConfig.toMap(), ...transactionPayload.toMap()}
    ..removeWhere((key, value) => value == null)
    ..updateAll((key, value) => value.toString());

  final url = Uri.https(endpoint, '', payload);

  return (url: url.toString(), redirectURL: redirectURL);
}
