import 'dart:math';
import 'package:flutter/material.dart';
import '../../../auth/presentation/pages/login_screen.dart';

import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedWave extends StatefulWidget {
  const AnimatedWave({super.key});

  @override
  AnimatedWaveState createState() => AnimatedWaveState();
}

class AnimatedWaveState extends State<AnimatedWave> with SingleTickerProviderStateMixin {
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
                  Color(0xFF0D1B2A),
                  Color(0xFF1B263B),
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
class GetStartPage extends StatefulWidget {
  @override
  State<GetStartPage> createState() => _GetStartPageState();
}

class _GetStartPageState extends State<GetStartPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA), // لون خلفية هادئ
      body: Stack(
        children: [
          // موجة متحركة في الأعلى
          AnimatedWave(),

          // محتوى الصفحة مع Scroll عشان ما يصير Overflow
          SingleChildScrollView(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 150), // المسافة من أعلى الشاشة للمحتوى

                  // 1. صورة الشعار مع أنيميشن
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Image.asset(
                      'assets/logo_page_home.png', // ضع الصورة في assets وأضفها في pubspec.yaml
                      width: 300,
                      height: 200,
                    ),
                  ),
                  SizedBox(height: 10),

                  // 4. لمسة أنيميشن للنصوص
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          "Welcome to Task Management",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D1B2A),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Start your journey to organized work!",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF0D1B2A),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1B263B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 6,
                        ),
                        child: Text(
                          "Get Started",
                          style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFFE0E1DD),
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(), // يملأ الفراغ حتى يظهر الفوتر في الأسفل
                  // 7. Footer
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 14.0),
                      child: Column(
                        children: [
                          Divider(
                            color: Colors.grey.shade300,
                            thickness: 1,
                            indent: 60,
                            endIndent: 60,
                          ),
                          SizedBox(height: 6),
                          Text(
                            "© 2025 Task Management | All rights reserved",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          // يمكنك إضافة سياسة الخصوصية أو الدعم هنا أيضاً
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
