import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:blur/blur.dart'; // For blur effect

class ChatDetailView extends StatefulWidget {
  final String recipientUid;
  final String recipientName;
  final String currentUserId;
  final bool isDarkMode;
  final String profilePic;

  const ChatDetailView({
    super.key,
    required this.recipientUid,
    required this.currentUserId,
    required this.recipientName,
    required this.isDarkMode,
    required this.profilePic,
  });

  @override
  _ChatDetailViewState createState() => _ChatDetailViewState();
}

class _ChatDetailViewState extends State<ChatDetailView> {
  final TextEditingController _messageController = TextEditingController();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();

  String get _chatId {
    return widget.currentUserId.hashCode <= widget.recipientUid.hashCode
        ? '${widget.currentUserId}_${widget.recipientUid}'
        : '${widget.recipientUid}_${widget.currentUserId}';
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      final message = {
        'text': _messageController.text,
        'createdAt': DateTime
            .now()
            .millisecondsSinceEpoch,
        'userId': widget.currentUserId,
        'isRead': false,
      };
      _database.child('chats/$_chatId/messages').push().set(message);
      _messageController.clear();

      _updateUnreadCount();
    }
  }

  Future<void> _updateUnreadCount() async {
    try {
      await _firestore.collection('users').doc(widget.recipientUid).update({
        'unreadMessages': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error updating unread messages count: $e');
    }
  }

  Future<void> _markMessagesAsRead() async {
    try {
      final messagesSnapshot = await _database
          .child('chats/$_chatId/messages')
          .orderByChild('isRead')
          .equalTo(false)
          .once();

      final messages = messagesSnapshot.snapshot.value as Map?;
      if (messages != null) {
        for (var key in messages.keys) {
          if (messages[key]['userId'] == widget.recipientUid) {
            await _database.child('chats/$_chatId/messages/$key').update(
                {'isRead': true});
          }
        }

        await _firestore.collection('users').doc(widget.recipientUid).update({
          'unreadMessages': FieldValue.increment(-1),
        });
      }
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _markMessagesAsRead();
  }

  String _formatTimestamp(int millisecondsSinceEpoch) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(
        millisecondsSinceEpoch);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return DateFormat('MMM d').format(dateTime);
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _showAvatarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          Dialog(
            backgroundColor: Colors.transparent,
            child: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                      )
                  ),
                ),
                Center(
                  child: Hero(
                    tag: 'profilePic',
                    child: CircleAvatar(
                      radius: 100,
                      backgroundImage: NetworkImage(widget.profilePic),
                    ),

                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.isDarkMode ? Colors.black : Color(
        0xFFBD76FD);
    final messageColor = widget.isDarkMode ? const Color(0xFFBD76FD) : Color(
        0xffffffff);
    final textColorSent = widget.isDarkMode ? Colors.white : Colors.black;


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => _showAvatarDialog(context),
              child: Hero(
                tag: 'profilePic',
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.profilePic),
                  radius: 22,
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(widget.recipientName, style: Theme
                .of(context)
                .textTheme
                .bodyLarge,
            ),
          ],
        ),
        backgroundColor: widget.isDarkMode ? Colors.black : Color(0xFFBD76FD),
      ),
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          SizedBox(height: 8), // Add spacing here
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: _database
                  .child('chats/$_chatId/messages')
                  .orderByChild('createdAt')
                  .onValue,
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData ||
                    snapshot.data!.snapshot.value == null) {
                  return Center(
                    child: Text(
                      'No messages yet.',
                      style: TextStyle(
                          color: widget.isDarkMode ? Colors.white : Colors
                              .black),
                    ),
                  );
                }

                final messages = Map<String, dynamic>.from(
                    snapshot.data!.snapshot.value as Map);
                final sortedMessages = messages.entries.toList()
                  ..sort((a, b) =>
                      a.value['createdAt'].compareTo(b.value['createdAt']));

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollController.jumpTo(
                      _scrollController.position.maxScrollExtent);
                });

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: sortedMessages.length,
                  itemBuilder: (ctx, index) {
                    final messageData = sortedMessages[index].value;
                    final isSentByCurrentUser = messageData['userId'] ==
                        widget.currentUserId;

                    return Align(
                      alignment: isSentByCurrentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: IntrinsicWidth(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery
                                .of(context)
                                .size
                                .width * 0.75,
                            minWidth: 50.0,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          margin: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: messageColor,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Text(
                                    messageData['text'],
                                    maxLines: null,
                                    style: TextStyle(
                                        fontFamily: widget.isDarkMode
                                            ? GoogleFonts
                                            .playfairDisplay()
                                            .fontFamily : GoogleFonts
                                            .satisfy()
                                            .fontFamily,
                                        letterSpacing: 1,
                                        fontSize: 20,
                                        color: textColorSent
                                    )

                                ),
                              ),
                              SizedBox(width: 8),

                              Text(
                                _formatTimestamp(messageData['createdAt']),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: textColorSent.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      controller: _messageController,
                      maxLines: null,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        hintText: 'Send a message...',
                        hintStyle: TextStyle(
                          color: widget.isDarkMode ? Colors.white54 : Colors
                              .black54,
                        ),
                      ),
                      style: TextStyle(
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                        fontSize: 20
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  backgroundColor: widget.isDarkMode ? Colors.white : Color(
                      0xFFD2ACF8),
                  child: Icon(Icons.send, color: Colors.black),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}