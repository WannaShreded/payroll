class AttendanceModel {
  final String id;
  final String employeeId;
  final int day; // 1-31
  final int month; // 1-12
  final int year;
  final double hoursWorked; // actual hours worked
  final bool isPresent;
  final String? notes;

  AttendanceModel({
    required this.id,
    required this.employeeId,
    required this.day,
    required this.month,
    required this.year,
    required this.hoursWorked,
    required this.isPresent,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'day': day,
      'month': month,
      'year': year,
      'hoursWorked': hoursWorked,
      'isPresent': isPresent,
      'notes': notes,
    };
  }

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] ?? '',
      employeeId: json['employeeId'] ?? '',
      day: json['day'] ?? 0,
      month: json['month'] ?? 0,
      year: json['year'] ?? 0,
      hoursWorked: (json['hoursWorked'] ?? 0).toDouble(),
      isPresent: json['isPresent'] ?? false,
      notes: json['notes'],
    );
  }
}

class AttendanceSummary {
  final int totalDaysPresent;
  final double totalHoursWorked;

  AttendanceSummary({
    required this.totalDaysPresent,
    required this.totalHoursWorked,
  });
}
