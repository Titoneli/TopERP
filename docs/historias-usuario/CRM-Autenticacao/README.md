# CRM-Autenticação (CRM-AUT)

| Metadado | Valor |
|----------|-------|
| **Módulo** | Autenticação |
| **Código** | CRM-AUT |
| **Versão** | 2.0 |
| **Data** | 22/01/2026 |
| **Autor** | Product Owner |
| **Status** | Documentado |
| **Tipo DDD** | Generic Domain |

---

## 1. Visão Geral

O módulo **CRM-Autenticação** é responsável por gerenciar o acesso seguro ao sistema CRM. Este é um **Bounded Context Genérico** pois a funcionalidade de autenticação é comum a diversos sistemas e não representa diferencial competitivo.

### 1.1 Responsabilidades

- Login e logout de usuários
- Gestão de sessões (JWT)
- Controle de permissões por perfil
- Recuperação de senha
- Bloqueio por tentativas inválidas
- Rastreabilidade de acessos

### 1.2 Posição na Arquitetura

```
[Usuário] ──► [AUTENTICAÇÃO] ──► [JWT Token] ──► [Todos os Módulos CRM]
                   │
               CRM-AUT
```

---

## 2. Domain-Driven Design

### 2.1 Bounded Context

| Atributo | Descrição |
|----------|-----------|
| **Nome** | Autenticação |
| **Tipo** | Generic Domain |
| **Linguagem Ubíqua** | Login, Token, Sessão, Permissão, Perfil |

### 2.2 Agregados

#### Agregado: Sessão

```
┌─────────────────────────────────────────────────────────┐
│                     SESSÃO (Root)                       │
├─────────────────────────────────────────────────────────┤
│ - id: UUID                                              │
│ - usuario_id: UUID (FK COR_USUARIO)                     │
│ - token: JWTToken                                       │
│ - data_inicio: DateTime                                 │
│ - data_expiracao: DateTime                              │
│ - ip_origem: String                                     │
│ - user_agent: String                                    │
│ - status: StatusSessao                                  │
│                                                         │
│ Value Objects:                                          │
│ ├── JWTToken (token, tipo, expiracao)                   │
│ └── StatusSessao (ATIVA, EXPIRADA, REVOGADA)            │
└─────────────────────────────────────────────────────────┘
```

#### Agregado: Usuario

```
┌─────────────────────────────────────────────────────────┐
│                     USUARIO (Root)                      │
├─────────────────────────────────────────────────────────┤
│ - id: UUID                                              │
│ - pessoa_id: UUID (FK COR_PESSOA)                       │
│ - email: Email                                          │
│ - senha_hash: String                                    │
│ - perfis: List<Perfil>                                  │
│ - status: StatusUsuario                                 │
│ - tentativas_login: Integer                             │
│ - bloqueado_ate: DateTime?                              │
│                                                         │
│ Entidades:                                              │
│ └── PerfilUsuario                                       │
│     - id: UUID                                          │
│     - perfil_id: UUID                                   │
│     - empresa_id: UUID                                  │
│     - permissoes: List<Permissao>                       │
│                                                         │
│ Value Objects:                                          │
│ ├── Email (valor)                                       │
│ ├── StatusUsuario (ATIVO, INATIVO, BLOQUEADO)           │
│ └── Permissao (recurso, acao)                           │
└─────────────────────────────────────────────────────────┘
```

### 2.3 Entidades

| Entidade | Descrição | Atributos Principais |
|----------|-----------|----------------------|
| **Sessão** | Aggregate Root - Sessão de usuário | id, token, status |
| **Usuario** | Aggregate Root - Credenciais do usuário | id, email, perfis |
| **PerfilUsuario** | Perfil associado ao usuário | perfil_id, permissoes |

### 2.4 Value Objects

| Value Object | Descrição | Atributos |
|--------------|-----------|-----------|
| **JWTToken** | Token de autenticação | token, tipo, expiracao |
| **Email** | E-mail validado | valor |
| **Permissao** | Permissão de acesso | recurso, acao |
| **StatusSessao** | Estado da sessão | ATIVA, EXPIRADA, REVOGADA |
| **StatusUsuario** | Estado do usuário | ATIVO, INATIVO, BLOQUEADO |

### 2.5 Eventos de Domínio

| Evento | Trigger | Consumidores |
|--------|---------|--------------|
| `LoginRealizado` | Login bem-sucedido | CRM-AUD, CRM-DAS |
| `LogoutRealizado` | Logout executado | CRM-AUD |
| `LoginFalhou` | Credenciais inválidas | CRM-AUD |
| `UsuarioBloqueado` | 3+ tentativas falhas | CRM-AUD |
| `SenhaAlterada` | Senha atualizada | CRM-AUD |

### 2.6 Repositórios

| Repositório | Métodos Principais |
|-------------|-------------------|
| `SessaoRepository` | save, findByToken, findByUsuarioId, revogar |
| `UsuarioRepository` | save, findById, findByEmail, bloquear |

---

## 3. Integrações

### 3.1 Downstream (Fornece para)

| Contexto | Dados Fornecidos | Padrão |
|----------|------------------|--------|
| CRM-* | JWT Token, Permissões | Published Language |
| CRM-AUD | Eventos de login | Event Sourcing |

### 3.2 Upstream (Recebe de)

| Contexto | Dados Recebidos | Padrão |
|----------|-----------------|--------|
| COR_PESSOA | Dados da pessoa | Shared Kernel |
| COR_USUARIO | Cadastro do usuário | Shared Kernel |

---

## 4. Atores

- **Consultor**: Vendedor interno ou externo que utiliza o sistema
- **Administrador**: Responsável pela gestão de usuários e permissões
- **Supervisor/Gerente**: Coordena equipes de consultores
- **Sistema**: TopERP principal

---

## 5. Histórias de Usuário

### Essencial
- [US-CRM-AUT-001](US-CRM-AUT-001.md) - Realizar Login no Sistema
- [US-CRM-AUT-002](US-CRM-AUT-002.md) - Realizar Logout do Sistema
- US-CRM-AUT-003 - Recuperar Senha
- US-CRM-AUT-004 - Controle de Permissões por Perfil

### Importante
- US-CRM-AUT-005 - Autenticação Multifator (MFA)
- US-CRM-AUT-006 - Controle de Horário de Acesso
- US-CRM-AUT-007 - Expiração de Senha

### Desejável
- US-CRM-AUT-008 - Login por Biometria
- US-CRM-AUT-009 - Login Social (Google, Microsoft)

---

## 6. Regras de Negócio

| Código | Regra | Descrição |
|--------|-------|-----------|
| RN-AUT-001 | Senha mínima | Senha deve conter no mínimo 8 caracteres |
| RN-AUT-002 | Bloqueio | Após 3 tentativas incorretas, conta é bloqueada por 15 minutos |
| RN-AUT-003 | Multi-empresa | Usuário pode ter acesso a múltiplas empresas/instâncias |
| RN-AUT-004 | Perfil por empresa | Perfil de usuário é específico por empresa |
| RN-AUT-005 | JWT expira | Token JWT expira em 8 horas |
| RN-AUT-006 | Refresh token | Refresh token válido por 7 dias |

---

## 7. Métricas do Contexto

| Métrica | Descrição | Meta |
|---------|-----------|------|
| Taxa de sucesso de login | % logins bem-sucedidos | > 98% |
| Tempo médio de autenticação | Latência do login | < 2 segundos |
| Incidentes de segurança | Tentativas de invasão | Zero |

---

## 8. Histórico de Alterações

| Data | Versão | Autor | Alteração |
|------|--------|-------|-----------|
| 22/01/2026 | 2.0 | Product Owner | Atualização para padrão DDD completo |
| 21/01/2026 | 1.0 | Product Owner | Versão inicial |

---

## 9. Referências

- [Context Map](../../ddd/context-map.md)
- [Product Backlog](../../backlog/product-backlog.md)
