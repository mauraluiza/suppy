-- 1. Padronizar colunas created_at e updated_at
-- Tabela: CLIENTS
ALTER TABLE clients ADD COLUMN IF NOT EXISTS created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();
ALTER TABLE clients ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();

-- Garantir DEFAULT NOW (caso a coluna já exista mas sem default)
ALTER TABLE clients ALTER COLUMN created_at SET DEFAULT NOW();
ALTER TABLE clients ALTER COLUMN updated_at SET DEFAULT NOW();

-- Tabela: TASKS
ALTER TABLE tasks ADD COLUMN IF NOT EXISTS created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();
ALTER TABLE tasks ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();

-- Garantir DEFAULT NOW
ALTER TABLE tasks ALTER COLUMN created_at SET DEFAULT NOW();
ALTER TABLE tasks ALTER COLUMN updated_at SET DEFAULT NOW();

-- Tabela: NOTES (Usada pelo sistema como Informações Gerais)
ALTER TABLE notes ADD COLUMN IF NOT EXISTS created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();
ALTER TABLE notes ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();

-- Garantir DEFAULT NOW
ALTER TABLE notes ALTER COLUMN created_at SET DEFAULT NOW();
ALTER TABLE notes ALTER COLUMN updated_at SET DEFAULT NOW();

-- 2. Criar ou Atualizar Função Global de Trigger
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 3. Criar Triggers (Drop para evitar duplicação e recriação)

-- Trigger para CLIENTS
DROP TRIGGER IF EXISTS set_updated_at_clients ON clients;
CREATE TRIGGER set_updated_at_clients
BEFORE UPDATE ON clients
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Trigger para TASKS
DROP TRIGGER IF EXISTS set_updated_at_tasks ON tasks;
CREATE TRIGGER set_updated_at_tasks
BEFORE UPDATE ON tasks
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Trigger para NOTES
DROP TRIGGER IF EXISTS set_updated_at_notes ON notes;
CREATE TRIGGER set_updated_at_notes
BEFORE UPDATE ON notes
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();
