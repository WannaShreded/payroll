class PayrollModel {
  final String id;
  final String employeeId;
  final int month; // 1-12
  final int year;
  final int baseSalary; // upah per jam × jam kerja
  final int transportAllowance;
  final int mealAllowance;
  final int totalNetSalary;
  final int totalDaysPresent;
  final double totalHoursWorked;
  final int hourlyRate;
  final DateTime createdAt;

  PayrollModel({
    required this.id,
    required this.employeeId,
    required this.month,
    required this.year,
    required this.baseSalary,
    required this.transportAllowance,
    required this.mealAllowance,
    required this.totalNetSalary,
    required this.totalDaysPresent,
    required this.totalHoursWorked,
    required this.hourlyRate,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'month': month,
      'year': year,
      'baseSalary': baseSalary,
      'transportAllowance': transportAllowance,
      'mealAllowance': mealAllowance,
      'totalNetSalary': totalNetSalary,
      'totalDaysPresent': totalDaysPresent,
      'totalHoursWorked': totalHoursWorked,
      'hourlyRate': hourlyRate,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PayrollModel.fromJson(Map<String, dynamic> json) {
    return PayrollModel(
      id: json['id'] ?? '',
      employeeId: json['employeeId'] ?? '',
      month: json['month'] ?? 0,
      year: json['year'] ?? 0,
      baseSalary: json['baseSalary'] ?? 0,
      transportAllowance: json['transportAllowance'] ?? 0,
      mealAllowance: json['mealAllowance'] ?? 0,
      totalNetSalary: json['totalNetSalary'] ?? 0,
      totalDaysPresent: json['totalDaysPresent'] ?? 0,
      totalHoursWorked: (json['totalHoursWorked'] ?? 0).toDouble(),
      hourlyRate: json['hourlyRate'] ?? 0,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
