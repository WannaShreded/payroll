import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

class PayrollPage extends StatefulWidget {
  final UserModel user;

  const PayrollPage({super.key, required this.user});

  @override
  State<PayrollPage> createState() => _PayrollPageState();
}

class _PayrollPageState extends State<PayrollPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penggajian'),
        backgroundColor: AppColors.primaryGradientStart,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryGradientStart,
              AppColors.primaryGradientEnd,
            ],
          ),
        ),
        child: const Center(
          child: Text(
            'Penggajian - Coming Soon',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
