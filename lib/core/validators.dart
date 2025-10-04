// Copyright (c) Maximo Tecnologia 2025
// Validadores de entrada para segurança

class InputValidators {
  InputValidators._();

  /// Valida domínio do portal Bitrix24
  static bool isValidPortalDomain(String domain) {
    if (domain.isEmpty) return false;
    
    // Deve ser um domínio válido
    final domainRegex = RegExp(
      r'^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$'
    );
    
    // Deve conter bitrix24
    return domainRegex.hasMatch(domain) && domain.contains('bitrix24');
  }

  /// Valida Client ID
  static bool isValidClientId(String clientId) {
    if (clientId.isEmpty) return false;
    
    // Client ID deve ser alfanumérico com alguns caracteres especiais
    final clientIdRegex = RegExp(r'^[a-zA-Z0-9._\-]{10,}$');
    return clientIdRegex.hasMatch(clientId);
  }

  /// Valida URL de redirect
  static bool isValidRedirectUri(String uri) {
    if (uri.isEmpty) return false;
    
    try {
      final parsedUri = Uri.parse(uri);
      // Deve começar com o scheme do app
      return parsedUri.scheme == 'smartbitrix24';
    } catch (e) {
      return false;
    }
  }

  /// Valida título de tarefa
  static bool isValidTaskTitle(String title) {
    return title.trim().isNotEmpty && title.length <= 255;
  }

  /// Sanitiza entrada de texto para prevenir injeções
  static String sanitizeText(String text) {
    return text
        .replaceAll(RegExp(r'[<>]'), '') // Remove < e >
        .trim();
  }

  /// Valida token (formato básico)
  static bool isValidToken(String token) {
    if (token.isEmpty) return false;
    // Token deve ter no mínimo 20 caracteres
    return token.length >= 20;
  }
}
