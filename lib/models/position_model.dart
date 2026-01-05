class Position {
  final String id;
  final String name;
  final int hourlyRate; // in Rp

  const Position({
    required this.id,
    required this.name,
    required this.hourlyRate,
  });
}

class PositionList {
  static final List<Position> positions = [
    Position(id: '1', name: 'Direktur Utama', hourlyRate: 150000),
    Position(id: '2', name: 'Direktur', hourlyRate: 125000),
    Position(id: '3', name: 'General Manager', hourlyRate: 100000),
    Position(id: '4', name: 'Manager', hourlyRate: 80000),
    Position(id: '5', name: 'Supervisor', hourlyRate: 60000),
    Position(id: '6', name: 'Staff Senior', hourlyRate: 45000),
    Position(id: '7', name: 'Staff', hourlyRate: 35000),
    Position(id: '8', name: 'Staff Junior', hourlyRate: 25000),
    Position(id: '9', name: 'Operator', hourlyRate: 20000),
    Position(id: '10', name: 'Magang', hourlyRate: 15000),
  ];

  static Position? getPositionById(String id) {
    try {
      return positions.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  static Position? getPositionByName(String name) {
    try {
      return positions.firstWhere((p) => p.name == name);
    } catch (e) {
      return null;
    }
  }

  static String formatCurrency(int amount) {
    final formatter = RegExp(r'(\d)(?=(\d{3})+(?!\d))');
    String numStr = amount.toString();
    return numStr.replaceAllMapped(formatter, (Match m) => '${m[1]}.');
  }
}
