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
