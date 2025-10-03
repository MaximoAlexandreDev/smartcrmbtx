// Cliente REST para o Bitrix24.
// Observação: Bitrix REST tipicamente aceita auth via ?auth=ACCESS_TOKEN ou Bearer.
// Aqui usamos Bearer e endpoint: https://{portal}/rest/{method}.json

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/errors.dart';

class BitrixApiService {
  final String portalDomain;

  BitrixApiService(this.portalDomain);

  Future<Map<String, dynamic>> call({
    required String method,
    required Map<String, dynamic> params,
    required String accessToken,
  }) async {
    final url = Uri.https(portalDomain, '/rest/$method.json');

    final resp = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(params),
    );

    if (resp.statusCode == 401 || resp.statusCode == 403) {
      throw AuthError('Token inválido ou expirado');
    }

    if (resp.statusCode >= 400) {
      throw ApiError('Erro ${resp.statusCode}: ${resp.body}');
    }

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    if (data is Map && data.containsKey('error')) {
      throw ApiError('Bitrix Error: ${data['error_description'] ?? data['error']}');
    }

    return data;
  }
}