import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';
import '../screens/dashboard_page.dart';
import '../screens/employee_page.dart';
import '../screens/payroll_page.dart';
import '../screens/profile_page.dart';

class AppShell extends StatelessWidget {
  final int currentIndex;
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final UserModel user;

  const AppShell({
    Key? key,
    required this.currentIndex,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    required this.user,
  }) : super(key: key);

  void _onNavTap(BuildContext context, int index) {
    if (index == currentIndex) return;
    Widget target;
    switch (index) {
      case 0:
        target = DashboardPage(user: user);
        break;
      case 1:
        target = EmployeePage(user: user);
        break;
      case 2:
        target = PayrollPage(user: user);
        break;
      case 3:
      default:
        target = ProfilePage(user: user);
        break;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => target),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => _onNavTap(context, i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primaryGradientStart,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: AppText.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: AppText.employees,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            activeIcon: Icon(Icons.attach_money),
            label: AppText.salary,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: AppText.profile,
          ),
        ],
      ),
    );
  }
}
