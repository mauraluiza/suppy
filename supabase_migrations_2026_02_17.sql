-- MIGRAÇÃO INCREMENTAL SUPPY-TI (2026-02-17)
-- Este script aplica melhorias de performance e segurança sem recriar tabelas.

-- ==============================================================================
-- 1. AJUSTES DE DEFAULT (Prevenção de Erros)
-- ==============================================================================
-- Garante que clientes criados sem status definido sejam 'active' por padrão.
ALTER TABLE public.clients ALTER COLUMN status SET DEFAULT 'active';

-- ==============================================================================
-- 2. ÍNDICES DE PERFORMANCE (Otimização RLS)
-- ==============================================================================
-- Essenciais para que as queries filtradas por usuário (RLS) sejam rápidas.
CREATE INDEX IF NOT EXISTS idx_clients_user_id ON public.clients(user_id);
CREATE INDEX IF NOT EXISTS idx_tasks_user_id ON public.tasks(user_id);
CREATE INDEX IF NOT EXISTS idx_tasks_client_id ON public.tasks(client_id);
CREATE INDEX IF NOT EXISTS idx_notes_user_id ON public.notes(user_id);

-- ==============================================================================
-- 3. POLICIES RLS EXPLÍCITAS (Segurança Granular)
-- ==============================================================================
-- Adicionando policies separadas para maior controle e clareza.
-- Nota: As policies existentes não são removidas para evitar downtime, 
-- mas novas policies explícitas garantem o comportamento correto.

-- --- CLIENTS ---
CREATE POLICY "insert own clients" ON public.clients FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "select own clients" ON public.clients FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "update own clients" ON public.clients FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "delete own clients" ON public.clients FOR DELETE USING (auth.uid() = user_id);

-- --- TASKS ---
CREATE POLICY "insert own tasks" ON public.tasks FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "select own tasks" ON public.tasks FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "update own tasks" ON public.tasks FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "delete own tasks" ON public.tasks FOR DELETE USING (auth.uid() = user_id);

-- --- NOTES ---
CREATE POLICY "insert own notes" ON public.notes FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "select own notes" ON public.notes FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "update own notes" ON public.notes FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "delete own notes" ON public.notes FOR DELETE USING (auth.uid() = user_id);


-- ==============================================================================
-- 4. DOCUMENTAÇÃO PARA FRONTEND (Referência)
-- ==============================================================================
/*
COMO INSERIR DADOS CORRETAMENTE:

1. CLIENTE (Exemplo de Payload):
{
  "name": "Pizzaria do João",
  "system": "winfood", -- 'winfood' ou 'cplug'
  "status": "active",  -- 'active', 'inactive', 'implantation'
  "user_id": "uuid-do-usuario-logado",
  
  -- Integrações (JSON Array)
  "integrations": [
    { 
      "id": "uuid-gerado-no-front",
      "type": "anydesk", 
      "access": "123 456 789", 
      "password": "senha-opcional" 
    },
    {
      "id": "uuid-gerado-no-front",
      "type": "ifood",
      "username": "PDV.LOJA",
      "password": "senha-portal"
    }
  ],
  
  -- Contato (JSON Array)
  "contact_info": [
    { "type": "whatsapp", "value": "11999999999", "name": "João Dono" },
    { "type": "email", "value": "financeiro@pizzaria.com" }
  ]
}

2. VALIDAÇÃO JSONB:
O banco aceita qualquer JSON válido, mas o Frontend (TypeScript) DEVE garantir
que os campos 'type', 'id' e valores específicos existam antes de salvar.

*/
