# Smart Bitrix24 - Backend OAuth

Backend seguro para troca de `authorization_code` por `access_token` e `refresh_token` com Bitrix24, evitando expor o Client Secret no app móvel.

- Framework: Express (TypeScript)
- Segurança: Helmet, CORS restrito, Rate Limiting
- Endpoints:
  - POST `/oauth/exchange` - troca `code` por tokens
  - POST `/oauth/refresh` - refresh de token
  - GET `/health` - status

## Como rodar

1. Node.js LTS 18+
2. `cp .env.example .env` e preencha:
   - `CLIENT_ID` e `CLIENT_SECRET` do app do Bitrix24
3. `npm i`
4. `npm run dev` (desenvolvimento) ou `npm run build && npm start` (produção)
5. Configure o app móvel para apontar `AppConfig.backendBaseUrl` para este backend (HTTPS em produção).

## Segurança
- Não armazena dados pessoais ou tokens no servidor (stateless).
- Use HTTPS com certificado válido em produção.
- Restrinja `CORS_ORIGIN` aos domínios do app web/admin (se houver).