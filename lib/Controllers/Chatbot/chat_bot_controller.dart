import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatbotController extends ChangeNotifier {
  //  API KEY and RESPONSE TEXT
  final String apiKey =
      'AIzaSyBwEMqDZsa6oVX6PvEV_uRW2XwrytbvgL4'; // Move to secure storage

  String responseText = '';

  //  LOADING VARIABLE
  bool isLoading = false;

  //  SCROLL CONTROLLER
  final ScrollController scrollController = ScrollController();

  //  METHOD TO SCROLL TO THE BOTTOM
  void scrollToBottom() {
    if (scrollController.hasClients) {
      Future.delayed(Duration(milliseconds: 300), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
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
      messages.add({"sender": "user", "text": message});
      isLoading = true; // Set loading state

      notifyListeners();

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
        }),
      );

      if (response.statusCode == 200) {
        // Check for successful response

        final data = jsonDecode(response.body);
        responseText =
            data["candidates"]?[0]["content"]?["parts"]?[0]["text"] ??
            "No response received";
        isLoading = false; // Reset loading state

        messages.add({"sender": "bot", "text": responseText});
        notifyListeners();
      } else {
        messages.add({
          "sender": "bot",
          "text": "Error: ${response.body}",
        }); // Handle error response
        isLoading = false; // Reset loading state

        responseText = "Error: ${response.body}";
        notifyListeners();
      }
    } catch (error) {
      messages.add({
        "sender": "bot",
        "text": "Failed to connect. Please try again.",
      });
      log(error.toString());
      isLoading = false; // Reset loading state in case of error

      scrollToBottom();
      notifyListeners();
    }
  }
}
