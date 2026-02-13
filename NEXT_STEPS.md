# Ponto de Controle - Projeto Suppy (12/02/2026)

Este arquivo serve como contexto para a próxima sessão de desenvolvimento com o Agente AI.

## 📊 Status Atual do Projeto

- **Fase 1 (Arquitetura):** ✅ Concluída (React + Vite + TS + Supabase).
- **Fase 2 (Banco de Dados):** ✅ Concluída (Schema SQL criado e rodado no Supabase).
- **Fase 3 (Setup):** ✅ Concluída (Tailwind, Estrutura de pastas).
- **Fase 4 (Backend/Auth):** ✅ Concluída (Conexão Supabase, Login funcionando, AuthContext).
- **Fase 5 (Frontend Base):** ✅ Concluída (Sidebar responsiva, Dashboard com dados mockados).
- **Fase 6 (Clientes):** 🚧 **EM ANDAMENTO** (Próximo passo).

---

## 🛠️ O que foi feito na última sessão
1.  Configuramos o ambiente (`.env.local`) e corrigimos erros de conexão (`Failed to fetch`).
2.  Criamos a autenticação completa (Login, Proteção de Rotas).
3.  Criamos o Layout Principal (Sidebar, Header Mobile).
4.  Criamos a Dashboard Visual (apenas visual, sem dados reais).
5.  Instalamos `crypto-js` para criptografia de senhas (mas ainda não implementamos o código).

---

## 🎯 Próximos Passos (Para o Próximo Agente)

O objetivo imediato é implementar o **CRUD de Clientes** com criptografia de senha.

1.  **Criar Hook de Criptografia (`src/hooks/useEncryption.ts`)**: Usar `crypto-js` para encrypt/decrypt senhas.
2.  **Criar Tela de Listagem (`src/pages/Clients.tsx`)**:
    *   Substituir a tabela mockada da Dashboard por uma tabela real buscando da tabela `clients` do Supabase.
    *   Implementar a lógica visual: Clientes Cplug (Azul) vs Winfood (Vermelho).
3.  **Criar Modal de Cadastro/Edição (`src/components/Clients/ClientModal.tsx`)**:
    *   Formulário com campos condicionais (se Winfood mostra X, se Cplug mostra Y).
    *   Validar campos obrigatórios.
    *   **IMPORTANTE:** Criptografar a senha antes de enviar ao Supabase.

---

## 🤖 Prompt para Continuar (Copie e Cole na próxima sessão)

```text
Olá! Estou continuando o desenvolvimento do projeto "Suppy", um sistema de suporte técnico.
O projeto já está configurado com React, TypeScript, Tailwind e Supabase.
O Login e a Dashboard (visual) já estão prontos.
A biblioteca 'crypto-js' já foi instalada via npm.

Seu objetivo agora é implementar o Módulo de Clientes (Fase 6).

Por favor, siga estas etapas:
1. Crie o hook 'src/hooks/useEncryption.ts' para criptografar strings usando AES (use uma chave fixa temporária para dev).
2. Crie o componente 'src/pages/Clients.tsx' para listar os clientes vindos do Supabase.
3. Crie o componente 'src/components/Clients/ClientModal.tsx' para cadastrar novos clientes, com campos condicionais baseados no 'Sistema' (Winfood/Cplug).

REQUISITOS DE NEGÓCIO (Relembrando):
- Clientes Winfood: Fundo vermelho claro na tabela. Campos: Nome, Operador, Senha (criptografada).
- Clientes Cplug: Fundo azul claro na tabela. Campos: Nome, Código Login, Usuário, Senha (criptografada).
- Senhas NUNCA podem ser salvas em texto puro no banco.

Por favor, explique o plano antes de codar e mantenha o padrão de código limpo e componentes pequenos.
Consulte o arquivo 'TECHNICAL.md' e 'src/types/index.ts' para ver a estrutura de dados já definida.
```

---

## 📋 Requisitos Originais do Projeto (Contexto Completo)

**Objetivo:** Sistema seguro para armazenar Clientes, Tarefas e Anotações.
**Stack:** React, Vite, TypeScript, Supabase, TailwindCSS.

### Funcionalidades Chave:
1.  **Dashboard:** Resumo de últimos clientes e tarefas urgentes.
2.  **Clientes:**
    *   Listagem colorida por sistema.
    *   Cadastro com campos dinâmicos.
    *   Segurança forte (senhas cifradas).
3.  **Tarefas:** Vinculadas a clientes, status (Urgente, Pendente, etc).
4.  **Info Gerais:** Anotações rápidas favoritas.
5.  **Mobile First:** Menu lateral que vira gaveta no celular.

### Banco de Dados (Supabase):
*   Tabelas: `clients`, `tasks`, `notes`.
*   RLS ativado (usuário só vê seus dados).
*   Campo `system_login` renomeado de `system_user` para evitar conflito SQL.

---
**Fim do Relatório.**
