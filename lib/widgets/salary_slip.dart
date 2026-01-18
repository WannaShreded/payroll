import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart' as pdf;
import 'package:printing/printing.dart';
import '../models/payroll_model.dart';
import '../models/employee_model.dart';
import '../models/position_model.dart';
import '../utils/constants.dart';

class SalarySlip extends StatelessWidget {
  final PayrollModel payroll;
  final EmployeeModel employee;

  const SalarySlip({
    super.key,
    required this.payroll,
    required this.employee,
  });

  String _getMonthName(int month) {
    const monthNames = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return monthNames[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final monthName = _getMonthName(payroll.month);
    final period = '$monthName ${payroll.year}';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.primaryGradientStart,
                  AppColors.primaryGradientEnd,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'SLIP GAJI',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Periode: $period',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white70,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Employee Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informasi Karyawan',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                _buildInfoRow('Nama', employee.fullName),
                _buildInfoRow('NIK', employee.nik ?? '-'),
                _buildInfoRow('Jabatan', employee.position),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Attendance Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ringkasan Kehadiran Bulan Ini',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  'Total Hari Hadir',
                  '${payroll.totalDaysPresent} Hari',
                ),
                _buildInfoRow(
                  'Total Jam Kerja Aktual',
                  '${payroll.totalHoursWorked.toStringAsFixed(1)} Jam',
                ),
                _buildInfoRow(
                  'Upah Per Jam',
                  'Rp ${PositionList.formatCurrency(payroll.hourlyRate)}/jam',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Salary Breakdown
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Breakdown Gaji',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                _buildSalaryRow(
                  'Gaji (Upah × Jam Kerja)',
                  'Rp ${PositionList.formatCurrency(payroll.baseSalary)}',
                ),
                const Divider(height: 16),
                _buildSalaryRow(
                  'Tunjangan Transport',
                  'Rp ${PositionList.formatCurrency(payroll.transportAllowance)}',
                ),
                _buildSalaryRow(
                  'Tunjangan Makan',
                  'Rp ${PositionList.formatCurrency(payroll.mealAllowance)}',
                ),
                const Divider(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.success.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Gaji Bersih',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'Rp ${PositionList.formatCurrency(payroll.totalNetSalary)}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.success,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Calculation Info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cara Perhitungan Gaji',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Gaji = Upah Per Jam × Total Jam Kerja Aktual\n'
                  'Total Gaji Bersih = Gaji + Tunjangan Transport + Tunjangan Makan',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.blue[900],
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Action Button: Unduh PDF (share)
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final doc = pw.Document();

                    doc.addPage(
                      pw.MultiPage(
                        build: (context) => [
                          pw.Container(
                            padding: const pw.EdgeInsets.all(12),
                            color: pdf.PdfColors.blue800,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text('SLIP GAJI',
                                    style: pw.TextStyle(
                                      color: pdf.PdfColors.white,
                                      fontSize: 20,
                                      fontWeight: pw.FontWeight.bold,
                                    )),
                                pw.SizedBox(height: 6),
                                pw.Text('Periode: $period',
                                    style: pw.TextStyle(
                                      color: pdf.PdfColors.white,
                                    )),
                              ],
                            ),
                          ),
                          pw.SizedBox(height: 12),
                          pw.Text('Informasi Karyawan', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(height: 8),
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.Text('Nama'), pw.Text(employee.fullName)
                          ]),
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.Text('NIK'), pw.Text(employee.nik ?? '-')
                          ]),
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.Text('Jabatan'), pw.Text(employee.position)
                          ]),
                          pw.SizedBox(height: 12),
                          pw.Text('Ringkasan Kehadiran Bulan Ini', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(height: 8),
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.Text('Total Hari Hadir'), pw.Text('${payroll.totalDaysPresent} Hari')
                          ]),
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.Text('Total Jam Kerja'), pw.Text('${payroll.totalHoursWorked.toStringAsFixed(1)} Jam')
                          ]),
                          pw.SizedBox(height: 12),
                          pw.Text('Breakdown Gaji', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(height: 8),
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.Text('Gaji (Upah × Jam Kerja)'), pw.Text('Rp ${PositionList.formatCurrency(payroll.baseSalary)}')
                          ]),
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.Text('Tunjangan Transport'), pw.Text('Rp ${PositionList.formatCurrency(payroll.transportAllowance)}')
                          ]),
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.Text('Tunjangan Makan'), pw.Text('Rp ${PositionList.formatCurrency(payroll.mealAllowance)}')
                          ]),
                          pw.SizedBox(height: 12),
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.Text('Total Gaji Bersih', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.Text('Rp ${PositionList.formatCurrency(payroll.totalNetSalary)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                          ]),
                        ],
                      ),
                    );

                    final bytes = await doc.save();
                    final filename = 'slip_gaji_${employee.nik ?? 'unknown'}_${payroll.month}_${payroll.year}.pdf';
                    await Printing.sharePdf(bytes: bytes, filename: filename);
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Unduh PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGradientStart,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryRow(String label, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            amount,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
