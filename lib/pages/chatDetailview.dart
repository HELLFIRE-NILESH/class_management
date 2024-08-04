import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // For date formatting

class ChatDetailView extends StatefulWidget {
  final String recipientUid;
  final String recipientName;
  final String currentUserId;
  final bool isDarkMode;

  const ChatDetailView({
    super.key,
    required this.recipientUid,
    required this.currentUserId,
    required this.recipientName,
    required this.isDarkMode,
  });

  @override
  _ChatDetailViewState createState() => _ChatDetailViewState();
}

class _ChatDetailViewState extends State<ChatDetailView> {
  final TextEditingController _messageController = TextEditingController();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
        'createdAt': DateTime.now().millisecondsSinceEpoch,
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
      final recipientDoc = await _firestore.collection('users').doc(widget.recipientUid).get();
      final recipientData = recipientDoc.data() as Map<String, dynamic>?;

      int currentUnreadMessages = recipientData?['unreadMessages'] ?? 0;
      if (currentUnreadMessages < 0) currentUnreadMessages = 0;

      await _firestore.collection('users').doc(widget.recipientUid).update({
        'unreadMessages': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error updating unread messages count: $e');
    }
  }

  Future<void> _markMessagesAsRead() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      try {
        final messagesSnapshot = await _database.child('chats/$_chatId/messages')
            .orderByChild('isRead')
            .equalTo(false)
            .once();

        final messages = messagesSnapshot.snapshot.value as Map?;
        if (messages != null) {
          bool hasUnreadMessages = false;

          for (var key in messages.keys) {
            if (messages[key]['userId'] == widget.recipientUid) {
              hasUnreadMessages = true;
              await _database.child('chats/$_chatId/messages/$key').update({'isRead': true});
            }
          }

          if (hasUnreadMessages) {
            final recipientDoc = await _firestore.collection('users').doc(widget.recipientUid).get();
            final recipientData = recipientDoc.data() as Map<String, dynamic>?;

            int currentUnreadMessages = recipientData?['unreadMessages'] ?? 0;
            if (currentUnreadMessages > 0) {
              await _firestore.collection('users').doc(widget.recipientUid).update({
                'unreadMessages': FieldValue.increment(-1),
              });
            }
          }
        }
      } catch (e) {
        print('Error marking messages as read: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _markMessagesAsRead();
  }

  String _formatTimestamp(int millisecondsSinceEpoch) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
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

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.isDarkMode ? Colors.black : Colors.white;
    final messageColorSent = widget.isDarkMode ? const Color(0xFFBD76FD) : const Color(0xFFDCC4FF);
    final messageColorReceived = widget.isDarkMode ? const Color(0xffe8e8e8) : const Color(0xFFBD76FD);
    final textColorSent = widget.isDarkMode ? Colors.white : Colors.black;
    final textColorReceived = widget.isDarkMode ? Colors.black : Colors.black87;
    final inputFieldColor = widget.isDarkMode ? Colors.grey[800] : Colors.grey[200];

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.recipientName}', style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black)),
        backgroundColor: widget.isDarkMode ? Colors.black : Colors.purple[300],
      ),
      backgroundColor: backgroundColor,
      body: Column(
          children: [
      Expanded(
      child: StreamBuilder<DatabaseEvent>(
          stream: _database.child('chats/$_chatId/messages').orderByChild('createdAt').onValue,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
          return Center(child: Text('No messages yet.', style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black)));
        }

        final messages = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
        final sortedMessages = messages.entries.toList()
          ..sort((a, b) => a.value['createdAt'].compareTo(b.value['createdAt']));

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });

        return ListView.builder(
          controller: _scrollController,
          itemCount: sortedMessages.length,
          itemBuilder: (ctx, index) {
            final messageData = sortedMessages[index].value;
            final isSentByCurrentUser = messageData['userId'] == widget.currentUserId;
            final isRead = messageData['isRead'] ?? false;

            return Align(
              alignment: isSentByCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: isSentByCurrentUser ? messageColorSent : messageColorReceived,
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
                    if (!isSentByCurrentUser)
                      CircleAvatar(
                        backgroundColor: messageColorReceived,
                        child: Text(widget.recipientName[0], style: TextStyle(color: Colors.white)),
                      ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: isSentByCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Text(
                            messageData['text'],
                            style: TextStyle(color: textColorSent),
                          ),
                          SizedBox(height: 5),
                          Text(
                            _formatTimestamp(messageData['createdAt']),
                            style: TextStyle(color: textColorSent.withOpacity(0.7), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    if (isSentByCurrentUser)
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(
                          isRead ? Icons.check_circle : Icons.check_circle_outline,
                          color: Colors.white,
                          size: 20,
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
    Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
    children: [
    Expanded(
    child: Container(
    decoration: BoxDecoration(
    color: inputFieldColor,
    borderRadius: BorderRadius.circular(5), // Normal corners
    ),
    child: TextField(
    controller: _messageController,
    decoration: InputDecoration(
    contentPadding: EdgeInsets.symmetric(horizontal: 16,
        vertical: 12),
      border: InputBorder.none, // Remove border
      hintText: 'Send a message...',
      hintStyle: TextStyle(color: widget.isDarkMode ? Colors.white54 : Colors.black54),
    ),
      style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black),
    ),
    ),
    ),
      SizedBox(width: 8),
      FloatingActionButton(
        backgroundColor: widget.isDarkMode ? Colors.white : Colors.purple[300],
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