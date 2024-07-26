import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoteView extends StatefulWidget {
  final bool isDarkMode;

  const NoteView({super.key, required this.isDarkMode});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  final List<String> subjects = [
    "Operating System",
    "Computer Network",
    "Web Technology",
    "Software Engineering",
    "Dbms",
  ];

  void _onSubjectTap(String subject) {
    // Handle the subject tap here
    print('Tapped on $subject');
  }

  @override
  Widget build(BuildContext context) {
     TextStyle subjectTextStyle = TextStyle(
      fontFamily: widget.isDarkMode ? GoogleFonts.playfairDisplay().fontFamily
          : GoogleFonts.satisfy().fontFamily ,
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
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              InkWell(
                onTap: () => _onSubjectTap(subjects[index]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          subjects[index],
                          style: subjectTextStyle,
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
