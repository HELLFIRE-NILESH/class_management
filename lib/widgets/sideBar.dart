import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Sidebar extends StatelessWidget {
  final double height;
  final double width;
  final bool isSidebarExpanded;
  final int selectedIndex;
  final Function(int) onIconTap;
  final Function() onToggleSidebar;
  final bool isDarkmode;

  const Sidebar({
    super.key,
    required this.height,
    required this.width,
    required this.isSidebarExpanded,
    required this.selectedIndex,
    required this.onIconTap,
    required this.onToggleSidebar,
    required this.isDarkmode,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isSidebarExpanded ? 200 : 70,
      height: screenHeight * 0.390,
      decoration: BoxDecoration(
        color: isDarkmode ? const Color(0xFF000000) : const Color(0xFFBD76FD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Always start-aligned
          children: [
            _buildSidebarItem(
              iconPath: "assets/images/icons/notesLogo.png",
              label: "Notes",
              index: 0,
            ),
            const SizedBox(height: 20),
            _buildSidebarItem(
              iconPath: "assets/images/icons/chatLogo.png",
              label: "Chat",
              index: 1,
            ),
            const SizedBox(height: 20),
            _buildSidebarItem(
              iconPath: "assets/images/icons/sylabusLogo.png",
              label: "Syllabus",
              index: 2,
            ),
            const SizedBox(height: 20),
            _buildSidebarItem(
              iconPath: "assets/images/icons/sylabusLogo.png",
              label: "More",
              index: 3,
            ),
            const SizedBox(height: 10),
            const Spacer(),
            GestureDetector(
              onTap: onToggleSidebar,
              child: Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  isSidebarExpanded ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
                  size: width *0.083,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarItem({
    required String iconPath,
    required String label,
    required int index,
  }) {
    return InkWell(
      onTap: () => onIconTap(index),
      child: Row(

        children: [
          Center(
            child: Padding(
              padding:  const EdgeInsets.fromLTRB(3,0,0,0),
              child: Image.asset(
                iconPath,
                height: width *0.083,
                width: width *0.083,
                color: selectedIndex == index ? Colors.white : Colors.white.withOpacity(0.7),
              ),
            ),
          ),
          if (isSidebarExpanded)
            Flexible(
              child: Padding(
                padding:  const EdgeInsets.fromLTRB(20,0,0,0),
                child: Text(
                  label,
                  style: TextStyle(
                    color: selectedIndex == index ? Colors.white : Colors.white.withOpacity(0.7),
                    fontFamily: isDarkmode ? GoogleFonts.playfairDisplay().fontFamily
                    : GoogleFonts.satisfy().fontFamily ,
                    fontSize: isDarkmode ? 18 : 22,


                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
      ),
      );
  }
}
