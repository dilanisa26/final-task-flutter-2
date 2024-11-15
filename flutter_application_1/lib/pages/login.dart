import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

part of 'pages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isHidden = true;

  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2DAD7), // Background halaman
      appBar: AppBar(
        backgroundColor: const Color(0xFF6582AE),
        title: const Text(
          'Login',
          style: TextStyle(
            color: Color(0xFFF5ECED),
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFF5ECED)),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Card(
                color: const Color(0xFF7FA1C4),
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Login Form",
                        style: TextStyle(
                          color: Color(0xFFF5ECED),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          filled: true,
                          fillColor: const Color(0xFFF5ECED),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xFF6582AE)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelStyle: const TextStyle(color: Color(0xFF6582AE), fontSize: 15),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      TextField(
                        controller: passwordController,
                        obscureText: _isHidden,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          filled: true,
                          fillColor: const Color(0xFFF5ECED),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xFF6582AE)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelStyle: const TextStyle(color: Color(0xFF6582AE), fontSize: 15),
                          suffixIcon: InkWell(
                            onTap: _tooglePasswordView,
                            child: Icon(
                              _isHidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: const Color(0xFF6582AE),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Handle forgot password
                            },
                            child: const Text(
                              'Forgot your password?',
                              style: TextStyle(
                                color: Color(0xFFF5ECED),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            goLogin();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF5ECED),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              color: Color(0xFF6582AE),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text(
                          'Create new account',
                          style: TextStyle(
                            color: Color(0xFFF5ECED),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Or continue with',
                        style: TextStyle(
                          color: Color(0xFFF5ECED),
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
                            icon: const Icon(FontAwesomeIcons.google, color: Color(0xFFF5ECED)),
                          ),
                          IconButton(
                            onPressed: () {
                              // Handle Facebook sign up
                            },
                            icon: const Icon(FontAwesomeIcons.facebook, color: Color(0xFFF5ECED)),
                          ),
                          IconButton(
                            onPressed: () {
                              // Handle Apple sign up
                            },
                            icon: const Icon(FontAwesomeIcons.apple, color: Color(0xFFF5ECED)),
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

  void _tooglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void goLogin() async {
    try {
      final response = await _dio.post(
        '$_apiUrl/login',
        data: {
          'email': emailController.text,
          'password': passwordController.text,
        },
      );
      print(response.data);
      _storage.write('token', response.data['data']['token']);
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Login failed. Please check your credentials.',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
