# Segurança

## Controles no App
- Tokens em `flutter_secure_storage` (Keychain/Keystore)
- Sem armazenamento de Client Secret no app
- Comunicação HTTPS obrigatória com backend e Bitrix
- Limitação de logs para evitar vazamento de dados sensíveis

## Controles no Backend
- Helmet (headers de segurança)
- Rate limiting (proteção contra abuso)
- CORS restrito
- Sem persistência de tokens (stateless)
- Recomendado: WAF/Firewall de aplicação, monitoramento e alertas

## Gestão de Incidentes
- Processo de triagem, contenção, erradicação e recuperação
- Canal de contato de segurança (inserir contato da Maximo Tecnologia)
- Registro de incidentes conforme LGPD (ANPD) quando aplicável

## Criptografia
- Em trânsito: TLS 1.2+ (HTTPS)
- Em repouso: dados sensíveis apenas no Secure Storage. Banco local sem dados pessoais desnecessários.