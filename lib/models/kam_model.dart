// models/kam_model.dart
class KamModel {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String region;
  final DateTime createdAt;

  KamModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.region,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'region': region,
        'createdAt': createdAt.toIso8601String(),
      };

  factory KamModel.fromJson({required Map<String, dynamic> json}) => KamModel(
        id: json['id']?.toString() ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phoneNumber: json['phoneNumber'] ?? '',
        region: json['region'] ?? '',
        createdAt: DateTime.parse(
          json['createdAt'] ?? DateTime.now().toIso8601String(),
        ),
      );
}
