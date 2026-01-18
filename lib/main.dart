
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_page.dart';
import 'screens/dashboard_page.dart';
import 'services/session_service.dart';
import 'services/auth_service.dart';
import 'theme/app_theme.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase (ensure platform-specific config files are present)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // If Firebase isn't configured yet (e.g. no google-services files), we continue.
    // The developer should run `flutterfire configure` and add platform files.
    // ignore: avoid_print
    print('Firebase initialization warning: $e');
  }

  await initializeDateFormatting('id_ID', null);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payroll App',
      theme: AppTheme.lightTheme,
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
    // Check if user has active session AND 'remember me' preference
    final user = await SessionService.getUserSession();
    final rememberMe = await SessionService.getRememberMe();
    if (user != null && rememberMe) {
      return DashboardPage(user: user);
    }
    // If user is signed in but didn't choose remember-me, sign out to end session
    if (user != null && !rememberMe) {
      await AuthService.logoutUser();
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
