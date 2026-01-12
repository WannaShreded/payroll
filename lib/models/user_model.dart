import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedCreatedAt = DateTime.now();
    final created = json['createdAt'];
    if (created != null) {
      try {
        if (created is String) {
          parsedCreatedAt = DateTime.parse(created);
        } else if (created is Timestamp) {
          parsedCreatedAt = created.toDate();
        } else if (created is int) {
          parsedCreatedAt = DateTime.fromMillisecondsSinceEpoch(created);
        }
      } catch (_) {
        parsedCreatedAt = DateTime.now();
      }
    }

    return UserModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      createdAt: parsedCreatedAt,
    );
  }

  // Copy with method for updates
  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? role,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Get user initials
  String getInitials() {
    return fullName
        .split(' ')
        .take(2)
        .map((word) => word[0].toUpperCase())
        .join();
  }
}
