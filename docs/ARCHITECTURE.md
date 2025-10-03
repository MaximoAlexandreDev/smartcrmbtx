# Arquitetura - Smart Bitrix24

## Visão Geral
- App Flutter (UI/UX moderna, Material 3)
- Persistência local com SQLite (tarefas, fila de sync, perfil)
- Camada de repositórios orquestra dados locais e chamadas remotas
- Backend Node/Express para fluxo OAuth seguro (sem client secret no app)
- Sincronização resiliente (fila, retentativas, marcação de status)

## Diagrama de Componentes (Mermaid)
```mermaid
flowchart LR
  UI[UI Flutter] --> State[State (Riverpod)]
  State --> RepoTasks[TaskRepository]
  State --> RepoSync[SyncRepository]
  RepoTasks --> DB[(SQLite)]
  RepoSync --> Queue[(sync_queue)]
  RepoSync -->|Bearer Token| BitrixAPI[Bitrix REST]
  Auth[AuthService] --> SecureStorage[(Secure Storage)]
  Auth --> BackendOAuth[Backend OAuth]
  BackendOAuth --> BitrixAuth[Bitrix OAuth]
```

## Diagrama de Sequência - Login
```mermaid
sequenceDiagram
  participant U as Usuário
  participant App as App Flutter
  participant B as Backend OAuth
  participant BX as Bitrix24

  U->>App: Informar portal + ClientID
  App->>BX: /oauth/authorize (navegador)
  BX-->>App: redirect smartbitrix24://?code=...
  App->>B: POST /oauth/exchange (code)
  B->>BX: POST /oauth/token (code -> tokens)
  BX-->>B: access_token + refresh_token
  B-->>App: tokens
  App->>App: salva tokens (secure)
```

## Diagrama de Sequência - Criação Offline e Sync
```mermaid
sequenceDiagram
  participant U as Usuário
  participant App as App
  participant DB as SQLite
  participant Q as Fila Sync
  participant BX as Bitrix REST

  U->>App: Criar tarefa
  App->>DB: INSERT tasks
  App->>Q: enqueue (tasks.task.add)
  App-->>U: Exibir na lista (offline)
  App->>BX: (quando online) processQueue()
  BX-->>App: 200 OK / erro
  App->>Q: mark SUCCESS / ERROR
```

## Padrões e Princípios
- Clean-ish architecture: separação UI/Estado/Domínio/Infra
- Fail-safe: fila de sincronização e retentativas
- Segurança by design: OAuth seguro, storage protegido, HTTPS