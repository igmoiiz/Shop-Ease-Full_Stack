import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'chat_history_service.dart';

class ChatbotController extends ChangeNotifier {
  //  API KEY and RESPONSE TEXT
  final String apiKey =
      'AIzaSyBwEMqDZsa6oVX6PvEV_uRW2XwrytbvgL4'; // Move to secure storage

  String responseText = '';

  //  LOADING VARIABLE
  bool isLoading = false;

  //  SCROLL CONTROLLER
  final ScrollController scrollController = ScrollController();

  // Chat history service
  final ChatHistoryService _chatHistoryService = ChatHistoryService();

  // Current active chat ID
  String? _currentChatId;
  String? get currentChatId => _currentChatId;

  // List of chat histories
  List<Map<String, dynamic>> chatHistories = [];

  // Load chat histories
  Future<void> loadChatHistories() async {
    try {
      chatHistories = await _chatHistoryService.getUserChats();
      notifyListeners();
    } catch (e) {
      log('Error loading chat histories: $e');
    }
  }

  // Create a new chat and set it as current
  Future<void> createNewChat() async {
    try {
      // First message will be used as title
      final initialTitle = "New conversation";
      _currentChatId = await _chatHistoryService.createNewChat(initialTitle);
      messages = [];
      notifyListeners();

      // Refresh chat histories
      await loadChatHistories();
    } catch (e) {
      log('Error creating new chat: $e');
    }
  }

  // Load a specific chat
  Future<void> loadChat(String chatId) async {
    try {
      _currentChatId = chatId;
      final chatMessages = await _chatHistoryService.getChatMessages(chatId);
      messages = chatMessages;
      notifyListeners();
    } catch (e) {
      log('Error loading chat: $e');
    }
  }

  // Delete a chat
  Future<void> deleteChat(String chatId) async {
    try {
      await _chatHistoryService.deleteChat(chatId);

      // If deleting current chat, create a new one
      if (chatId == _currentChatId) {
        await createNewChat();
      } else {
        // Otherwise just refresh the list
        await loadChatHistories();
      }
    } catch (e) {
      log('Error deleting chat: $e');
    }
  }

  // Rename a chat
  Future<void> renameChat(String chatId, String newTitle) async {
    try {
      await _chatHistoryService.renameChat(chatId, newTitle);
      await loadChatHistories();
    } catch (e) {
      log('Error renaming chat: $e');
    }
  }

  //  METHOD TO SCROLL TO THE BOTTOM
  void scrollToBottom() {
    if (scrollController.hasClients) {
      Future.delayed(Duration(milliseconds: 300), () {
        scrollController.animateTo(
          0, // For reversed ListView, 0 is the "bottom" (most recent messages)
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  //  LIST FOR MESSAGES
  List<Map<String, String>> messages = [];

  //  METHOD TO FETCH THE RESPONSE
  Future<void> fetchResponse(String message) async {
    log(message);
    try {
      // Ensure we have a current chat
      if (_currentChatId == null) {
        await createNewChat();
      }

      // Add user message to local state with timestamp
      final timestamp = DateTime.now().toIso8601String();
      final userMessage = {
        "sender": "user",
        "text": message,
        "timestamp": timestamp,
      };
      messages.add(userMessage);
      isLoading = true;
      notifyListeners();

      // Save message to database
      await _chatHistoryService.saveMessage(_currentChatId!, userMessage);

      //  scroll to bottom
      scrollToBottom();
      final url = Uri.parse(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey",
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": message},
              ],
            },
          ],
          "generationConfig": {
            "temperature": 0.7,
            "topK": 40,
            "topP": 0.95,
            "maxOutputTokens": 1024,
          },
        }),
      );

      if (response.statusCode == 200) {
        // Check for successful response
        final data = jsonDecode(response.body);
        responseText =
            data["candidates"]?[0]["content"]?["parts"]?[0]["text"] ??
            "No response received";
        isLoading = false;

        // Clean up the response for markdown display
        responseText = _cleanMarkdownText(responseText);

        // Add bot response to local state with timestamp
        final timestamp = DateTime.now().toIso8601String();
        final botMessage = {
          "sender": "bot",
          "text": responseText,
          "timestamp": timestamp,
        };
        messages.add(botMessage);
        notifyListeners();

        // Save bot response to database
        await _chatHistoryService.saveMessage(_currentChatId!, botMessage);

        // Update chat title if this is the first message
        if (messages.length == 2) {
          // Extract a title from the first user message
          String title =
              message.length > 30 ? message.substring(0, 27) + '...' : message;
          await renameChat(_currentChatId!, title);
        }
      } else {
        final errorMessage = {
          "sender": "bot",
          "text": "Error: ${response.body}",
        };
        messages.add(errorMessage);
        isLoading = false;
        responseText = "Error: ${response.body}";
        notifyListeners();

        // Save error message to database
        await _chatHistoryService.saveMessage(_currentChatId!, errorMessage);
      }
    } catch (error) {
      final errorMessage = {
        "sender": "bot",
        "text": "Failed to connect. Please try again.",
      };
      messages.add(errorMessage);
      log(error.toString());
      isLoading = false;

      if (_currentChatId != null) {
        await _chatHistoryService.saveMessage(_currentChatId!, errorMessage);
      }

      scrollToBottom();
      notifyListeners();
    }
  }

  // Helper method to clean and format markdown text
  String _cleanMarkdownText(String text) {
    // Make sure asterisks for bold/italic have proper spacing
    final cleanedText = text
        // Ensure code blocks are properly formatted
        .replaceAllMapped(
          RegExp(r'```([^`]+)```', dotAll: true),
          (match) => '\n```\n${match.group(1)!.trim()}\n```\n',
        )
        // Ensure inline code is properly formatted
        .replaceAllMapped(
          RegExp(r'`([^`]+)`'),
          (match) => '`${match.group(1)!.trim()}`',
        )
        // Ensure lists work properly
        .replaceAll(RegExp(r'^- ', multiLine: true), '- ')
        // Keep numbered lists as is - we don't need to modify them
        // Make sure bold formatting works
        .replaceAll(RegExp(r'\*\*([^*]+)\*\*'), r'**$1**')
        // Ensure proper spacing for headers
        .replaceAll(RegExp(r'^#([^#])', multiLine: true), r'# $1');

    return cleanedText;
  }

  // Initialize controller - call this when the chat page loads
  Future<void> initialize() async {
    await loadChatHistories();

    // If we have previous chats, load the most recent one
    if (chatHistories.isNotEmpty) {
      await loadChat(chatHistories[0]['id']);
    } else {
      // Otherwise create a new chat
      await createNewChat();
    }
  }
}
