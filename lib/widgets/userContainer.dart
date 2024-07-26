
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter/material.dart';

class UserContainer extends StatelessWidget {
  final double height;
  final double width;
  final String userName;
  final String userRollno;
  final int userSem;
  final bool isDarkMode;


  const UserContainer({
    super.key,
    required this.height,
    required this.width,
    required this.userName,
    required this.userRollno,
    required this.userSem,
    required this.isDarkMode,

  });

  @override
  Widget build(BuildContext context) {
    return GestureFlipCard(
      axis: FlipAxis.vertical,
      animationDuration: const Duration(milliseconds: 300),
      frontWidget: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          
          image: isDarkMode ? const DecorationImage(image: AssetImage("assets/images/carddark.jpg"),fit: BoxFit.fill) : const DecorationImage(image: AssetImage("assets/images/card.jpg"),fit: BoxFit.fill),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [

          ],
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
              Text(
                userName,
                style: Theme.of(context).textTheme.bodyLarge
              ),
              const SizedBox(height: 2),
              Text(
                userRollno,
                style: Theme.of(context).textTheme.displayLarge
              ),
              const SizedBox(height: 3),
              Text(
                "$userSem" "th Semester",
                  style: Theme.of(context).textTheme.displaySmall
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      backWidget: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(40),
          image: isDarkMode ? const DecorationImage(image: AssetImage("assets/images/carddark.jpg"),fit: BoxFit.fill) : const DecorationImage(image: AssetImage("assets/images/card.jpg"),fit: BoxFit.fill),

        ),
        child:  Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              Text(
                "1st Semester     :  7.0",
                  style: Theme.of(context).textTheme.displaySmall
              ),
              const SizedBox(height: 10),
              Text(
                "2nd Semester   :  7.1",
                  style: Theme.of(context).textTheme.displaySmall
              ),
              const SizedBox(height: 10),
              Text(
                "3rd Semester    :  7.1",
                  style: Theme.of(context).textTheme.displaySmall
              ),
              const SizedBox(height: 10),
              Text(
                "4th Semester    :  7.2",
                  style: Theme.of(context).textTheme.displaySmall
              ),
              const SizedBox(height: 10),
              Text(
                "CGPA :  7.1",
                  style: Theme.of(context).textTheme.displaySmall
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
