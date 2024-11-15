import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

part of 'pages.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'http://localhost:8080/v1/user/edit/profile';

  String _id = '';
  String _accountId = '';
  String _accountNumber = '';
  String _name = '';
  String _address = '';
  String _idCard = '';
  String _mothersName = '';
  String _dateOfBirth = '';
  String _gender = '';
  String _balance = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    goUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6582AE),
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: const Color(0xFFF5ECED),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              _name,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF6582AE),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Display each field
                    _buildProfileText('ID: $_id'),
                    _buildProfileText('Account ID: $_accountId'),
                    _buildProfileText('Account Number: $_accountNumber'),
                    _buildProfileText('Address: $_address'),
                    _buildProfileText('ID Card: $_idCard'),
                    _buildProfileText('Mother\'s Name: $_mothersName'),
                    _buildProfileText('Date of Birth: $_dateOfBirth'),
                    _buildProfileText('Gender: $_gender'),
                    _buildProfileText('Balance: $_balance'),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfileText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  void goUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _dio.get(
        _apiUrl,
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      if (response.statusCode == 200) {
        final userData = response.data;

        setState(() {
          _id = userData['id']?.toString() ?? 'Unknown';
          _accountId = userData['account_id']?.toString() ?? 'Unknown';
          _accountNumber = userData['account_number']?.toString() ?? 'Unknown';
          _name = userData['name'] ?? 'No Name Provided';
          _address = userData['address'] ?? 'No Address Provided';
          _idCard = userData['id_card']?.toString() ?? 'Unknown';
          _mothersName = userData['mothers_name'] ?? 'No Mother\'s Name Provided';
          _dateOfBirth = userData['date_of_birth'] ?? 'Date of Birth not provided';
          _gender = userData['gender'] ?? 'Unknown';
          _balance = userData['balance']?.toString() ?? 'Unknown';
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load user data')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading data')),
      );
      Navigator.pushReplacementNamed(context, '/');
    }
  }
}
