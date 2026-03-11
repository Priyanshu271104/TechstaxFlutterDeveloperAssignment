import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/theme.dart';
import 'auth/login_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://pztigojokdvbzjgicadv.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB6dGlnb2pva2R2YnpqZ2ljYWR2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMyNDIyNDUsImV4cCI6MjA4ODgxODI0NX0.zN_yHhIl_RktjKLhuQiiECWJxU0ZtUH_SHyhm85r3C8',
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = Supabase.instance.client.auth.currentUser;
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: user == null ? const LoginScreen() : DashboardScreen(),
    );
  }
}