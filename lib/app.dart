// Copyright (c) Maximo Tecnologia 2025
// Smart Bitrix24 - App Material 3 com navegação básica e temas.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/dashboard_screen.dart';
import 'state/providers.dart';

class SmartBitrixApp extends ConsumerWidget {
  const SmartBitrixApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: authState.maybeWhen(
        authenticated: (_) => const DashboardScreen(),
        orElse: () => const LoginScreen(),
      ),
    );
  }
}