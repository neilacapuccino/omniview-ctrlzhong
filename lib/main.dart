import 'package:flutter/material.dart';
import 'login_ui.dart';
import 'register_page.dart';

// ====== Design section ======
// Colors
const Color kDeepPurple = Color(0xFF6C4AB6); // Main accent color
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

// LoginPage replaces MyHomePage as the main screen
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
          // Top left star
          Positioned(
            top: kStar1Top, // <-- Change star 1 position above
            left: kStar1Left, // <-- Change star 1 position above
            child: Icon(Icons.star, color: kStar1, size: 44), // <-- Change star 1 color above
          ),
          // Top right star
          Positioned(
            top: kStar2Top, // <-- Change star 2 position above
            right: kStar2Right, // <-- Change star 2 position above
            child: Icon(Icons.star, color: kStar2, size: 38), // <-- Change star 2 color above
          ),
          // Main content (centered)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // OmniView+ logo/title
                // Position: Centered, Text: OmniView+, Color: Deep purple, Size: 48, FontWeight: bold
                Text(
                  kAppTitle, // <-- Change app title above
                  style: TextStyle(
                    fontSize: 48, // Large size for logo
                    fontWeight: FontWeight.bold,
                    color: kDeepPurple, // <-- Change main accent color above
                    letterSpacing: 2,
                    // fontFamily: 'CustomFont', // Uncomment if you add a custom font
                  ),
                ),
                const SizedBox(height: 190), // Space between logo and button
                // Login button
                // Position: Centered, Text: Login, Color: White text, Button color: Deep purple, Size: 20
                SizedBox(
                  width: 220,
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
                      backgroundColor: kDeepPurple, // <-- Change button color above
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24), // Rounded corners
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      kLoginButtonText, // <-- Change login button text above
                      style: const TextStyle(
                        color: Colors.white, // White text
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 164), // Space below button
                // Do not have an account? create one
                // Position: Centered below button, Text: 'Do not have an account? create one',
                // 'create one' in accent color
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      kNoAccountText, // <-- Change this text above
                      style: TextStyle(
                        color: kDeepPurple, // <-- Change main accent color above
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
                      }, // Add navigation to register page if needed
                      child: Text(
                        kCreateOneText, // <-- Change this text above
                        style: TextStyle(
                          color: const Color.fromARGB(255, 126, 81, 204), // <-- Change accent color above
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
