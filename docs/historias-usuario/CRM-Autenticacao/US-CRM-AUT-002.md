# US-CRM-AUT-002: Realizar Logout do Sistema

## História de Usuário

**Como** consultor logado no CRM,  
**Eu quero** fazer logout do sistema de forma segura,  
**Para que** eu possa encerrar minha sessão e proteger minhas informações quando não estiver utilizando o sistema.

## Prioridade

Essencial

## Estimativa

2 SP

## Critérios de Aceitação

### Cenário 1: Logout manual bem-sucedido
- **Dado que** estou logado no sistema CRM
- **Quando** clico no meu nome/avatar no canto superior direito
- **E** seleciono a opção "Sair"
- **Então** minha sessão é encerrada imediatamente
- **E** sou redirecionado para a tela de login
- **E** não consigo mais acessar páginas protegidas sem fazer login novamente

### Cenário 2: Confirmação antes de logout com trabalho não salvo
- **Dado que** estou editando uma cotação ou proposta
- **E** há alterações não salvas
- **Quando** tento fazer logout
- **Então** vejo modal de confirmação "Você tem alterações não salvas. Deseja realmente sair?"
- **E** posso escolher "Salvar e Sair", "Sair sem Salvar" ou "Cancelar"

### Cenário 3: Logout automático por inatividade
- **Dado que** estou logado no sistema
- **E** fico inativo por mais de 2 horas
- **Quando** o sistema detecta inatividade
- **Então** minha sessão é encerrada automaticamente
- **E** vejo notificação "Sua sessão expirou por inatividade"
- **E** sou redirecionado para tela de login

### Cenário 4: Logout de todas as sessões
- **Dado que** tenho múltiplas sessões ativas (desktop + mobile)
- **Quando** faço logout e marco opção "Encerrar todas as sessões"
- **Então** todas as minhas sessões ativas são invalidadas
- **E** preciso fazer login novamente em todos os dispositivos

### Cenário 5: Limpeza de dados locais
- **Dado que** fiz logout do sistema
- **Então** todos os tokens de autenticação são removidos
- **E** dados em cache local são limpos (exceto preferências gerais)
- **E** não há informações sensíveis armazenadas no navegador

## Regras de Negócio Relacionadas
- **RN-CRM-AUT-010**: Sessão expira após 2 horas de inatividade
- **RN-CRM-AUT-011**: Logout deve invalidar todos os tokens de acesso
- **RN-CRM-AUT-012**: Sistema deve registrar data/hora do logout para auditoria

## Requisitos Relacionados
- **REQ-CRM-AUT-010**: Sistema deve invalidar tokens no backend
- **REQ-CRM-AUT-011**: Sistema deve limpar storage local
- **REQ-CRM-AUT-012**: Sistema deve registrar logout em log de auditoria

## Dependências
- US-CRM-AUT-001 (Login) deve estar implementado
- Sistema de tokens JWT configurado

## Notas Técnicas

### Segurança
- Invalidar JWT token no backend (blacklist)
- Limpar localStorage e sessionStorage
- Revogar refresh tokens
- Registrar evento de logout em auditoria

### Performance
- Logout deve ser instantâneo (< 500ms)
- Limpeza assíncrona de cache não deve bloquear redirect

### Integrações
- Notificar TopERP principal sobre encerramento de sessão
- Registrar em log de auditoria centralizado

## Mockups/Wireframes

### Menu de Usuário
```
┌────────────────────────────────────────┐
│ [LOGO]  [Dashboard] [Leads] [Avatar ▼]│
│                                        │
│                    ┌──────────────────┐│
│                    │ João Silva       ││
│                    │ Consultor        ││
│                    ├──────────────────┤│
│                    │ Meu Perfil       ││
│                    │ Configurações    ││
│                    │ Ajuda            ││
│                    ├──────────────────┤│
│                    │ 🚪 Sair          ││
│                    └──────────────────┘│
└────────────────────────────────────────┘
```

### Modal de Confirmação
```
┌─────────────────────────────────────────┐
│  ⚠️  Alterações não salvas              │
│                                         │
│  Você tem alterações não salvas.        │
│  Deseja realmente sair?                 │
│                                         │
│  [Cancelar]  [Sair sem Salvar]  [Salvar│
│                             e Sair]     │
└─────────────────────────────────────────┘
```

## Definição de Pronto

- Botão de logout acessível em todas as páginas
- Invalidação de tokens no backend
- Limpeza de dados locais implementada
- Modal de confirmação para trabalho não salvo
- Logout automático por inatividade funcional
- Testes unitários com cobertura > 80%
- Testes de integração executados
- Testes de segurança (verificar limpeza de tokens)
- [x] Documentação atualizada
- [x] Code review aprovado
- [x] QA validou todos os cenários
- [x] Deploy em homologação
- [x] Aprovação do PO

---

**Criado por**: Gustavo Titoneli (Product Owner - CRM)  
**Data de Criação**: 21/01/2026  
**Última Atualização**: 21/01/2026  
**Versão**: 1.0  
**Epic**: Autenticação e Segurança  
**Sprint**: A definir
