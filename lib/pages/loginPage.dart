import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../auth/firebaseAuth.dart';
import 'dart:ui'; // For the BackdropFilter
import 'package:email_validator/email_validator.dart';

class loginPage extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  const loginPage({super.key, required this.themeMode, required this.onToggleTheme});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  void _signInWithEmail() {
    setState(() {
      _isLoading = true;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Hide any existing SnackBar
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Validate email format
    if (!EmailValidator.validate(email)) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invalid email format."),
        ),
      );
      return;
    }

    // Check if password is empty
    if (password.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password cannot be empty."),
        ),
      );
      return;
    }

    _authService.signInWithEmail(
      email,
      password,
          () {
        setState(() {
          _isLoading = false;
        });
        Navigator.pushReplacementNamed(context, '/homepage');
      },
          (String errorMessage) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to sign in: $errorMessage"),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    bool isDarkMode = widget.themeMode == ThemeMode.dark;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: isDarkMode ? const Color(0xFF000000) : const Color(0xFFBD76FD),
      statusBarColor: isDarkMode ? const Color(0xFF000000) : const Color(0xFFBD76FD),
    ));
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              height: screenHeight,
              width: screenWidth,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.black : const Color(0xFFBD76FD),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
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
                        SizedBox(width: screenWidth * 0.18),
                        IconButton(
                          icon: Icon(
                            isDarkMode ? Icons.light_mode : Icons.dark_mode,
                            color: Colors.white,
                          ),
                          onPressed: widget.onToggleTheme,
                        ),
                      ],
                    ),
                    SizedBox(height: screenWidth * 0.04),
                    Image.asset("assets/icon/Student diary_transparent-.png", height: 300, color: Colors.white),
                    SizedBox(height: 1),
                    Container(
                      width: screenWidth - 40,
                      height: 80,
                      child: TextField(
                        controller: _emailController,
                        style: TextStyle(
                          fontSize: isDarkMode ? 20 : 22,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textAlignVertical: TextAlignVertical.center,
                        showCursor: false,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email, color: Colors.white),
                          labelText: "Email",
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: isDarkMode ? 18 : 22,
                            letterSpacing: isDarkMode ? 0 : 1,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: screenWidth - 40,
                      height: 80,
                      child: TextField(
                        controller: _passwordController,
                        style: TextStyle(
                          fontSize: isDarkMode ? 20 : 22,
                        ),
                        obscureText: true,
                        textAlignVertical: TextAlignVertical.center,
                        showCursor: false,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock, color: Colors.white),
                          labelText: "Password",
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: isDarkMode ? 18 : 22,
                            letterSpacing: isDarkMode ? 0 : 1,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _signInWithEmail,
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          isDarkMode ? Colors.transparent : Color(0xFFBD76FD),
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(width: 3, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading) // Show loading indicator with blurred background
            Positioned.fill(
              child: Stack(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
                    ),
                  ),
                  Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
