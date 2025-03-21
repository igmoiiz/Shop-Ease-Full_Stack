import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatHistoryService {
  final _supabase = Supabase.instance.client;

  // Get current user ID
  String? get currentUserId => _supabase.auth.currentUser?.id;

  // Create a new chat
  Future<String> createNewChat(String title) async {
    try {
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      // Create a new chat document
      final response =
          await _supabase
              .from('chat_history')
              .insert({
                'user_id': currentUserId,
                'title': title.isEmpty ? 'New Conversation' : title,
                'created_at': DateTime.now().toIso8601String(),
                'updated_at': DateTime.now().toIso8601String(),
                'message_count': 0,
              })
              .select('id')
              .single();

      return response['id'].toString();
    } catch (e) {
      log('Error creating chat: $e');
      rethrow;
    }
  }

  // Get all chats for current user
  Future<List<Map<String, dynamic>>> getUserChats() async {
    try {
      if (currentUserId == null) {
        return [];
      }

      final response = await _supabase
          .from('chat_history')
          .select('*')
          .eq('user_id', currentUserId!)
          .order('updated_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      log('Error getting user chats: $e');
      return [];
    }
  }

  // Save a message to a specific chat
  Future<void> saveMessage(String chatId, Map<String, String> message) async {
    try {
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      // Use the timestamp from the message or generate a new one
      final timestamp =
          message['timestamp'] ?? DateTime.now().toIso8601String();

      // Add message to chat_messages table
      await _supabase.from('chat_messages').insert({
        'chat_id': chatId,
        'sender': message['sender'],
        'text': message['text'],
        'created_at': timestamp,
      });

      // Update the chat document
      await _supabase
          .from('chat_history')
          .update({
            'updated_at': timestamp,
            'message_count': await _getMessageCount(chatId) + 1,
            'last_message': message['text'],
          })
          .eq('id', chatId);
    } catch (e) {
      log('Error saving message: $e');
      rethrow;
    }
  }

  // Helper to get message count
  Future<int> _getMessageCount(String chatId) async {
    try {
      // Using count() method to get the total count
      final response = await _supabase
          .from('chat_messages')
          .select()
          .eq('chat_id', chatId);

      // Simply return the length of the response array
      return response.length;
    } catch (e) {
      log('Error getting message count: $e');
      return 0;
    }
  }

  // Load messages from a specific chat
  Future<List<Map<String, String>>> getChatMessages(String chatId) async {
    try {
      final response = await _supabase
          .from('chat_messages')
          .select('sender,text,created_at')
          .eq('chat_id', chatId)
          .order('created_at', ascending: true);

      return response.map<Map<String, String>>((message) {
        return {
          'sender': message['sender'] ?? '',
          'text': message['text'] ?? '',
          'timestamp':
              message['created_at'] ?? DateTime.now().toIso8601String(),
        };
      }).toList();
    } catch (e) {
      log('Error getting chat messages: $e');
      return [];
    }
  }

  // Delete a chat and its messages
  Future<void> deleteChat(String chatId) async {
    try {
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      // Delete messages first (foreign key constraint)
      await _supabase.from('chat_messages').delete().eq('chat_id', chatId);

      // Then delete the chat
      await _supabase.from('chat_history').delete().eq('id', chatId);
    } catch (e) {
      log('Error deleting chat: $e');
      rethrow;
    }
  }

  // Rename a chat
  Future<void> renameChat(String chatId, String newTitle) async {
    try {
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      await _supabase
          .from('chat_history')
          .update({'title': newTitle})
          .eq('id', chatId);
    } catch (e) {
      log('Error renaming chat: $e');
      rethrow;
    }
  }
}
