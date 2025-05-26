import 'dart:math';
import 'package:flutter/material.dart';

// كلاس الموجة المتحركة
class AnimatedWave extends StatefulWidget {
  @override
  _AnimatedWaveState createState() => _AnimatedWaveState();
}

class _AnimatedWaveState extends State<AnimatedWave>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ClipPath(
          clipper: SineWaveClipper(animationValue: _controller.value),
          child: Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF232A4E),
                  Color(0xFF5061A7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        );
      },
    );
  }
}

// كلاس رسم شكل الموجة
class SineWaveClipper extends CustomClipper<Path> {
  final double animationValue;
  SineWaveClipper({required this.animationValue});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);

    for (double x = 0.0; x <= size.width; x++) {
      double y = sin((x / size.width * 2 * pi) + (animationValue * 2 * pi)) * 25 + (size.height - 60);
      path.lineTo(x, y);
    }

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant SineWaveClipper oldClipper) =>
      animationValue != oldClipper.animationValue;
}

// الصفحة الرئيسية (Get Start)
class GetStartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA), // لون خلفية هادئ
      body: Stack(
        children: [
          // موجة متحركة في الأعلى
          AnimatedWave(),

          // محتوى الصفحة
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 30),
                Icon(Icons.check_circle_outline, size: 70, color: Color(0xFF232A4E)),
                SizedBox(height: 18),
                Text(
                  "Welcome to Task Management",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF232A4E),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // ضع هنا التنقل للصفحة التالية
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => NextPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF232A4E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 6,
                    ),
                    child: Text(
                      "Get Start",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
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
