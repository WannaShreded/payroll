import 'package:intl/intl.dart';

class EmployeeModel {
  final String id;
  final String fullName;
  final String position;
  final String email;
  final String phone;
  final String address;
  final DateTime joinDate;
  final int hourlyRate;
  final int standardHoursPerDay;
  final int transportAllowance;
  final int mealAllowance;
  final String? nik;

  EmployeeModel({
    required this.id,
    required this.fullName,
    required this.position,
    required this.email,
    required this.phone,
    required this.address,
    required this.joinDate,
    required this.hourlyRate,
    this.standardHoursPerDay = 8,
    this.transportAllowance = 0,
    this.mealAllowance = 0,
    this.nik,
  });

  // Calculate estimated salary (22 working days)
  int getEstimatedSalary({int workingDays = 22}) {
    return (hourlyRate * standardHoursPerDay * workingDays) +
        transportAllowance +
        mealAllowance;
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'position': position,
      'email': email,
      'phone': phone,
      'address': address,
      'joinDate': joinDate.toIso8601String(),
      'hourlyRate': hourlyRate,
      'standardHoursPerDay': standardHoursPerDay,
      'transportAllowance': transportAllowance,
      'mealAllowance': mealAllowance,
      'nik': nik,
    };
  }

  // Create from JSON
  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      position: json['position'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      joinDate: DateTime.parse(
        json['joinDate'] ?? DateTime.now().toIso8601String(),
      ),
      hourlyRate: json['hourlyRate'] ?? 0,
      standardHoursPerDay: json['standardHoursPerDay'] ?? 8,
      transportAllowance: json['transportAllowance'] ?? 0,
      mealAllowance: json['mealAllowance'] ?? 0,
      nik: json['nik'],
    );
  }

  // Copy with method for updates
  EmployeeModel copyWith({
    String? id,
    String? fullName,
    String? position,
    String? email,
    String? phone,
    String? address,
    DateTime? joinDate,
    int? hourlyRate,
    int? standardHoursPerDay,
    int? transportAllowance,
    int? mealAllowance,
    String? nik,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      position: position ?? this.position,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      joinDate: joinDate ?? this.joinDate,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      standardHoursPerDay: standardHoursPerDay ?? this.standardHoursPerDay,
      transportAllowance: transportAllowance ?? this.transportAllowance,
      mealAllowance: mealAllowance ?? this.mealAllowance,
      nik: nik ?? this.nik,
    );
  }

  String getInitials() {
    final names = fullName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return fullName[0].toUpperCase();
  }

  String getFormattedJoinDate() {
    return DateFormat('dd MMM yyyy', 'id_ID').format(joinDate);
  }
}
