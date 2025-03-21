// ignore_for_file: deprecated_member_use, invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:auth_screens/Controllers/API%20Services/Chatbot/chat_bot_controller.dart';
import 'package:auth_screens/Controllers/input_controllers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    super.initState();
    // Initialize chat history when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatbotController = Provider.of<ChatbotController>(
        context,
        listen: false,
      );
      chatbotController.initialize();
    });
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

  @override
  Widget build(BuildContext context) {
    final chatbotController = Provider.of<ChatbotController>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,

      endDrawer: _buildChatHistoryDrawer(context, chatbotController, height),
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
              "Shop Ease".toUpperCase(),
              style: TextStyle(
                color: Colors.yellow.shade800,
                letterSpacing: 1.5,
                fontSize: height * 0.025,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.playfairDisplay().fontFamily,
              ),
            ),
          ],
        ),
        actions: [
          // New chat button
          IconButton(
            icon: Icon(Icons.add_comment_rounded),
            onPressed: () {
              chatbotController.createNewChat();
            },
          ),
          // End drawer button
          Builder(
            builder:
                (context) => IconButton(
                  icon: Icon(Icons.history_sharp),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
          ),
        ],
      ),
      //  BODY
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatbotController>(
              builder: (context, chatbotController, child) {
                // Reverse the order of displayed messages for proper chronological display
                final displayMessages = List.from(
                  chatbotController.messages.reversed,
                );
                return ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16.0),
                  itemCount: displayMessages.length,
                  // Using reverse here to display oldest messages at bottom
                  reverse: true,
                  itemBuilder: (context, index) {
                    final message = displayMessages[index];
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
                                      "Shop Ease",
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
                            // Use Markdown widget for bot responses, and regular Text for user messages
                            isUser
                                ? Text(
                                  message["text"]!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                  ),
                                )
                                : MarkdownBody(
                                  data: message["text"]!,
                                  styleSheet: MarkdownStyleSheet(
                                    p: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                    ),
                                    strong: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                    ),
                                    em: TextStyle(
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 16.0,
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                    ),
                                    code: TextStyle(
                                      color: Colors.black87,
                                      backgroundColor: Colors.grey.shade200,
                                      fontFamily:
                                          GoogleFonts.robotoMono().fontFamily,
                                      fontSize: 15.0,
                                    ),
                                    codeblockDecoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                _formatTimestamp(message["timestamp"] ?? ""),
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
                        chatbotController.isLoading = true;
                        chatbotController.notifyListeners();

                        await chatbotController.fetchResponse(
                          inputControllers.messageController.text,
                        );

                        inputControllers.messageController.clear();
                        chatbotController.scrollToBottom();
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

  Widget _buildChatHistoryDrawer(
    BuildContext context,
    ChatbotController chatbotController,
    double height,
  ) {
    return Drawer(
      backgroundColor: Colors.grey.shade50,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.yellow.shade700, Colors.yellow.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: DrawerHeader(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.psychology,
                        size: 28,
                        color: Colors.grey.shade900.withOpacity(0.8),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Shop Ease",
                        style: TextStyle(
                          color: Colors.grey.shade900.withOpacity(0.8),
                          letterSpacing: 2,
                          fontSize: height * 0.03,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Conversation History",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: height * 0.018,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Chat count display
          Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Your Conversations",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: GoogleFonts.outfit().fontFamily,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade800.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${chatbotController.chatHistories.length}",
                    style: TextStyle(
                      color: Colors.yellow.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Chat History List
          Expanded(
            child:
                chatbotController.chatHistories.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_outlined,
                            size: 48,
                            color: Colors.grey.shade300,
                          ),
                          SizedBox(height: 12),
                          Text(
                            "No previous conversations",
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: GoogleFonts.outfit().fontFamily,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Tap + to start a new chat",
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontFamily: GoogleFonts.outfit().fontFamily,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      itemCount: chatbotController.chatHistories.length,
                      padding: EdgeInsets.only(top: 4),
                      itemBuilder: (context, index) {
                        final chat = chatbotController.chatHistories[index];
                        final isActive =
                            chat['id'] == chatbotController.currentChatId;
                        final messageCount = chat['message_count'] ?? 0;

                        return Dismissible(
                          key: Key(chat['id']),
                          background: Container(
                            color: Colors.red.shade400,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.delete, color: Colors.white),
                                SizedBox(height: 4),
                                Text(
                                  "Delete",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm Delete'),
                                  content: Text(
                                    'Are you sure you want to delete this conversation?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () =>
                                              Navigator.of(context).pop(false),
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(context).pop(true),
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          onDismissed: (direction) {
                            chatbotController.deleteChat(chat['id']);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isActive
                                      ? Colors.yellow.shade50
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    isActive
                                        ? Colors.yellow.shade700
                                        : Colors.grey.shade200,
                                width: isActive ? 1.5 : 1,
                              ),
                              boxShadow:
                                  isActive
                                      ? [
                                        BoxShadow(
                                          color: Colors.yellow.shade200
                                              .withOpacity(0.5),
                                          blurRadius: 8,
                                          offset: Offset(0, 2),
                                        ),
                                      ]
                                      : [
                                        BoxShadow(
                                          color: Colors.grey.shade200,
                                          blurRadius: 3,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  chatbotController.loadChat(chat['id']);
                                  Navigator.pop(context); // Close drawer
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color:
                                              isActive
                                                  ? Colors.yellow.shade700
                                                      .withOpacity(0.2)
                                                  : Colors.grey.shade100,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.chat_outlined,
                                          size: 18,
                                          color:
                                              isActive
                                                  ? Colors.yellow.shade800
                                                  : Colors.grey.shade600,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              chat['title'] ?? 'Untitled',
                                              style: TextStyle(
                                                fontWeight:
                                                    isActive
                                                        ? FontWeight.bold
                                                        : FontWeight.w500,
                                                color:
                                                    isActive
                                                        ? Colors.yellow.shade800
                                                        : Colors.black87,
                                                fontFamily:
                                                    GoogleFonts.outfit()
                                                        .fontFamily,
                                                fontSize: 15,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 2),
                                            chat['lastMessage'] != null
                                                ? Text(
                                                  chat['lastMessage'],
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )
                                                : Text(
                                                  "Tap to open chat",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey.shade400,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          PopupMenuButton(
                                            icon: Icon(
                                              Icons.more_vert,
                                              color:
                                                  isActive
                                                      ? Colors.yellow.shade800
                                                      : Colors.grey.shade600,
                                              size: 20,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            itemBuilder:
                                                (context) => [
                                                  PopupMenuItem(
                                                    value: 'rename',
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.edit,
                                                          size: 18,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text('Rename'),
                                                      ],
                                                    ),
                                                  ),
                                                  PopupMenuItem(
                                                    value: 'delete',
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.delete,
                                                          size: 18,
                                                          color: Colors.red,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                            onSelected: (value) {
                                              if (value == 'rename') {
                                                _showRenameDialog(
                                                  context,
                                                  chatbotController,
                                                  chat['id'],
                                                  chat['title'],
                                                );
                                              } else if (value == 'delete') {
                                                chatbotController.deleteChat(
                                                  chat['id'],
                                                );
                                              }
                                            },
                                          ),
                                          if (messageCount > 0)
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 6,
                                                vertical: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                color:
                                                    isActive
                                                        ? Colors.yellow.shade700
                                                        : Colors.grey.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                '$messageCount',
                                                style: TextStyle(
                                                  color:
                                                      isActive
                                                          ? Colors.white
                                                          : Colors
                                                              .grey
                                                              .shade700,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(
    BuildContext context,
    ChatbotController controller,
    String chatId,
    String currentTitle,
  ) {
    final TextEditingController titleController = TextEditingController(
      text: currentTitle,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.edit_note, color: Colors.yellow.shade800, size: 28),
                SizedBox(width: 10),
                Text(
                  'Rename Conversation',
                  style: TextStyle(
                    fontFamily: GoogleFonts.outfit().fontFamily,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.yellow.shade800,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter a new title for this conversation:',
                  style: TextStyle(
                    fontFamily: GoogleFonts.outfit().fontFamily,
                    color: Colors.grey.shade700,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter a new title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.yellow.shade800,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.chat_outlined,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  autofocus: true,
                  style: TextStyle(
                    fontFamily: GoogleFonts.outfit().fontFamily,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey.shade700,
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: GoogleFonts.outfit().fontFamily,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow.shade700,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onPressed: () {
                  if (titleController.text.isNotEmpty) {
                    controller.renameChat(chatId, titleController.text);
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'Rename',
                  style: TextStyle(
                    fontFamily: GoogleFonts.outfit().fontFamily,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
            actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
    );
  }

  String _formatTimestamp(String timestamp) {
    if (timestamp.isEmpty) return "";

    try {
      final DateTime dateTime = DateTime.parse(timestamp);
      final DateTime now = DateTime.now();
      final DateTime today = DateTime(now.year, now.month, now.day);
      final DateTime yesterday = today.subtract(const Duration(days: 1));
      final DateTime messageDate = DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
      );

      // Format for time only (hours and minutes)
      final String timeFormat = DateFormat.jm().format(
        dateTime,
      ); // e.g., "2:30 PM"

      if (messageDate == today) {
        // Today - just show time
        return "Today, $timeFormat";
      } else if (messageDate == yesterday) {
        // Yesterday - show "Yesterday" and time
        return "Yesterday, $timeFormat";
      } else {
        // Other days - show full date and time
        return DateFormat(
          'MMM d, yyyy',
        ).add_jm().format(dateTime); // e.g., "Jan 1, 2023, 2:30 PM"
      }
    } catch (e) {
      // If there's an error parsing the timestamp, return it as is
      return timestamp;
    }
  }
}
