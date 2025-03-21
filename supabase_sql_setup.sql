-- Function to create chat_history table
CREATE OR REPLACE FUNCTION create_chat_history_table()
RETURNS void AS $$
BEGIN
  -- Create chat_history table if it doesn't exist
  CREATE TABLE IF NOT EXISTS chat_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    title TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    message_count INTEGER DEFAULT 0,
    last_message TEXT
  );

  -- Set up RLS policy for chat_history
  ALTER TABLE chat_history ENABLE ROW LEVEL SECURITY;
  
  -- Allow users to access only their own chats
  CREATE POLICY "Users can only access their own chats"
    ON chat_history
    FOR ALL
    USING (auth.uid() = user_id);
    
  -- Create indexes for performance
  CREATE INDEX IF NOT EXISTS idx_chat_history_user_id ON chat_history(user_id);
  CREATE INDEX IF NOT EXISTS idx_chat_history_updated_at ON chat_history(updated_at);
END;
$$ LANGUAGE plpgsql;

-- Function to create chat_messages table
CREATE OR REPLACE FUNCTION create_chat_messages_table()
RETURNS void AS $$
BEGIN
  -- Create chat_messages table if it doesn't exist
  CREATE TABLE IF NOT EXISTS chat_messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chat_id UUID NOT NULL REFERENCES chat_history(id) ON DELETE CASCADE,
    sender TEXT NOT NULL,
    text TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
  );

  -- Set up RLS policy for chat_messages
  ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;
  
  -- Allow users to access only messages from their own chats
  CREATE POLICY "Users can only access messages from their own chats"
    ON chat_messages
    FOR ALL
    USING (
      EXISTS (
        SELECT 1 FROM chat_history
        WHERE chat_history.id = chat_messages.chat_id
        AND chat_history.user_id = auth.uid()
      )
    );
    
  -- Create indexes for performance
  CREATE INDEX IF NOT EXISTS idx_chat_messages_chat_id ON chat_messages(chat_id);
  CREATE INDEX IF NOT EXISTS idx_chat_messages_created_at ON chat_messages(created_at);
END;
$$ LANGUAGE plpgsql; 