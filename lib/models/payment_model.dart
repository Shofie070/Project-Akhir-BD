class PaymentModel {
  final int? id;
  final int rentalId;
  final double amount;
  final String method; // e.g., cash, transfer

  PaymentModel({this.id, required this.rentalId, required this.amount, this.method = 'cash'});

  factory PaymentModel.fromMap(Map<String, dynamic> m) => PaymentModel(
        id: m['id'] as int?,
        rentalId: m['rental_id'] as int? ?? 0,
        amount: (m['amount'] as num?)?.toDouble() ?? 0.0,
        method: m['method'] as String? ?? 'cash',
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'rental_id': rentalId,
        'amount': amount,
        'method': method,
      };
}
