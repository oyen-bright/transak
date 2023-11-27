// class TransakConfigurationException implements Exception {
//   final String errorMessage;

//   TransakConfigurationException(this.errorMessage);

//   String get message => "Transak configuration error: $errorMessage";

//   @override
//   String toString() => message;
// }

// class TransakFailureException implements Exception {
//   final String message;

//   TransakFailureException(this.message);

//   @override
//   String toString() => "Transak transaction failure: $message";
// }

// class TransakCancelledException implements Exception {
//   String get message => "Transak transaction canceled by the user";

//   @override
//   String toString() => message;
// }

class TransakException implements Exception {
  final String errorMessage;
  final String? errorCode;
  final dynamic data;

  TransakException(this.errorMessage, {this.errorCode, this.data});

  String get message =>
      "Transak error: $errorMessage\nCode: $errorCode\nData: $data";

  @override
  String toString() => message;
}
