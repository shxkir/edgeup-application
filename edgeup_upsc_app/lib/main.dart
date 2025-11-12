import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:edgeup_upsc_app/core/utils/app_theme.dart';
import 'package:edgeup_upsc_app/core/utils/theme_manager.dart';
import 'package:edgeup_upsc_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:edgeup_upsc_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:edgeup_upsc_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:edgeup_upsc_app/features/auth/presentation/pages/login_page.dart';
import 'package:edgeup_upsc_app/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:edgeup_upsc_app/firebase_options.dart';
import 'package:edgeup_upsc_app/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase - DISABLED FOR UI TESTING
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // Initialize dependency injection - DISABLED FOR UI TESTING
  // await di.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return MaterialApp(
          title: 'EdgeUp UPSC',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeManager.themeMode,
          // Direct to LoginPage for UI testing (no auth)
          home: const LoginPage(),
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is AuthAuthenticated) {
          return const DashboardPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
