// ignore_for_file: deprecated_member_use, invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:auth_screens/Controllers/API%20Services/Chatbot/chat_bot_controller.dart';
import 'package:auth_screens/Controllers/input_controllers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  // INSTANCE FOR INPUT CONTROLLERS
  final InputControllers inputControllers = InputControllers();
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

  @override
  Widget build(BuildContext context) {
    final chatbotController = Provider.of<ChatbotController>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,

      endDrawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.yellow.shade700,
                image: DecorationImage(
                  image: AssetImage('assets/images/drawer_header_bg.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.6),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "QUORION",
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2,
                      fontSize: height * 0.03,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.cinzel().fontFamily,
                    ),
                  ),
                  Text(
                    "AI Assistant",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: height * 0.018,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                ],
              ),
            ),
            // Add drawer items here
          ],
        ),
      ),
      //  APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.yellow.shade800),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.yellow.shade800.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.psychology, color: Colors.yellow.shade800),
            ),
            SizedBox(width: 10),
            Text(
              "Quorion".toUpperCase(),
              style: TextStyle(
                color: Colors.yellow.shade800,
                letterSpacing: 1.5,
                fontSize: height * 0.025,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.cinzel().fontFamily,
              ),
            ),
          ],
        ),
      ),
      //  BODY
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatbotController>(
              builder: (context, chatbotController, child) {
                return ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16.0),
                  itemCount: chatbotController.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatbotController.messages[index];
                    final isUser = message["sender"] == "user";
                    return Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(maxWidth: width * 0.75),
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color:
                              isUser
                                  ? Colors.green.shade700
                                  : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                          border:
                              isUser
                                  ? null
                                  : Border.all(
                                    color: Colors.yellow.shade800.withOpacity(
                                      0.3,
                                    ),
                                    width: 1,
                                  ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isUser)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.psychology,
                                      size: 16,
                                      color: Colors.yellow.shade800,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "QUORION",
                                      style: TextStyle(
                                        color: Colors.yellow.shade800,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily:
                                            GoogleFonts.outfit().fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Text(
                              message["text"]!,
                              style: TextStyle(
                                color: isUser ? Colors.white : Colors.black,
                                fontSize: 16.0,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                "12:30 PM", // You can replace with actual timestamp
                                style: TextStyle(
                                  color:
                                      isUser
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                  fontSize: 10.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.yellow.shade800.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: inputControllers.messageController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                      ),
                      decoration: InputDecoration(
                        hintText: "Ask me anything...",
                        hintStyle: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        suffixIcon:
                            chatbotController.isLoading
                                ? Container(
                                  width: 24,
                                  height: 24,
                                  padding: EdgeInsets.all(6),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.yellow.shade800,
                                    ),
                                  ),
                                )
                                : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade700, Colors.green.shade900],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () async {
                      if (inputControllers.messageController.text.isNotEmpty) {
                        chatbotController.isLoading =
                            true; // Show loading indicator
                        chatbotController.notifyListeners();

                        await chatbotController.fetchResponse(
                          inputControllers.messageController.text,
                        );

                        inputControllers.messageController
                            .clear(); // Clear input field after sending
                        chatbotController
                            .scrollToBottom(); // Scroll to bottom after sending
                        scrollToBottom();
                      }
                    },
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
