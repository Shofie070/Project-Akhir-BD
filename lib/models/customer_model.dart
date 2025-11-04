class CustomerModel {
  final int? id;
  final String name;
  final String phone;
  final String? password;

  CustomerModel({this.id, required this.name, required this.phone, this.password});

  factory CustomerModel.fromMap(Map<String, dynamic> m) => CustomerModel(
        id: m['id'] as int?,
        name: m['name'] as String? ?? '',
        phone: m['phone'] as String? ?? '',
        password: m['password'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'phone': phone,
        'password': password,
      };
}
