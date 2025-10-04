// Copyright (c) Maximo Tecnologia 2025
// Mock do BitrixApiService para testes

import 'package:smart_bitrix24/data/bitrix/bitrix_api_service.dart';

class MockBitrixApiService extends BitrixApiService {
  bool callCalled = false;
  int callCount = 0;
  bool shouldFail = false;

  MockBitrixApiService() : super('test.bitrix24.com');

  @override
  Future<Map<String, dynamic>> call({
    required String method,
    required Map<String, dynamic> params,
    required String accessToken,
  }) async {
    callCalled = true;
    callCount++;

    if (shouldFail) {
      throw Exception('API call failed');
    }

    return {
      'result': {
        'task': {
          'id': '123',
          'title': params['fields']?['TITLE'] ?? 'Test Task',
        }
      }
    };
  }
}
