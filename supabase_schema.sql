-- ==============================================================================
-- SCHEMA DO SUPPY (Sistema de Suporte)
-- ==============================================================================
-- Este arquivo define a estrutura do banco de dados no Supabase (PostgreSQL).
-- Execute este script no SQL Editor do Supabase para criar tudo de uma vez.

-- 1. Habilitar extensão para IDs seguros (já vem padrão no Supabase, mas por garantia)
create extension if not exists "pgcrypto";

-- ==============================================================================
-- TABELA: CLIENTS
-- ==============================================================================
create table public.clients (
  id uuid default gen_random_uuid() primary key,
  -- O user_id vincula cada cliente ao conta do usuário logado (segurança)
  user_id uuid references auth.users(id) default auth.uid() not null,
  
  name text not null,
  system text not null check (system in ('winfood', 'cplug')),
  status text not null check (status in ('implantation', 'active', 'inactive')),
  
  -- Campos específicos de cada sistema
  login_code text,        -- Para Cplug
  
  -- RENOMEADO de 'system_user' para 'system_login' para evitar erro de palavra reservada
  system_login text,      -- Para Winfood (Operador) ou Cplug (Usuário)
  
  -- Senha CRIPTOGRAFADA. Nunca armazenaremos a senha real aqui.
  -- O Frontend vai encriptar antes de enviar.
  encrypted_password text,
  
  cnpj text,
  
  -- Dados flexíveis (Lista de telefones, e-mails, etc)
  -- Ex: [{"type": "whatsapp", "value": "11999999999"}]
  contact_info jsonb default '[]'::jsonb,
  
  -- Integrações sensíveis (Anydesk, iFood). 
  -- Guardaremos como JSON para flexibilidade.
  integrations jsonb default '[]'::jsonb,
  
  created_at timestamptz default now()
);

-- Ativar segurança nível de linha (RLS)
alter table public.clients enable row level security;

-- Política de Segurança: O usuário só pode ver/editar seus próprios clientes
create policy "Usuários gerenciam apenas seus próprios clientes" 
on public.clients for all 
using (auth.uid() = user_id);

-- ==============================================================================
-- TABELA: TASKS (Tarefas)
-- ==============================================================================
create table public.tasks (
  id uuid default gen_random_uuid() primary key,
  
  -- Se o cliente for deletado, suas tarefas somem (cascade)
  client_id uuid references public.clients(id) on delete cascade not null,
  user_id uuid references auth.users(id) default auth.uid() not null,
  
  description text not null, -- Texto rico em Markdown/HTML
  
  -- Status da tarefa para ordenação
  status text not null default 'pending' 
    check (status in ('urgent', 'in_progress', 'pending', 'done')),
  
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

alter table public.tasks enable row level security;

create policy "Usuários gerenciam apenas suas próprias tarefas" 
on public.tasks for all 
using (auth.uid() = user_id);

-- ==============================================================================
-- TABELA: NOTES (Informações Gerais)
-- ==============================================================================
create table public.notes (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) default auth.uid() not null,
  
  title text not null,
  content text,
  is_favorite boolean default false,
  
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

alter table public.notes enable row level security;

create policy "Usuários gerenciam apenas suas próprias notas" 
on public.notes for all 
using (auth.uid() = user_id);

-- ==============================================================================
-- GATILHOS (TRIGGERS)
-- ==============================================================================
-- Função automática para atualizar o campo updated_at sempre que editar a linha

create or replace function update_updated_at_column()
returns trigger as $$
begin
    new.updated_at = now();
    return new;
end;
$$ language 'plpgsql';

create trigger update_tasks_updated_at before update on tasks
    for each row execute procedure update_updated_at_column();

create trigger update_notes_updated_at before update on notes
    for each row execute procedure update_updated_at_column();
