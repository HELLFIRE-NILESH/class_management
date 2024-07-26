import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatView extends StatefulWidget {
  final bool isDarkMode;

  const ChatView({super.key, required this.isDarkMode});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final List<Map<String, String>> chats = [
    {"name": "Alice", "profilePic": "assets/images/pfp.jpg"},
    {"name": "Bob", "profilePic": "assets/images/pfp.jpg"},
    {"name": "Charlie", "profilePic": "assets/images/pfp.jpg"},
    {"name": "David", "profilePic": "assets/images/pfp.jpg"},
    {"name": "Eve", "profilePic": "assets/images/pfp.jpg"},
  ];

  void _onChatTap(String name) {
    // Handle the chat tap here
    print('Tapped on $name');
  }

  @override
  Widget build(BuildContext context) {
    TextStyle chatTextStyle = TextStyle(
      fontFamily: widget.isDarkMode ? GoogleFonts.playfairDisplay().fontFamily : GoogleFonts.satisfy().fontFamily,
      letterSpacing: widget.isDarkMode ? 0 : 1,
      fontSize: widget.isDarkMode ? 18 : 22,
    );

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? const Color(0xFF000000) : const Color(0xFFBD76FD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: chats.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              InkWell(
                onTap: () => _onChatTap(chats[index]['name']!),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(chats[index]['profilePic']!),
                        radius: 20,
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          chats[index]['name']!,
                          style: chatTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                color: Colors.white54,
                thickness: 1.0,
              ),
            ],
          );
        },
      ),
    );
  }
}
