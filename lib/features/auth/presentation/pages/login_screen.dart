import 'package:flutter/material.dart';

enum UserType { client, employee, admin }

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserType selectedType = UserType.client;
  bool obscurePassword = true; // متغير لإخفاء/إظهار الباسورد

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB4B4B4),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 24,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF20283D),
                  ),
                ),
                const SizedBox(height: 24),

                // SegmentedButton لاختيار نوع المستخدم
                SegmentedButton<UserType>(
                  segments: const <ButtonSegment<UserType>>[
                    ButtonSegment(value: UserType.client, label: Text('CLIENT')),
                    ButtonSegment(value: UserType.employee, label: Text('EMPLOYEE')),
                    ButtonSegment(value: UserType.admin, label: Text('ADMIN')),
                  ],
                  selected: <UserType>{selectedType},
                  onSelectionChanged: (Set<UserType> newSelection) {
                    setState(() {
                      selectedType = newSelection.first;
                    });
                  },
                  style: ButtonStyle(
                    // لون النص العادي
                    foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.selected)) {
                        return Colors.white; // النص أبيض عند التحديد
                      }
                      return Color(0xFF20283D); // النص عادي
                    }),
                    // لون الخلفية العادية
                    backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.selected)) {
                        return Color(0xFF20283D); // لون أغمق عند التحديد
                      }
                      return Colors.grey.shade200; // لون خفيف للأزرار غير المحددة
                    }),
                  ),
                  showSelectedIcon: false,
                ),


                const SizedBox(height: 28),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    // هنا أيقونة العين
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Color(0xFF20283D),
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // هنا منطق تسجيل الدخول حسب selectedType
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF20283D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Log In',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "If you do not have an account, ",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    GestureDetector(
                      onTap: () {
                        // هنا تروح لصفحة التسجيل
                      },
                      child: const Text(
                        "Register here.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF20283D),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
