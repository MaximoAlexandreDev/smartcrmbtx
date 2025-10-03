// Copyright (c) Maximo Tecnologia 2025
// Fonte única de configuração do app.
// Observação: Não armazene Client Secret no app. Para OAuth, usar backend com PKCE/Exchange seguro.

class AppConfig {
  AppConfig._();

  // Pode ser ajustado via Settings (persistido localmente).
  static String portalDomain = ''; // ex: suaconta.bitrix24.com

  // Endereço do backend seguro (Node/Express) para troca de código OAuth e refresh.
  static String backendBaseUrl = 'http://10.0.2.2:3000'; // Emulador Android
  // Em produção, usar HTTPS com certificado válido.
}