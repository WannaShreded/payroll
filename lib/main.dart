import 'package:flutter/material.dart';
import 'screens/register_page.dart';
import 'screens/login_page.dart';
import 'screens/dashboard_page.dart';
import 'services/session_service.dart';
import 'models/user_model.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payroll App',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.purple,
      ),
      home: const InitialRoutePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class InitialRoutePage extends StatefulWidget {
  const InitialRoutePage({super.key});

  @override
  State<InitialRoutePage> createState() => _InitialRoutePageState();
}

class _InitialRoutePageState extends State<InitialRoutePage> {
  late Future<Widget> _initialRoute;

  @override
  void initState() {
    super.initState();
    _initialRoute = _determineInitialRoute();
  }

  Future<Widget> _determineInitialRoute() async {
    // Check if user has active session
    final user = await SessionService.getUserSession();
    if (user != null) {
      return DashboardPage(user: user);
    }
    return const LoginPage();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _initialRoute,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return snapshot.data ?? const LoginPage();
      },
    );
  }
}
