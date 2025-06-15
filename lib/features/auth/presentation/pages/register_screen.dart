import 'package:flutter/material.dart';
import 'package:task_management_app/features/auth/data/repositories/auth_repository.dart';
import 'login_screen.dart';
import 'dart:convert';

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
  // for Employee
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  // for Client
  final TextEditingController companyController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final AuthRepository _authRepository = AuthRepository();

  /// متغير لتخزين أخطاء السيرفر وربطها بالحقول
  Map<String, String> serverErrors = {};

  void _onRegisterPressed() async {
    // تصفير أخطاء الباكند قبل كل محاولة تسجيل
    setState(() => serverErrors.clear());

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
          "userType": "Client",
        });
      } else if (userType == 'Employee') {
        data.addAll({
          "jobTitle": jobTitleController.text,
          "department": departmentController.text,
          "userType": "Employee",
        });
      }

      var result = await _authRepository.registerUser(data);

      if (!mounted) return;

      // تحقق هل التسجيل ناجح أم لا (عدّل حسب استجابة الباكند عندك)
      if (result["success"] == true) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 50),
                const SizedBox(height: 16),
                Text(
                  'You have been successfully registered',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 8),
                Text('You can now log in to your account'),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF20283D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: const Text('Log in', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      } else {
        // فك الأخطاء من الباكند وخزنها في المتغير
        try {
          final errorObj = jsonDecode(result["message"]);
          if (errorObj is Map) {
            errorObj.forEach((key, value) {
              if (value != null) serverErrors[key] = value.toString();
            });
          }
        } catch (e) {
          // لو فشل فك JSON أو كان الرد نص عادي، أضف رسالة عامة
          serverErrors["general"] = result["message"].toString();
        }
        // إعادة بناء الواجهة لعرض الأخطاء تحت الحقول
        setState(() {});
        // لو فيه رسالة خطأ عامة ما تخص حقل معيّن
        if (serverErrors.containsKey("general")) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(serverErrors["general"]!),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      body: Center(
        child: Container(
          width: 525,
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
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 18),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio<String>(
                        value: 'Client',
                        groupValue: userType,
                        onChanged: (value) => setState(() => userType = value!),
                      ),
                      const Text('Client'),
                      const SizedBox(width: 24),
                      Radio<String>(
                        value: 'Employee',
                        groupValue: userType,
                        onChanged: (value) => setState(() => userType = value!),
                      ),
                      const Text('Employee'),
                    ],
                  ),
                  const SizedBox(height: 18),

                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_outline),
                      labelText: 'Full Name',
                      hintText: 'Enter your full name',
                      errorText: serverErrors['fullName'], // ربط رسالة الباكند
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
                      errorText: serverErrors['email'],
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
                      errorText: serverErrors['mobileNumber'],
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) => value!.isEmpty ? 'Phone required' : null,
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: passwordController,
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline),
                      labelText: 'Password',
                      hintText: 'Choose a strong password',
                      errorText: serverErrors['password'],
                      suffixIcon: IconButton(
                        icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => showPassword = !showPassword),
                      ),
                    ),
                    validator: (value) => value!.isEmpty ? 'Password required' : null,
                  ),


                  const SizedBox(height: 12),

                  if (userType == 'Client') ...[
                    TextFormField(
                      controller: companyController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.business_outlined),
                        labelText: 'Company Name',
                        hintText: 'Your company name',
                        errorText: serverErrors['companyName'],
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
                        errorText: serverErrors['address'],
                      ),
                      validator: (value) => value!.isEmpty ? 'Address required' : null,
                    ),
                    const SizedBox(height: 12),
                  ],

                  if (userType == 'Employee') ...[
                    TextFormField(
                      controller: jobTitleController,
                      decoration: InputDecoration(
                        labelText: 'Job Title',
                        prefixIcon: Icon(Icons.work),
                        errorText: serverErrors['jobTitle'],
                      ),
                      validator: (value) => value!.isEmpty ? 'Job title required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: departmentController,
                      decoration: InputDecoration(
                        labelText: 'Department',
                        prefixIcon: Icon(Icons.apartment),
                        errorText: serverErrors['department'],
                      ),
                      validator: (value) => value!.isEmpty ? 'Department required' : null,
                    ),
                    const SizedBox(height: 12),
                  ],

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onRegisterPressed,
                      child: const Text('Sign Up', style: TextStyle(fontSize: 18, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF20283D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: const Text("Already have an account? Log in",style: TextStyle(color: Color(0xFF20283D),
                      ),
                    ),
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
