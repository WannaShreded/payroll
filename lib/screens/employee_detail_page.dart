import 'package:flutter/material.dart';
import '../models/employee_model.dart';
import '../models/position_model.dart';
import '../utils/constants.dart';
import '../services/employee_service.dart';
import 'employee_form_page.dart';

class EmployeeDetailPage extends StatefulWidget {
  final EmployeeModel employee;

  const EmployeeDetailPage({super.key, required this.employee});

  @override
  State<EmployeeDetailPage> createState() => _EmployeeDetailPageState();
}

class _EmployeeDetailPageState extends State<EmployeeDetailPage> {
  late EmployeeModel _employee;

  @override
  void initState() {
    super.initState();
    _employee = widget.employee;
  }

  void _editEmployee() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => EmployeeFormPage(employee: _employee)),
    );

    if (result == true) {
      // Reload employee data
      final updatedEmployee = await EmployeeService.getEmployeeById(
        _employee.id,
      );
      if (updatedEmployee != null && mounted) {
        setState(() {
          _employee = updatedEmployee;
        });
      }
    }
  }

  void _deleteEmployee() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Karyawan'),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${_employee.fullName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await EmployeeService.deleteEmployee(
                _employee.id,
              );
              if (mounted) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Karyawan dihapus'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context, true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gagal menghapus karyawan')),
                  );
                }
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final estimatedSalary = _employee.getEstimatedSalary();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Avatar with initials
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.primaryGradientStart,
                  AppColors.primaryGradientEnd,
                ],
              ),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Center(
              child: Text(
                _employee.getInitials(),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Name and Position
          Text(
            _employee.fullName,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Position and Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryGradientStart.withAlpha(26),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryGradientStart),
                ),
                child: Text(
                  _employee.position,
                  style: const TextStyle(
                    color: AppColors.primaryGradientStart,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(26),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green),
                ),
                child: const Text(
                  'Aktif',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Personal Info
          _buildSection(
            title: 'Informasi Personal',
            children: [
              _buildInfoRow('Email', _employee.email),
              _buildInfoRow('Telepon', _employee.phone),
              _buildInfoRow(
                'Tanggal Bergabung',
                _employee.getFormattedJoinDate(),
              ),
              _buildInfoRow('Alamat', _employee.address),
            ],
          ),
          const SizedBox(height: 24),
          // Salary Info
          _buildSection(
            title: 'Informasi Gaji',
            children: [
              _buildInfoRow(
                'Upah Per Jam',
                'Rp ${PositionList.formatCurrency(_employee.hourlyRate)}/jam',
              ),
              _buildInfoRow(
                'Jam Kerja Standard',
                '${_employee.standardHoursPerDay} Jam/Hari',
              ),
              _buildInfoRow(
                'Tunjangan Transport',
                'Rp ${PositionList.formatCurrency(_employee.transportAllowance)}',
              ),
              _buildInfoRow(
                'Tunjangan Makan',
                'Rp ${PositionList.formatCurrency(_employee.mealAllowance)}',
              ),
              const Divider(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.success.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Estimasi Gaji Penuh (22 hari)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Rp ${PositionList.formatCurrency(estimatedSalary)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _editEmployee,
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGradientStart,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _deleteEmployee,
                  icon: const Icon(Icons.delete),
                  label: const Text('Hapus'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              // Print action removed per request
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
