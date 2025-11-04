class RentalModel {
  final int? id;
  final int customerId;
  final double total;
  final String status; // e.g., pending, active, completed

  RentalModel({this.id, required this.customerId, required this.total, this.status = 'pending'});

  factory RentalModel.fromMap(Map<String, dynamic> m) => RentalModel(
        id: m['id'] as int?,
        customerId: m['customer_id'] as int? ?? 0,
        total: (m['total'] as num?)?.toDouble() ?? 0.0,
        status: m['status'] as String? ?? 'pending',
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'customer_id': customerId,
        'total': total,
        'status': status,
      };
}
