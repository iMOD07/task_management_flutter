import 'package:flutter/material.dart';
import 'package:task_management_app/features/auth/data/repositories/auth_repository.dart';
// import 'auth_repository.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String userType = 'Client';
  bool showPassword = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Add Repository
  final AuthRepository _authRepository = AuthRepository();

  //Register function
  void _onRegisterPressed() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> data = {
        "fullName": nameController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "mobileNumber": phoneController.text,
        "userType": userType,
      };

      if (userType == 'Client') {
        data.addAll({
          "companyName": companyController.text,
          "address": addressController.text,
        });
      } else {
        data.addAll({
          "jobTitle": "",
          "department": "",
        });
      }

      String? result = await _authRepository.registerUser(data);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Text(result ?? "yes, Registration successful"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0), // 10. خلفية أفتح
      body: Center(
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
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1. تعليمات مختصرة
                  const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please fill in the form to create your account.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 18),

                  // 3. توضيح نوع الحساب
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio<String>(
                        value: 'Client',
                        groupValue: userType,
                        onChanged: (value) => setState(() => userType = value!),
                      ),
                      const Text('Client'),
                      Tooltip(
                        message: 'For company owners who want to manage tasks.',
                        child: const Icon(Icons.info_outline, size: 18, color: Colors.grey),
                      ),
                      const SizedBox(width: 24),
                      Radio<String>(
                        value: 'Employee',
                        groupValue: userType,
                        onChanged: (value) => setState(() => userType = value!),
                      ),
                      const Text('Employee'),
                      Tooltip(
                        message: 'For staff members who receive tasks.',
                        child: const Icon(Icons.info_outline, size: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // 4. Placeholder واضح + 8. أيقونات
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_outline),
                      labelText: 'Full Name',
                      hintText: 'Enter your full name',
                    ),
                    validator: (value) => value!.isEmpty ? 'Full name required' : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      labelText: 'Email',
                      hintText: 'example@email.com',
                    ),
                    validator: (value) => value!.isEmpty ? 'Email required' : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone_outlined),
                      labelText: 'Phone Number',
                      hintText: '05XXXXXXXX',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) => value!.isEmpty ? 'Phone required' : null,
                  ),
                  const SizedBox(height: 12),

                  // 8. إظهار/إخفاء كلمة المرور
                  TextFormField(
                    controller: passwordController,
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline),
                      labelText: 'Password',
                      hintText: 'Choose a strong password',
                      suffixIcon: IconButton(
                        icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => showPassword = !showPassword),
                      ),
                    ),
                    validator: (value) => value!.length < 6 ? 'Password too short' : null,
                  ),
                  const SizedBox(height: 12),

                  // فقط للعميل
                  if (userType == 'Client') ...[
                    TextFormField(
                      controller: companyController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.business_outlined),
                        labelText: 'Company Name',
                        hintText: 'Your company name',
                      ),
                      validator: (value) => value!.isEmpty ? 'Company name required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: addressController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_on_outlined),
                        labelText: 'Address',
                        hintText: 'Company address',
                      ),
                      validator: (value) => value!.isEmpty ? 'Address required' : null,
                    ),
                    const SizedBox(height: 12),
                  ],

                  // 5. زر واضح (Sign Up)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onRegisterPressed, // هنا الربط!
                      child: const Text('Sign Up', style: TextStyle(fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),

                  // 6. روابط إضافية (تسجيل الدخول)
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      // الانتقال لصفحة تسجيل الدخول
                    },
                    child: const Text("Already have an account? Log in"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}