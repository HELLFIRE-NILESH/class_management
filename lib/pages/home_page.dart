import 'package:flutter/material.dart';
import '../widgets/searchBar.dart';
import '../widgets/sideBar.dart';
import '../widgets/userContainer.dart';
import 'pageView/chatView.dart';
import 'pageView/notesView.dart';

class HomePage extends StatefulWidget {

  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  const HomePage({super.key, required this.themeMode, required this.onToggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int _selectedIndex = 0;
  bool _isSidebarExpanded = false;


  @override
  void initState() {
    super.initState();
    _pageController = PageController()
      ..addListener(() {
        setState(() {
          _selectedIndex = _pageController.page?.round() ?? 0;
        });
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onIconTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.ease,
    );
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarExpanded = !_isSidebarExpanded;
    });
  }

  Future<bool> _onWillPop() async {
    // Close the app when back button is pressed
    return true;
  }

  @override
  Widget build(BuildContext context) {

    bool isDarkMode = widget.themeMode == ThemeMode.dark;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xffe8e8e8) : const Color(0xFFDCC4FF),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: screenWidth * 0.97,
                          width: screenWidth,
                          decoration: BoxDecoration(
                            color: isDarkMode ? const Color(0xFF000000) : const Color(0xFFBD76FD),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Text(
                                      "Welcome back!",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Nunito",
                                        fontSize: screenWidth * 0.085,
                                      ),
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.18,
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        isDarkMode ? Icons.light_mode : Icons.dark_mode,
                                        color: Colors.white,
                                      ),
                                      onPressed: widget.onToggleTheme,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                UserContainer(
                                  isDarkMode: isDarkMode,
                                  height: screenWidth * 0.615,
                                  width: screenWidth - 20,

                                ),
                                const SizedBox(height: 25),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                          child: Row(
                            children: [
                              Sidebar(
                                height: screenHeight,
                                width: screenWidth,
                                isDarkmode: isDarkMode,
                                isSidebarExpanded: _isSidebarExpanded,
                                selectedIndex: _selectedIndex,
                                onIconTap: _onIconTap,
                                onToggleSidebar: _toggleSidebar,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: screenHeight * 0.390,
                                  child: PageView(
                                    controller: _pageController,
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      NoteView(isDarkMode: isDarkMode),
                                      ChatView(isDarkMode: isDarkMode),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadiusDirectional.circular(20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 70,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              searchBar(
                  isDarkMode: isDarkMode,
                  width: screenWidth),
            ],
          ),
        ),
      ),
    );
  }
}
