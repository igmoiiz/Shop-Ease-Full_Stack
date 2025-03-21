import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'consts.dart';

void main() async {
  // Initialize Supabase
  await Supabase.initialize(url: url, anonKey: anonKey);
  final supabase = Supabase.instance.client;

  try {
    // Create chat_history table
    final createChatHistoryTable = await supabase.rpc(
      'create_chat_history_table',
      params: {},
    );
    log('Creating chat_history table: ${createChatHistoryTable ?? "Success"}');

    // Create chat_messages table
    final createChatMessagesTable = await supabase.rpc(
      'create_chat_messages_table',
      params: {},
    );
    log(
      'Creating chat_messages table: ${createChatMessagesTable ?? "Success"}',
    );

    log('Database setup completed successfully!');
  } catch (e) {
    log('Error setting up database: $e');
  }
}
