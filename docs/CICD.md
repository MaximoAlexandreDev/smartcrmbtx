# CI/CD - Integração e Deploy Contínuos
Copyright (c) Maximo Tecnologia 2025

## Visão Geral

O projeto Smart Bitrix24 utiliza GitHub Actions para automação de testes, builds e segurança.

## Workflows Configurados

### 1. Flutter CI (`.github/workflows/flutter-ci.yml`)

**Triggers**:
- Push para `main` ou `develop`
- Pull requests para `main` ou `develop`
- Modificações em arquivos Flutter

**Jobs**:

#### Analyze
- Verificação de formatação de código
- Análise estática com `flutter analyze`
- Verificação de dependências desatualizadas

#### Test
- Execução de todos os testes unitários
- Geração de relatório de cobertura
- Upload para Codecov

#### Build Android
- Compilação de APK release
- Upload de artefato para download

#### Build iOS
- Compilação iOS (sem assinatura)
- Execução em runners macOS

#### Security
- Auditoria de dependências Flutter

### 2. Backend CI (`.github/workflows/backend-ci.yml`)

**Triggers**:
- Push/PR em `main` ou `develop`
- Modificações em `backend/**`

**Jobs**:

#### Test
- Execução em Node 18.x e 20.x (matrix)
- Testes unitários e de integração
- Cobertura de código

#### Security
- `npm audit` para vulnerabilidades
- Snyk security scan (se configurado)

#### Build
- Compilação TypeScript
- Upload de artefatos dist/

### 3. Security Scan (`.github/workflows/security-scan.yml`)

**Triggers**:
- Push/PR em `main` ou `develop`
- Schedule semanal (segundas-feiras 9h UTC)

**Jobs**:

#### CodeQL Analysis
- Análise de código JavaScript/TypeScript
- Detecção de vulnerabilidades
- Queries de segurança e qualidade

#### Dependency Review
- Revisão de dependências em PRs
- Falha em vulnerabilidades moderadas+

#### Secret Scan
- Scan com TruffleHog
- Detecta secrets vazados no código

## Configuração

### Secrets Necessários

Configure no GitHub Settings → Secrets and variables → Actions:

```
SNYK_TOKEN          # (Opcional) Token do Snyk para scans de segurança
CODECOV_TOKEN       # (Opcional) Token do Codecov para upload de cobertura
```

### Variáveis de Ambiente

Configuradas nos workflows conforme necessário.

### Branch Protection

Recomendações para `main`:

1. **Require pull request reviews**: Mínimo 1 aprovação
2. **Require status checks**: 
   - Flutter CI: analyze, test
   - Backend CI: test, security
3. **Require branches to be up to date**: Sim
4. **Include administrators**: Não
5. **Allow force pushes**: Não
6. **Allow deletions**: Não

## Badges

Adicione ao README.md:

```markdown
![Flutter CI](https://github.com/MaximoAlexandreDev/smartcrmbtx/workflows/Flutter%20CI/badge.svg)
![Backend CI](https://github.com/MaximoAlexandreDev/smartcrmbtx/workflows/Backend%20CI/badge.svg)
![Security Scan](https://github.com/MaximoAlexandreDev/smartcrmbtx/workflows/Security%20Scan/badge.svg)
[![codecov](https://codecov.io/gh/MaximoAlexandreDev/smartcrmbtx/branch/main/graph/badge.svg)](https://codecov.io/gh/MaximoAlexandreDev/smartcrmbtx)
```

## Execução Local

### Simular CI Flutter

```bash
# Análise
dart format --output=none --set-exit-if-changed .
flutter analyze

# Testes
flutter test --coverage

# Build
flutter build apk --release
```

### Simular CI Backend

```bash
cd backend

# Build
npm run build

# Testes
npm test
npm run test:coverage

# Audit
npm audit --audit-level=moderate
```

## Otimização de Performance

### Cache

Os workflows utilizam cache para:
- Dependências Flutter (`flutter-action` com cache)
- Dependências Node (`setup-node` com cache)
- Builds intermediários

### Jobs Paralelos

Sempre que possível, jobs são executados em paralelo:
- Analyze → Test → Build (sequencial quando necessário)
- Security executa independentemente

### Matrix Strategy

Backend CI usa matrix para testar em múltiplas versões do Node (18.x, 20.x).

## Notificações

Configure notificações no GitHub:
- Settings → Notifications
- Watch o repositório para CI failures
- Configure Slack/Discord webhooks se necessário

## Deploy Automático (Futuro)

### Staging

```yaml
# Adicionar ao workflow
deploy-staging:
  if: github.ref == 'refs/heads/develop'
  needs: [test, build]
  runs-on: ubuntu-latest
  steps:
    - name: Deploy to Staging
      # Deploy steps
```

### Production

```yaml
deploy-production:
  if: github.ref == 'refs/heads/main'
  needs: [test, build, security]
  environment:
    name: production
    url: https://app.smartbitrix24.com
  steps:
    - name: Deploy to Production
      # Deploy steps
```

## Troubleshooting

### Falhas Comuns

1. **Flutter analyze falha**
   - Execute localmente: `flutter analyze`
   - Corrija warnings antes do PR

2. **Testes falham**
   - Execute localmente: `flutter test` ou `npm test`
   - Verifique logs detalhados no workflow

3. **Build falha**
   - Verifique dependências desatualizadas
   - Limpe cache: `flutter clean` ou `rm -rf node_modules`

4. **Security scan falha**
   - Revise vulnerabilidades reportadas
   - Atualize dependências: `flutter pub upgrade` ou `npm update`

### Logs Detalhados

Acesse no GitHub:
1. Actions tab
2. Selecione workflow run
3. Clique no job específico
4. Expanda o step com erro

## Manutenção

### Atualização de Actions

Periodicamente, atualize as versões das actions:

```yaml
- uses: actions/checkout@v4  # Verificar versão mais recente
- uses: subosito/flutter-action@v2
- uses: actions/setup-node@v4
```

### Revisão de Workflows

Trimestralmente:
1. Revisar tempos de execução
2. Otimizar jobs lentos
3. Atualizar matrix de versões Node/Flutter
4. Verificar se há novas best practices

## Métricas

Acompanhe no GitHub Insights → Actions:
- Tempo médio de execução
- Taxa de sucesso/falha
- Consumo de minutos

## Recursos Adicionais

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter CI/CD](https://flutter.dev/docs/deployment/cd)
- [Jest CI/CD](https://jestjs.io/docs/getting-started#using-jest-in-ci)

## Contato

Para questões sobre CI/CD, contate o time DevOps da Maximo Tecnologia.
