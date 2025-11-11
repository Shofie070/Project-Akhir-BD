class RentalDetailModel {
  final int? id;
  final int rentalId;
  final int consoleId;
  final int hours;

  RentalDetailModel({
    this.id,
    required this.rentalId,
    required this.consoleId,
    required this.hours,
  });

  factory RentalDetailModel.fromMap(Map<String, dynamic> m) =>
      RentalDetailModel(
        id: m['id'] as int?,
        rentalId: m['rental_id'] as int? ?? 0,
        consoleId: m['console_id'] as int? ?? 0,
        hours: m['hours'] as int? ?? 0,
      );

  Map<String, dynamic> toMap() => {
    'id': id,
    'rental_id': rentalId,
    'console_id': consoleId,
    'hours': hours,
  };
}
