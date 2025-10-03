# Smart Bitrix24 (Versão 1.0 Lite)

Aplicativo Flutter com integração ao Bitrix24 via REST API, suporte a modo offline e sincronização segura. Inclui backend para fluxo OAuth, documentação técnica, segurança e conformidade LGPD/ISO.

- Nome do app: Smart Bitrix24
- Versão: 1.0 Lite
- Copyright:
  - Copyright (c) Maximo Tecnologia 2025
- Requisitos:
  - Flutter 3.24+
  - Node.js 18+ (para backend OAuth)
  - Conta Bitrix24 e App registrado (Client ID/Secret)

## Arquitetura (resumo)
- App Flutter (Material 3, Riverpod)
- Banco local SQLite (sqflite) para dados offline e fila de sincronização
- Backend Node/Express para troca de tokens OAuth (não expõe secret no app)
- Sincronização resiliente com fila e retentativas

## Setup do App Móvel

1) Instale dependências:
```
flutter pub get
```

2) Configure o esquema de deep link:
- Android: `android/app/src/main/AndroidManifest.xml` adicione o intent filter para `smartbitrix24://auth/callback`
- iOS: `ios/Runner/Info.plist` configure o `CFBundleURLSchemes` com `smartbitrix24`

3) Ajuste a configuração:
- `lib/core/config.dart`:
  - `AppConfig.backendBaseUrl` -> URL do seu backend (HTTPS em produção)
- No login, informe:
  - Domínio do portal: `seuportal.bitrix24.com`
  - Client ID: do app Bitrix24 (o Secret fica no backend)

4) Executar:
```
flutter run
```

## Setup do Backend OAuth

```
cd backend
cp .env.example .env
# Edite CLIENT_ID e CLIENT_SECRET do App Bitrix24
npm i
npm run dev
```

## Fluxo de Autenticação
1. Usuário informa domínio e Client ID
2. App abre navegador no Bitrix24 (OAuth Authorization Code)
3. Bitrix24 redireciona para o deep link `smartbitrix24://auth/callback?code=...`
4. App envia `code` ao backend
5. Backend troca por `access_token` e `refresh_token`
6. App armazena tokens em storage seguro (Keychain/Keystore)

## Modo Offline e Sincronização
- Ações do usuário (ex.: criar tarefa) são salvas localmente e enfileiradas em `sync_queue`
- Ao ficar online, o app processa a fila chamando os métodos REST do Bitrix24 (ex.: `tasks.task.add`)
- Política de retentativas e marcação de sucesso/erro por item

## Segurança
- Tokens armazenados em `flutter_secure_storage`
- Comunicação com backend e Bitrix24 via HTTPS
- Backend com Helmet, Rate Limit e CORS restrito
- Mapeamento LGPD/ISO nos documentos em `docs/`

## Documentação
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
- [docs/API.md](docs/API.md)
- [docs/SECURITY.md](docs/SECURITY.md)
- [docs/COMPLIANCE.md](docs/COMPLIANCE.md)
- [docs/THREAT_MODEL.md](docs/THREAT_MODEL.md)
- [docs/LGPD/POLITICA_DE_PRIVACIDADE.md](docs/LGPD/POLITICA_DE_PRIVACIDADE.md)
- [docs/LGPD/TERMO_DE_CONSENTIMENTO.md](docs/LGPD/TERMO_DE_CONSENTIMENTO.md)
- [docs/LGPD/ACORDO_DPA.md](docs/LGPD/ACORDO_DPA.md)
- [docs/LGPD/DPIA.md](docs/LGPD/DPIA.md)
- [docs/LGPD/MATRIZ_BASES_LEGAIS.md](docs/LGPD/MATRIZ_BASES_LEGAIS.md)

## Licença
Veja [LICENSE](LICENSE). Todos os direitos reservados a Maximo Tecnologia 2025.

## Avisos
- Este projeto é um “starter” completo e seguro. Ajustes adicionais podem ser necessários conforme regras do seu portal Bitrix24 e processos internos de governança e segurança.