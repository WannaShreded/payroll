import 'package:flutter/material.dart';
import '../models/employee_model.dart';
import '../models/position_model.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../services/employee_service.dart';

class EmployeeFormPage extends StatefulWidget {
  final EmployeeModel? employee;

  const EmployeeFormPage({super.key, this.employee});

  @override
  State<EmployeeFormPage> createState() => _EmployeeFormPageState();
}

class _EmployeeFormPageState extends State<EmployeeFormPage> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _transportController;
  late TextEditingController _mealController;

  String? _selectedPosition;
  DateTime? _selectedJoinDate;
  int _standardHours = 8;
  int _hourlyRate = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _nameController = TextEditingController(text: widget.employee?.fullName ?? '');
    _emailController = TextEditingController(text: widget.employee?.email ?? '');
    _phoneController = TextEditingController(text: widget.employee?.phone ?? '');
    _addressController = TextEditingController(text: widget.employee?.address ?? '');
    _transportController = TextEditingController(text: widget.employee?.transportAllowance.toString() ?? '0');
    _mealController = TextEditingController(text: widget.employee?.mealAllowance.toString() ?? '0');
    _selectedJoinDate = widget.employee?.joinDate ?? DateTime.now();
    _standardHours = widget.employee?.standardHoursPerDay ?? 8;
    _hourlyRate = widget.employee?.hourlyRate ?? 0;
    
    if (widget.employee != null) {
      _selectedPosition = widget.employee!.position;
      _hourlyRate = widget.employee!.hourlyRate;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _transportController.dispose();
    _mealController.dispose();
    super.dispose();
  }

  void _selectJoinDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedJoinDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedJoinDate = picked;
      });
    }
  }

  void _saveEmployee() async {
    if (_formKey.currentState!.validate() && _selectedPosition != null && _selectedJoinDate != null) {
      setState(() {
        _isLoading = true;
      });

      final position = PositionList.getPositionByName(_selectedPosition!);
      if (position == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih jabatan yang valid')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final employee = EmployeeModel(
        id: widget.employee?.id ?? EmployeeService.generateId(),
        fullName: _nameController.text.trim(),
        position: _selectedPosition!,
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        joinDate: _selectedJoinDate!,
        hourlyRate: position.hourlyRate,
        standardHoursPerDay: _standardHours,
        transportAllowance: int.tryParse(_transportController.text) ?? 0,
        mealAllowance: int.tryParse(_mealController.text) ?? 0,
      );

      bool success;
      if (widget.employee != null) {
        success = await EmployeeService.updateEmployee(employee);
      } else {
        success = await EmployeeService.addEmployee(employee);
      }

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.employee != null ? 'Karyawan diperbarui' : 'Karyawan ditambahkan'),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.of(context).pop(true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menyimpan karyawan')),
          );
        }
      }
    } else {
      if (_selectedPosition == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih jabatan')),
        );
      }
      if (_selectedJoinDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih tanggal bergabung')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.employee != null ? 'Edit Karyawan' : 'Tambah Karyawan'),
        backgroundColor: AppColors.primaryGradientStart,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: Validators.validateFullName,
              ),
              const SizedBox(height: 16),
              // Position
              DropdownButtonFormField<String>(
                value: _selectedPosition,
                decoration: InputDecoration(
                  labelText: 'Jabatan',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.work),
                ),
                items: PositionList.positions.map((position) {
                  return DropdownMenuItem(
                    value: position.name,
                    child: Text(position.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPosition = value;
                    if (value != null) {
                      final pos = PositionList.getPositionByName(value);
                      _hourlyRate = pos?.hourlyRate ?? 0;
                    }
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih jabatan';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              // Hourly Rate Display
              if (_hourlyRate > 0)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGradientStart.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primaryGradientStart),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Upah Per Jam:'),
                      Text(
                        'Rp ${PositionList.formatCurrency(_hourlyRate)}/jam',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGradientStart,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              // Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.email),
                ),
                validator: (value) {
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (value == null || value.isEmpty) return 'Email tidak boleh kosong';
                  if (!emailRegex.hasMatch(value)) return 'Format email tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Phone
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'No. Telepon',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.phone),
                ),
                validator: Validators.validatePhone,
              ),
              const SizedBox(height: 16),
              // Address
              TextFormField(
                controller: _addressController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Alamat tidak boleh kosong';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Join Date
              GestureDetector(
                onTap: _selectJoinDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tanggal Bergabung', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          if (_selectedJoinDate != null)
                            Text(
                              '${_selectedJoinDate!.day}/${_selectedJoinDate!.month}/${_selectedJoinDate!.year}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                        ],
                      ),
                      const Icon(Icons.calendar_today, color: AppColors.primaryGradientStart),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Standard Working Hours
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Jam Kerja Standard/Hari'),
                        Text(
                          '$_standardHours Jam',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: _standardHours > 1
                              ? () => setState(() => _standardHours--)
                              : null,
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _standardHours < 12
                              ? () => setState(() => _standardHours++)
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Transport Allowance
              TextFormField(
                controller: _transportController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Tunjangan Transport (Rp)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.directions_car),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Tidak boleh kosong';
                  if (int.tryParse(value) == null) return 'Hanya angka';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Meal Allowance
              TextFormField(
                controller: _mealController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Tunjangan Makan (Rp)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.restaurant),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Tidak boleh kosong';
                  if (int.tryParse(value) == null) return 'Hanya angka';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Info Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue),
                ),
                child: const Text(
                  'Sistem menghitung gaji hanya dari upah per jam × total jam kerja aktual',
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 24),
              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveEmployee,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGradientStart,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Text('Simpan Karyawan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
