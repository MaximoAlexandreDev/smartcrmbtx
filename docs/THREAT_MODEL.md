# Threat Model

## Superfícies de ataque
- App móvel (interceptação de tokens, engenharia reversa)
- Backend OAuth (abuso de endpoint, brute-force)
- Comunicação com Bitrix (MITM sem HTTPS)

## Ameaças e Mitigações
- Exposição de client secret no app → uso de backend para exchange
- Token theft → Secure Storage, TLS, pouca exposição nos logs
- Replay/Abuso → Rate limit, validade de tokens, monitoramento
- MITM → HSTS/TLS, certificate pinning (opcional)
- DoS → Rate limiting, escalabilidade e monitoração