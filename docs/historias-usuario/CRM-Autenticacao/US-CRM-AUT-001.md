# US-CRM-AUT-001: Realizar Login no Sistema

## História de Usuário

**Como** consultor de proteção veicular,  
**Eu quero** acessar o sistema CRM utilizando minhas credenciais,  
**Para que** eu possa gerenciar meus leads, cotações e propostas de forma segura.

## Prioridade

Essencial

## Estimativa

5 SP

## Critérios de Aceitação

### Cenário 1: Login bem-sucedido
- **Dado que** estou na tela de login do CRM
- **E** tenho credenciais válidas (e-mail e senha)
- **Quando** preencho meu e-mail e senha corretamente
- **E** clico no botão "Entrar"
- **Então** sou autenticado no sistema
- **E** sou redirecionado para o dashboard principal
- **E** vejo meu nome e perfil exibidos no cabeçalho

### Cenário 2: Login com credenciais inválidas
- **Dado que** estou na tela de login
- **Quando** insiro e-mail ou senha incorretos
- **E** clico no botão "Entrar"
- **Então** vejo mensagem de erro "E-mail ou senha incorretos"
- **E** permaneço na tela de login
- **E** o campo de senha é limpo por segurança

### Cenário 3: Bloqueio após múltiplas tentativas
- **Dado que** tentei fazer login 3 vezes com credenciais incorretas
- **Quando** tento fazer login pela 4ª vez
- **Então** vejo mensagem "Conta temporariamente bloqueada por 15 minutos"
- **E** não consigo fazer login mesmo com credenciais corretas
- **E** recebo e-mail notificando sobre as tentativas de acesso

### Cenário 4: Login com múltiplas empresas
- **Dado que** tenho acesso a mais de uma empresa/instância
- **E** faço login com sucesso
- **Quando** o sistema detecta múltiplas empresas vinculadas
- **Então** vejo tela de seleção de empresa
- **E** posso escolher qual empresa/instância desejo acessar
- **E** após selecionar, sou redirecionado para o dashboard

### Cenário 5: Lembreção de login
- **Dado que** estou na tela de login
- **Quando** marco a opção "Lembrar-me"
- **E** faço login com sucesso
- **Então** na próxima vez que acessar o sistema
- **E** não precisarei inserir minhas credenciais novamente (por 30 dias)

### Cenário 6: Sessão expirada
- **Dado que** estou logado no sistema
- **E** fico inativo por mais de 2 horas
- **Quando** tento realizar qualquer ação
- **Então** vejo mensagem "Sessão expirada por inatividade"
- **E** sou redirecionado para a tela de login

## Regras de Negócio Relacionadas
- **RN-CRM-AUT-001**: Senha deve conter no mínimo 8 caracteres
- **RN-CRM-AUT-002**: Após 3 tentativas incorretas, bloqueio por 15 minutos
- **RN-CRM-AUT-003**: Usuário pode ter acesso a múltiplas empresas
- **RN-CRM-AUT-010**: Sessão expira após 2 horas de inatividade

## Requisitos Relacionados
- **REQ-CRM-AUT-001**: Sistema deve validar credenciais contra base de dados
- **REQ-CRM-AUT-002**: Sistema deve registrar todos os acessos (log de auditoria)
- **REQ-CRM-AUT-003**: Sistema deve criptografar senhas (bcrypt ou similar)

## Dependências
- Cadastro de usuários deve estar implementado
- Base de dados de autenticação configurada
- Integração com módulo de auditoria

## Notas Técnicas

### Segurança
- Implementar proteção contra ataques de força bruta
- Usar HTTPS para todas as comunicações
- Tokens JWT com expiração de 2 horas
- Refresh token com validade de 30 dias (se "Lembrar-me" ativado)

### Performance
- Validação de credenciais deve ocorrer em < 1 segundo
- Cache de permissões de usuário para evitar consultas repetidas

### Integrações
- Sistema deve validar se usuário está ativo no TopERP principal
- Log de acesso deve ser enviado para sistema de auditoria

## Mockups/Wireframes

### Tela de Login
```
┌─────────────────────────────────────────┐
│                                         │
│         [LOGO TopBrasil CRM]            │
│                                         │
│   Acesse sua conta                      │
│                                         │
│   E-mail:                               │
│   [____________________________]        │
│                                         │
│   Senha:                                │
│   [____________________________] [👁]    │
│                                         │
│   ☐ Lembrar-me                          │
│                                         │
│   [      ENTRAR      ]                  │
│                                         │
│   Esqueceu sua senha?                   │
│                                         │
└─────────────────────────────────────────┘
```

## Definição de Pronto

- Interface de login responsiva implementada
- Validação de credenciais funcional
- Bloqueio após 3 tentativas implementado
- Seleção de empresa para multi-instância
- Testes unitários com cobertura > 80%
- Testes de integração executados
- Testes de segurança realizados (penetration testing básico)
- Documentação de API atualizada
- [x] Code review aprovado
- [x] QA validou todos os cenários
- [x] Performance validada (< 1s para autenticação)
- [x] Deploy em homologação
- [x] Aprovação do PO

---

**Criado por**: Gustavo Titoneli (Product Owner - CRM)  
**Data de Criação**: 21/01/2026  
**Última Atualização**: 21/01/2026  
**Versão**: 1.0  
**Epic**: Autenticação e Segurança  
**Sprint**: A definir
