# API - Integração Bitrix24

## Base
- URL base dinâmica por portal: `https://{portal}/rest`
- Autorização: `Authorization: Bearer {access_token}`

## Exemplo: Criar Tarefa
- Método: `tasks.task.add`
- Endpoint: `POST https://{portal}/rest/tasks.task.add.json`
- Payload:
```json
{
  "fields": {
    "TITLE": "Minha tarefa",
    "DESCRIPTION": "Detalhes..."
  }
}
```

## Exemplo: Criar Contato (CRM)
- Método: `crm.contact.add`
- Endpoint: `POST https://{portal}/rest/crm.contact.add.json`
- Payload:
```json
{
  "fields": {
    "NAME": "João",
    "LAST_NAME": "Silva",
    "OPENED": "Y",
    "TYPE_ID": "CLIENT",
    "SOURCE_ID": "SELF"
  }
}
```

## Erros comuns
- 401/403: token expirado/inválido
- 400: parâmetros ausentes
- Erros específicos do Bitrix retornam `error`/`error_description` no corpo