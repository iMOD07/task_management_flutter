import 'package:flutter/material.dart';

// شاشة الترحيب
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Scaffold is the main container for each screen in Flutter
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1), // Same background color as the image
      body: Stack(
        children: [
          // Top: Decorative wave
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.33,
                color: const Color(0xFF20283D), // Same background color as the image
              ),
            ),
          ),
          // Screen content: text and button
          Center(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 250),
                Text(
                  "Welcome to Task Management",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),
                SizedBox(
                  width: 250, // New button display
                  height: 49, // New button height
                  child: ElevatedButton(
                    onPressed: () {
                      // Action on click
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF222940),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Get Start",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }
}

// Class to draw the wave at the top of the screen
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 40);
    var secondControlPoint = Offset(3 * size.width / 4, size.height - 90);
    var secondEndPoint = Offset(size.width, size.height - 20);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
