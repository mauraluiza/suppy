# Documentação Técnica - Suppy (Sistema de Suporte)

## 1. Visão Geral da Arquitetura

A aplicação é uma **SPA (Single Page Application)** desenvolvida com **React** e **TypeScript**, utilizando **Vite** como build tool para máxima performance. O Backend é totalmente servido pelo **Supabase** (BaaS - Backend as a Service), aprovechando suas capacidades de Realtime e Segurança.

### Stack Tecnológica

- **Frontend:** React 18, TypeScript, TailwindCSS (Estilização), Lucide React (Ícones).
- **Backend:** Supabase (PostgreSQL, Auth, Realtime, Storage).
- **Hosting:** Vercel (Frontend), Supabase Cloud (Backend).
- **State Management:** React Context API + Hooks customizados.
- **Routing:** React Router v6.

---

## 2. Estrutura de Pastas

A organização do código segue o padrão de separação de responsabilidades:

```bash
src/
├── assets/          # Recursos estáticos (imagens, fontes)
├── components/      # Componentes React
│   ├── Layout/      # Estruturas de página (Sidebar, Header, MainContainer)
│   └── UI/          # Componentes visuais genéricos (Button, Input, Card, Modal)
├── context/         # Gerenciamento de estado global (AuthContext, ThemeContext)
├── hooks/           # Lógica reutilizável (useAuth, useSupabase, useEncryption)
├── pages/           # Páginas da aplicação (Dashboard, Clients, Tasks)
├── services/        # Integrações externas (api.ts, supabaseClient.ts)
├── styles/          # Configurações globais de estilo
├── types/           # Definições de tipos TypeScript (Interfaces de dados)
└── utils/           # Funções auxiliares puras (formatDate, validators)
```

---

## 3. Modelo de Dados (Banco de Dados)

O banco de dados PostgreSQL no Supabase possui 3 tabelas principais, todas protegidas por RLS.

### Tabela `clients`
Armazena os clientes do sistema.
- **id (UUID):** Identificador único.
- **user_id (UUID):** Vínculo com o usuário dono do registro (Segurança RLS).
- **name (Text):** Nome do cliente.
- **system (Text):** 'winfood' | 'cplug'.
- **status (Text):** 'implantation' | 'active' | 'inactive'.
- **encrypted_password (Text):** Senha do cliente criptografada (AES-256).
- **contact_info (JSONB):** Array de contatos.
- **integrations (JSONB):** Dados de integração (Anydesk, iFood).

### Tabela `tasks`
Tarefas vinculadas a clientes.
- **id (UUID):** Identificador único.
- **client_id (UUID):** Chave estrangeira para `clients`.
- **description (Text):** Texto rico / markdown.
- **status (Text):** 'urgent' | 'in_progress' | 'pending' | 'done'.

### Tabela `notes`
Anotações gerais e rápidas.
- **title (Text):** Título da nota.
- **content (Text):** Conteúdo.
- **is_favorite (Boolean):** Flag de destaque.

---

## 4. Segurança

### Autenticação
Gerenciada pelo Supabase Auth (Email/Senha ou OAuth).

### Autorização (RLS)
Todas as tabelas possuem Row Level Security ativado.
Política padrão: `auth.uid() == user_id`.
Isso garante que um usuário jamais acesse dados de outro, mesmo se fizer requisições diretas à API.

### Criptografia de Dados Sensíveis
Senhas de clientes (Winfood/Cplug) e acessos remotos (Anydesk) são criptografados no cliente (Frontend) antes de serem enviados ao banco.
A chave de criptografia nunca é salva no banco de dados.
