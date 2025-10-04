// Copyright (c) Maximo Tecnologia 2025
// Serviço aprimorado de refresh automático de tokens

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/config.dart';
import '../core/constants.dart';
import '../core/errors.dart';
import '../core/logger.dart';

class TokenRefreshService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  Timer? _refreshTimer;

  /// Inicia o refresh automático de tokens
  /// Baseado no expires_in do token (renovação antes da expiração)
  Future<void> startAutoRefresh({required int expiresIn}) async {
    // Renova 5 minutos antes de expirar
    final refreshInterval = Duration(seconds: expiresIn - 300);
    
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(refreshInterval, (timer) async {
      try {
        await refreshToken();
      } catch (e) {
        logE('Erro no auto-refresh de token', e as Object?);
        timer.cancel();
      }
    });
  }

  /// Para o refresh automático
  void stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  /// Faz refresh manual do token
  Future<void> refreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(key: kSecureRefreshToken);
      final portalDomain = await _secureStorage.read(key: kSecurePortal);

      if (refreshToken == null || portalDomain == null) {
        throw AuthError('Sem refresh token ou portal configurado');
      }

      final refreshUrl = Uri.parse('${AppConfig.backendBaseUrl}/oauth/refresh');
      final resp = await http.post(
        refreshUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'refreshToken': refreshToken,
          'portalDomain': portalDomain,
        }),
      );

      if (resp.statusCode != 200) {
        throw AuthError('Falha ao renovar token: ${resp.body}');
      }

      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      final newAccessToken = data['access_token'] as String;
      final newRefreshToken = data['refresh_token'] as String;
      final expiresIn = data['expires_in'] as int?;

      // Atualizar tokens no storage
      await _secureStorage.write(key: kSecureAccessToken, value: newAccessToken);
      await _secureStorage.write(key: kSecureRefreshToken, value: newRefreshToken);

      logI('Token renovado com sucesso');

      // Reiniciar auto-refresh se tiver expires_in
      if (expiresIn != null) {
        await startAutoRefresh(expiresIn: expiresIn);
      }
    } catch (e, st) {
      logE('Erro ao renovar token', e as Object?, st);
      rethrow;
    }
  }

  void dispose() {
    stopAutoRefresh();
  }
}
