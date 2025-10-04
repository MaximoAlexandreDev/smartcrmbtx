# Guia de Testes - Smart Bitrix24
Copyright (c) Maximo Tecnologia 2025

## Visão Geral

Este documento descreve a estratégia de testes, estrutura e como executar os testes do projeto Smart Bitrix24.

## Estrutura de Testes

### Flutter App

```
test/
├── unit/                    # Testes unitários
│   ├── auth_service_test.dart
│   ├── task_repository_test.dart
│   └── sync_repository_test.dart
├── integration/             # Testes de integração (futuro)
└── mocks/                   # Mocks e stubs
    ├── mock_daos.dart
    └── mock_api_service.dart
```

### Backend Node.js

```
backend/test/
├── server.test.ts          # Testes dos endpoints OAuth
└── rate-limiter.test.ts    # Testes de rate limiting
```

## Executando Testes

### Flutter

```bash
# Executar todos os testes
flutter test

# Executar com cobertura
flutter test --coverage

# Executar testes específicos
flutter test test/unit/auth_service_test.dart

# Ver relatório de cobertura (requer lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Backend

```bash
cd backend

# Instalar dependências
npm install

# Executar todos os testes
npm test

# Executar em modo watch
npm run test:watch

# Executar com cobertura
npm run test:coverage

# Ver relatório
open coverage/index.html
```

## Tipos de Testes

### Testes Unitários

Testam componentes isolados:
- **AuthService**: Verificação de armazenamento seguro de tokens
- **TaskRepository**: Criação e listagem de tarefas locais
- **SyncRepository**: Processamento da fila de sincronização
- **Validators**: Validação de entrada de dados

### Testes de Integração

Testam interação entre componentes:
- **OAuth Flow**: Fluxo completo de autenticação
- **Sync Process**: Sincronização end-to-end
- **Rate Limiting**: Proteção contra abuso

### Testes de Segurança

Verificam aspectos de segurança:
- Validação de entrada (XSS, SQL Injection)
- Rate limiting
- Sanitização de logs
- Armazenamento seguro

## Cobertura de Código

### Metas de Cobertura

- **Flutter**: ≥ 70% de cobertura
- **Backend**: ≥ 80% de cobertura
- **Funções críticas**: 100% de cobertura
  - AuthService
  - OAuth endpoints
  - Rate limiting
  - Validadores

### Visualizando Cobertura

Os relatórios de cobertura são gerados automaticamente no CI/CD e podem ser visualizados:
- No Codecov (integrado via GitHub Actions)
- Localmente após executar `flutter test --coverage` ou `npm run test:coverage`

## Boas Práticas

### Escrita de Testes

1. **Nomenclatura clara**: Descreva o que o teste faz
   ```dart
   test('createLocal cria tarefa e enfileira sync job', () async {
     // ...
   });
   ```

2. **Arrange-Act-Assert**: Organize seus testes
   ```dart
   // Arrange
   final repository = TaskRepository(mockTaskDao, mockSyncDao);
   
   // Act
   final task = await repository.createLocal(title: 'Test');
   
   // Assert
   expect(task.title, equals('Test'));
   ```

3. **Um conceito por teste**: Cada teste deve verificar uma única coisa

4. **Mocks adequados**: Use mocks para isolar dependências externas

### Testes de Segurança

1. **Teste validações**: Verifique que entradas inválidas são rejeitadas
2. **Teste sanitização**: Confirme que dados sensíveis não vazam nos logs
3. **Teste rate limiting**: Verifique que limites são respeitados
4. **Teste autenticação**: Confirme que endpoints protegidos exigem auth

## Integração Contínua

Os testes são executados automaticamente em:
- **Push para main/develop**: Todos os testes
- **Pull Requests**: Todos os testes + análise de cobertura
- **Schedule**: Testes de segurança semanalmente

### Workflows

- `.github/workflows/flutter-ci.yml`: Testes Flutter
- `.github/workflows/backend-ci.yml`: Testes Backend
- `.github/workflows/security-scan.yml`: Scans de segurança

## Debugging de Testes

### Flutter

```bash
# Executar com logs verbose
flutter test --verbose

# Debugar teste específico no VS Code/Android Studio
# Use breakpoints e execute em modo debug
```

### Backend

```bash
# Debug com Node inspector
node --inspect-brk node_modules/.bin/jest --runInBand

# Ou use VS Code launch configuration
```

## Adicionando Novos Testes

### Flutter

1. Crie arquivo em `test/unit/` ou `test/integration/`
2. Importe `flutter_test` e o código a ser testado
3. Crie mocks necessários em `test/mocks/`
4. Escreva testes usando `group()` e `test()`
5. Execute para verificar

### Backend

1. Crie arquivo em `backend/test/`
2. Importe `@jest/globals` e o código a ser testado
3. Use `describe()` e `it()` para estruturar
4. Execute com `npm test`

## Recursos Adicionais

- [Flutter Testing Guide](https://flutter.dev/docs/testing)
- [Jest Documentation](https://jestjs.io/docs/getting-started)
- [Supertest Documentation](https://github.com/ladjs/supertest)

## Suporte

Para questões sobre testes, abra uma issue no repositório ou contate a equipe de desenvolvimento.
