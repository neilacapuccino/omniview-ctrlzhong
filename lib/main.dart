import 'package:flutter/material.dart';
import 'login_ui.dart';
import 'register_page.dart';

// ====== Design section ======
// Colors
const Color kDeepPurple = Color(0xFF6C4AB6); // Main accent color
const Color kDarkerPurple = Color(0xFF3D246C); // Even darker purple
const Color kWhitishPurple = Color(0xFFF8F6FF); // Gradient start
const Color kWhite = Color(0xFFFFFFFF); // Gradient end
const Color kStar1 = Color(0xFFE0D7FF);
const Color kStar2 = Color(0xFFD1C4E9);
const Color kStar3 = Color(0xFFEDE7F6);
const Color kStar4 = Color(0xFFE0D7FF);
const Color kAccent = Color(0xFFB388FF); // Accent for 'create one'

// Texts
const String kAppTitle = 'OmniView+'; // <-- Change app title here
const String kLoginButtonText = 'Login'; // <-- Change login button text here
const String kNoAccountText = 'Do not have an account? '; // <-- Change this text
const String kCreateOneText = 'create one'; // <-- Change this text

// Star positions (change these to move stars)
const double kStar1Top = 60;
const double kStar1Left = 30;
const double kStar2Top = 100;
const double kStar2Right = 40;
const double kStar3Bottom = 80;
const double kStar3Left = 50;
const double kStar4Bottom = 120;
const double kStar4Right = 60;
// ====== End Editable Variables Section ======

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

// LoginPage 
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set background to transparent to allow custom background
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Solid white background instead of gradient
          Container(
            color: kWhite,
          ),
          // Star decorations (minimalist, positioned)
          const StarDecorations(),
          // Main content (centered)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // OmniView+ logo/title
                // Position: Centered, Text: OmniView+, Color: Deep purple, Size: 48, FontWeight: bold
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Omni',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: kDeepPurple, // Keep Omni the original purple
                          letterSpacing: 2,
                        ),
                      ),
                      TextSpan(
                        text: 'View+',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: kDarkerPurple, // Only View+ is darker purple
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                // To adjust the vertical position of the login and create one section (without affecting the OmniView+ title),
                // add padding or change alignment below:
                // Example: Padding(padding: EdgeInsets.only(top: 40), child: ...)
                // Adjust the gap between the OmniView+ title and the login/create one section below:
                const SizedBox(height: 350), // Change this value to adjust the gap
                // Login button and 'create one' row
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // To adjust the length of the Login button, change the width value below.
                    SizedBox(
                      width: 300, // Set to a shorter length for the button
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginUI(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kDeepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero, // Rectangle
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          kLoginButtonText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8), // Minimal gap
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          kNoAccountText,
                          style: TextStyle(
                            color: kDeepPurple,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                          child: Text(
                            kCreateOneText,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 126, 81, 204),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StarDecorations extends StatelessWidget {
  const StarDecorations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top left star
        Positioned(
          top: kStar1Top,
          left: kStar1Left,
          child: Transform.rotate(
            angle: 0.2,
            child: Icon(Icons.star, color: kStar1, size: 44),
          ),
        ),
        // Top right star
        Positioned(
          top: kStar2Top,
          right: kStar2Right,
          child: Transform.rotate(
            angle: -0.3,
            child: Icon(Icons.star, color: kStar2, size: 38),
          ),
        ),
        // Extra star (top center)
        Positioned(
          top: 20,
          left: 180,
          child: Transform.rotate(
            angle: 1.2,
            child: Icon(Icons.star, color: kStar3, size: 18),
          ),
        ),
        // Bottom left star
        Positioned(
          bottom: kStar3Bottom,
          left: kStar3Left,
          child: Transform.rotate(
            angle: 0.5,
            child: Icon(Icons.star, color: kStar3, size: 32),
          ),
        ),
        // Bottom right star
        Positioned(
          bottom: kStar4Bottom,
          right: kStar4Right,
          child: Transform.rotate(
            angle: -0.6,
            child: Icon(Icons.star, color: kStar4, size: 28),
          ),
        ),
      ],
    );
  }
}
