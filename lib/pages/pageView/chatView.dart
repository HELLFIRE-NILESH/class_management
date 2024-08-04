import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../chatDetailview.dart';
class ChatView extends StatefulWidget {
  final bool isDarkMode;

  const ChatView({super.key, required this.isDarkMode});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _onChatTap(String recipientUid) async {
    final currentUser = _auth.currentUser;

    if (currentUser != null) {
      try {
        DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(recipientUid).get();
        if (userSnapshot.exists) {
          final recipientName = userSnapshot['name'];

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetailView(
                isDarkMode: widget.isDarkMode,
                recipientUid: recipientUid,
                recipientName: recipientName,
                currentUserId: currentUser.uid,
                profilePic: userSnapshot["profilePic"],

              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User not found')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching user details: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle chatTextStyle = TextStyle(
      fontFamily: widget.isDarkMode
          ? GoogleFonts.playfairDisplay().fontFamily
          : GoogleFonts.satisfy().fontFamily,
      letterSpacing: widget.isDarkMode ? 0 : 1,
      fontSize: widget.isDarkMode ? 18 : 22,
    );

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? const Color(0xFF000000)
            : const Color(0xFFBD76FD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No users found.'));
          }

          final users = snapshot.data!.docs;
          final currentUser = _auth.currentUser;

          // Sort users based on unread messages in descending order
          final sortedUsers = users.where((user) => user.id != currentUser?.uid).toList();
          sortedUsers.sort((a, b) {
            final unreadA = (a.data() as Map<String, dynamic>)['unreadMessages'] ?? 0;
            final unreadB = (b.data() as Map<String, dynamic>)['unreadMessages'] ?? 0;
            return unreadB.compareTo(unreadA);
          });

          return ListView.builder(
            itemCount: sortedUsers.length,
            itemBuilder: (context, index) {
              final user = sortedUsers[index].data() as Map<String, dynamic>;

              final profilePicUrl = user['profilePic'];
              final unreadMessages = user['unreadMessages'] ?? 0;

              return Column(
                children: [
                  InkWell(
                    onTap: () => _onChatTap(user['uid']),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(profilePicUrl),
                            radius: 20,
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    user['name'],
                                    style: chatTextStyle,
                                  ),
                                ),
                              ],
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
          );
        },
      ),
    );
  }
}

