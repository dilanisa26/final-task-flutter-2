import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

part of 'pages.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool _isHiddenPassword = true;
  bool _isHiddenConfirmPassword = true;

  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5ECED), // Soft light background color
      appBar: AppBar(
        title: Text(
          'Create Account',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          },
        ),
        backgroundColor: Color(0xFF6582AE), // Accent color for AppBar
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Card(
                color: Color(0xFF7FA1C4), // Light blue background for the card
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Create Account",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'Create an account to explore all the features',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30.0),
                      // Name Field
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          filled: true,
                          fillColor: Color(0xFFE2DAD7), // Light background color
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF6582AE)), // Accent color
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelStyle: TextStyle(color: Color(0xFF6582AE), fontSize: 15),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      // Email Field
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          filled: true,
                          fillColor: Color(0xFFE2DAD7), // Light background color
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF6582AE)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelStyle: TextStyle(color: Color(0xFF6582AE), fontSize: 15),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      // Password Field
                      TextField(
                        controller: passwordController,
                        obscureText: _isHiddenPassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          filled: true,
                          fillColor: Color(0xFFE2DAD7),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF6582AE)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelStyle: TextStyle(color: Color(0xFF6582AE), fontSize: 15),
                          suffixIcon: InkWell(
                            onTap: _togglePasswordView,
                            child: Icon(
                                _isHiddenPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      // Confirm Password Field
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: _isHiddenConfirmPassword,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          filled: true,
                          fillColor: Color(0xFFE2DAD7),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF6582AE)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelStyle: TextStyle(color: Color(0xFF6582AE), fontSize: 15),
                          suffixIcon: InkWell(
                            onTap: _toggleConfirmPasswordView,
                            child: Icon(
                                _isHiddenConfirmPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      // Sign Up Button
                      SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            goRegister();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6582AE), // Accent color for the button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      // Existing Account Link
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text(
                          'Already have an account?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Or continue with',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              // Handle Google sign up
                            },
                            icon: const Icon(FontAwesomeIcons.google),
                          ),
                          IconButton(
                            onPressed: () {
                              // Handle Facebook sign up
                            },
                            icon: const Icon(FontAwesomeIcons.facebook),
                          ),
                          IconButton(
                            onPressed: () {
                              // Handle Apple sign up
                            },
                            icon: const Icon(FontAwesomeIcons.apple),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHiddenPassword = !_isHiddenPassword;
    });
  }

  void _toggleConfirmPasswordView() {
    setState(() {
      _isHiddenConfirmPassword = !_isHiddenConfirmPassword;
    });
  }

  void goRegister() async {
    try {
      final response = await _dio.post(
        '$_apiUrl/register',
        data: {
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
        },
      );
      print(response.data);
      _storage.write('data', response.data['data']);
      Navigator.pushNamed(context, '/login');
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Registration failed. Please check your credentials.',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
