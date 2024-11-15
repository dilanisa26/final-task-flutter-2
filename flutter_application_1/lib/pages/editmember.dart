import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

part of 'pages.dart';

class EditMemberPage extends StatefulWidget {
  final Member member;

  const EditMemberPage({super.key, required this.member});

  @override
  _EditMemberPageState createState() => _EditMemberPageState();
}

class _EditMemberPageState extends State<EditMemberPage> {
  // Controller untuk field input
  late TextEditingController _accountIdController;
  late TextEditingController _accountNumberController;
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _idCardController;
  late TextEditingController _mothersNameController;
  late TextEditingController _balanceController;
  String _gender = '';
  DateTime? _selectedDate;

  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'http://localhost:8080/v1/user/edit/profile';

  @override
  void initState() {
    super.initState();
    _accountIdController = TextEditingController(text: widget.member.accountId.toString());
    _accountNumberController = TextEditingController(text: widget.member.accountNumber.toString());
    _nameController = TextEditingController(text: widget.member.name);
    _addressController = TextEditingController(text: widget.member.address);
    _idCardController = TextEditingController(text: widget.member.idCard.toString());
    _mothersNameController = TextEditingController(text: widget.member.mothersName);
    _balanceController = TextEditingController(text: widget.member.balance.toString());
    _selectedDate = DateTime.tryParse(widget.member.dateOfBirth);
    _gender = widget.member.gender;
  }

  @override
  void dispose() {
    _accountIdController.dispose();
    _accountNumberController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _idCardController.dispose();
    _mothersNameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void goEditMember() async {
    try {
      final response = await _dio.put(
        _apiUrl,
        data: {
          'id': widget.member.id,
          'account_id': int.parse(_accountIdController.text),
          'account_number': int.parse(_accountNumberController.text),
          'name': _nameController.text,
          'address': _addressController.text,
          'id_card': int.parse(_idCardController.text),
          'mothers_name': _mothersNameController.text,
          'date_of_birth': _selectedDate?.toIso8601String() ?? '',
          'gender': _gender,
          'balance': int.parse(_balanceController.text),
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${_storage.read('token')}',
          },
        ),
      );

      if (response.statusCode == 200) {
        Navigator.pushNamed(context, '/profile');
      }
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Update failed. Please check your data or login again.',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF6582AE),
      ),
      body: Container(
        color: const Color(0xFFF5ECED),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildTextField('Account ID', _accountIdController),
                _buildTextField('Account Number', _accountNumberController),
                _buildTextField('Name', _nameController),
                _buildTextField('Address', _addressController),
                _buildTextField('ID Card', _idCardController),
                _buildTextField('Mother\'s Name', _mothersNameController),
                const SizedBox(height: 20.0),
                
                GestureDetector(
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _selectedDate = selectedDate;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      readOnly: true,
                      controller: TextEditingController(
                        text: _selectedDate != null
                            ? '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}'
                            : '',
                      ),
                      decoration: _buildInputDecoration('Date of Birth'),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20.0),
                _buildTextField('Balance', _balanceController),
                
                const SizedBox(height: 20.0),
                DropdownButtonFormField<String>(
                  value: _gender,
                  items: ['Male', 'Female'].map((gender) {
                    return DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _gender = value!;
                    });
                  },
                  decoration: _buildInputDecoration('Gender'),
                ),
                
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton('Cancel', Colors.red, () {
                      Navigator.pushNamed(context, '/profile');
                    }),
                    _buildButton('Update', const Color(0xFF6582AE), goEditMember),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: _buildInputDecoration(label),
      keyboardType: TextInputType.number,
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF6582AE)),
      filled: true,
      fillColor: const Color(0xFFE2DAD7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF7FA1C4)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF7FA1C4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF6582AE)),
      ),
    );
  }

  Widget _buildButton(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(120, 50),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
