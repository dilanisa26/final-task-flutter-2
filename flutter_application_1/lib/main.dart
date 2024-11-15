import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/pages.dart'; // Pastikan Anda mengimpor halaman yang tepat
import 'package:get_storage/get_storage.dart';

// Import model files if needed for arguments in routes
import 'package:flutter_application_1/model/user.dart';
import 'package:flutter_application_1/model/account.dart';
import 'package:flutter_application_1/model/deposito_history.dart';
import 'package:flutter_application_1/model/personal_deposito.dart';
import 'package:flutter_application_1/model/transaction_history.dart';
void main() async {
  await GetStorage.init(); // Pastikan ini ditunggu untuk inisialisasi
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const WelcomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegistrationPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/member': (context) => const MemberPage(),
        '/addmember': (context) => const AddMemberPage(),
        '/editmember': (context) {
          final member = ModalRoute.of(context)!.settings.arguments as Member;
          return EditMemberPage(member: member);
        },
        '/list-deposito': (context) => const ListDepositoPage(),
        '/adddeposito': (context) => const AddDepositoPage(),
        '/detail-deposito-user': (context) => const DetailDepositoUserPage(),
        '/mutasi': (context) => const MutasiPage(), // Route untuk halaman Mutasi
        '/editpassword': (context) => const EditPasswordPage(), // Route untuk halaman Edit Password
        '/deposito': (context) => const DepositoPage(), // Route untuk halaman Deposito
      },
      initialRoute: '/',
    );
  }
}