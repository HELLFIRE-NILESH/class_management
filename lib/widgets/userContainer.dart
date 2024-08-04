import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';

class UserContainer extends StatefulWidget {
  final double height;
  final double width;
  final bool isDarkMode;

  const UserContainer({
    super.key,
    required this.height,
    required this.width,
    required this.isDarkMode,
  });

  @override
  _UserContainerState createState() => _UserContainerState();
}

class _UserContainerState extends State<UserContainer> {
  late Future<DocumentSnapshot> userDocument;

  @override
  void initState() {
    super.initState();
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userDocument = FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    } else {
      userDocument = Future.error('No user is signed in.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: userDocument,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data != null) {
          final data = snapshot.data!.data() as Map<String, dynamic>;

          return GestureFlipCard(
            axis: FlipAxis.vertical,
            animationDuration: const Duration(milliseconds: 300),
            frontWidget: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                image: widget.isDarkMode
                    ? const DecorationImage(
                    image: AssetImage("assets/images/carddark.jpg"),
                    fit: BoxFit.fill)
                    : const DecorationImage(
                    image: AssetImage("assets/images/card.jpg"),
                    fit: BoxFit.fill),
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    const CircleAvatar(
                      radius: 32,
                      backgroundImage: AssetImage("assets/images/pfp.jpg"),
                    ),
                    const SizedBox(height: 14),
                    Text(data['name'], style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 2),
                    Text(data['rollno'], style: Theme.of(context).textTheme.displayLarge),
                    const SizedBox(height: 3),
                    Text("${data['semester']}th Semester", style: Theme.of(context).textTheme.displaySmall),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            backWidget: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(40),
                image: widget.isDarkMode
                    ? const DecorationImage(
                    image: AssetImage("assets/images/carddark.jpg"),
                    fit: BoxFit.fill)
                    : const DecorationImage(
                    image: AssetImage("assets/images/card.jpg"),
                    fit: BoxFit.fill),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    Text("1st Semester     :  7.0", style: Theme.of(context).textTheme.displaySmall),
                    const SizedBox(height: 10),
                    Text("2nd Semester   :  7.1", style: Theme.of(context).textTheme.displaySmall),
                    const SizedBox(height: 10),
                    Text("3rd Semester    :  7.1", style: Theme.of(context).textTheme.displaySmall),
                    const SizedBox(height: 10),
                    Text("4th Semester    :  7.2", style: Theme.of(context).textTheme.displaySmall),
                    const SizedBox(height: 10),
                    Text("CGPA :  7.1", style: Theme.of(context).textTheme.displaySmall),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Center(child: Text('No user data found.'));
        }
      },
    );
  }
}
