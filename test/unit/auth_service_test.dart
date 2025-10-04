// Copyright (c) Maximo Tecnologia 2025
// Testes unitários para AuthService

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_bitrix24/data/bitrix/auth_service.dart';
import 'package:smart_bitrix24/core/constants.dart';

void main() {
  // Configuração de mock para flutter_secure_storage
  FlutterSecureStorage.setMockInitialValues({});

  group('AuthService', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
      FlutterSecureStorage.setMockInitialValues({});
    });

    test('getAccessToken retorna null quando não há token armazenado', () async {
      final token = await authService.getAccessToken();
      expect(token, isNull);
    });

    test('getRefreshToken retorna null quando não há token armazenado', () async {
      final token = await authService.getRefreshToken();
      expect(token, isNull);
    });

    test('getPortal retorna null quando não há portal armazenado', () async {
      final portal = await authService.getPortal();
      expect(portal, isNull);
    });

    test('getUserId retorna null quando não há userId armazenado', () async {
      final userId = await authService.getUserId();
      expect(userId, isNull);
    });

    test('signOut limpa todos os dados do secure storage', () async {
      // Simular dados armazenados
      FlutterSecureStorage.setMockInitialValues({
        kSecureAccessToken: 'test_access_token',
        kSecureRefreshToken: 'test_refresh_token',
        kSecureUserId: '123',
        kSecurePortal: 'test.bitrix24.com',
      });

      // Criar nova instância para pegar os valores mockados
      final service = AuthService();
      
      // Verificar que há dados antes
      expect(await service.getAccessToken(), isNotNull);
      
      // Executar signOut
      await service.signOut();
      
      // Verificar que os dados foram limpos
      final tokenAfter = await service.getAccessToken();
      expect(tokenAfter, isNull);
    });

    test('AuthResult contém todos os campos obrigatórios', () {
      final result = AuthResult(
        accessToken: 'test_access',
        refreshToken: 'test_refresh',
        userId: '123',
        portalDomain: 'test.bitrix24.com',
      );

      expect(result.accessToken, equals('test_access'));
      expect(result.refreshToken, equals('test_refresh'));
      expect(result.userId, equals('123'));
      expect(result.portalDomain, equals('test.bitrix24.com'));
    });
  });
}
