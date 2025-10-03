// Serviço de autenticação usando navegador do sistema (OAuth) + backend de exchange seguro.
// Fluxo:
// 1) Abrir URL de autorização do Bitrix24 no navegador.
// 2) Receber deep link (uni_links) com "code".
// 3) Enviar "code" ao backend (HTTPS) para trocar por access_token/refresh_token.
// 4) Armazenar tokens com flutter_secure_storage.

import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../../core/config.dart';
import '../../core/constants.dart';
import '../../core/errors.dart';
import '../../core/logger.dart';

class AuthResult {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final String portalDomain;

  AuthResult({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.portalDomain,
  });
}

class AuthService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Inicia o fluxo de login OAuth do Bitrix24.
  Future<AuthResult> signIn({
    required String clientId,
    required String redirectUri,
    required String portalDomain,
  }) async {
    try {
      final authUrl = Uri.https(portalDomain, '/oauth/authorize', {
        'client_id': clientId,
        'response_type': 'code',
        'redirect_uri': redirectUri,
      });

      // Ouvir retorno de deep link
      final completer = Completer<AuthResult>();
      late final StreamSubscription sub;

      sub = uriLinkStream.listen((Uri? uri) async {
        if (uri == null) return;
        if (uri.toString().startsWith(redirectUri) && uri.queryParameters['code'] != null) {
          final code = uri.queryParameters['code']!;
          sub.cancel();

          // Trocar code por tokens via backend seguro
          final exchangeUrl = Uri.parse('${AppConfig.backendBaseUrl}/oauth/exchange');
          final resp = await http.post(
            exchangeUrl,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'code': code,
              'redirectUri': redirectUri,
              'portalDomain': portalDomain,
            }),
          );

          if (resp.statusCode != 200) {
            throw AuthError('Falha ao trocar código por token: ${resp.body}');
          }

          final data = jsonDecode(resp.body) as Map<String, dynamic>;
          final accessToken = data['access_token'] as String;
          final refreshToken = data['refresh_token'] as String;
          final userId = data['user_id'].toString();

          // Persistir seguro
          await _secureStorage.write(key: kSecureAccessToken, value: accessToken);
          await _secureStorage.write(key: kSecureRefreshToken, value: refreshToken);
          await _secureStorage.write(key: kSecureUserId, value: userId);
          await _secureStorage.write(key: kSecurePortal, value: portalDomain);

          completer.complete(AuthResult(
            accessToken: accessToken,
            refreshToken: refreshToken,
            userId: userId,
            portalDomain: portalDomain,
          ));
        }
      }, onError: (e, st) {
        completer.completeError(AuthError('Erro no listener de deep link', cause: e, stackTrace: st));
      });

      // Abrir navegador
      if (!await launchUrl(authUrl, mode: LaunchMode.externalApplication)) {
        sub.cancel();
        throw AuthError('Não foi possível abrir o navegador para autenticação');
      }

      return await completer.future.timeout(const Duration(minutes: 5));
    } catch (e, st) {
      logE('Erro no signIn', e as Object?, st);
      throw AuthError('Falha na autenticação', cause: e, stackTrace: st);
    }
  }

  Future<void> signOut() async {
    await _secureStorage.deleteAll();
  }

  Future<String?> getAccessToken() => _secureStorage.read(key: kSecureAccessToken);
  Future<String?> getRefreshToken() => _secureStorage.read(key: kSecureRefreshToken);
  Future<String?> getPortal() => _secureStorage.read(key: kSecurePortal);
  Future<String?> getUserId() => _secureStorage.read(key: kSecureUserId);
}