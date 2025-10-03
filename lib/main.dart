// Copyright (c) Maximo Tecnologia 2025
// Aplicativo: Smart Bitrix24 - Versão: 1.0 Lite
// Ponto de entrada do app Flutter.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialização customizada (DB, storage, etc.) é feita nos providers.
  runApp(const ProviderScope(child: SmartBitrixApp()));
}