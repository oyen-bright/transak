enum TransakEnvironment { test, production }

/// Enum representing various Transak events.
enum TransactionEventName {
  /// Represents an order that is currently being processed.
  orderProcessing('ORDER_PROCESSING'),

  /// Represents an order that failed due to expiration.
  orderFailedExpired('ORDER_FAILED_EXPIRED'),

  /// Represents an order that failed due to a declined card.
  orderFailedCardDeclined('ORDER_FAILED_CARD_DECLINED'),

  /// Represents an order that was cancelled by the user.
  orderFailedUserCancelled('ORDER_FAILED_USER_CANCELLED'),

  /// Represents a completed order.
  orderCompleted('ORDER_COMPLETED'),

  /// Represents an order that is processing and pending delivery from Transak.
  orderProcessingPendingDeliveryFromTransak(
      'ORDER_PROCESSING_PENDING_DELIVERY_FROM_TRANSAK'),

  /// Represents an order where the payment is currently being verified.
  orderPaymentVerifying('ORDER_PAYMENT_VERIFYING'),

  /// Represents an order that has been created.
  orderCreated('ORDER_CREATED');

  /// The string value associated with the enum.
  final String _value;

  /// Private constructor for the enum.
  const TransactionEventName(this._value);

  /// Getter to expose the string value.
  String get value => _value;

  @override
  String toString() => _value;

  static TransactionEventName? fromString(String value) {
    try {
      return TransactionEventName.values.firstWhere(
        (e) => e._value == value,
      );
    } catch (e) {
      return null;
    }
  }
}
