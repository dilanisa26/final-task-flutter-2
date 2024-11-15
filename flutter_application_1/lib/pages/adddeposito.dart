import 'package:flutter/material.dart';

part of 'pages.dart';

class AddDepositoPage extends StatefulWidget {
  const AddDepositoPage({super.key});

  @override
  _AddDepositoPageState createState() => _AddDepositoPageState();
}

class _AddDepositoPageState extends State<AddDepositoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _bonusController = TextEditingController();

  String? _selectedDepositoType;

  final List<String> _depositoTypes = [
    'Deposito 1',
    'Deposito 2',
    'Deposito 3',
  ];

  void _saveDeposito() {
    if (_formKey.currentState?.validate() ?? false) {
      print('Deposito Saved:');
      print('Jenis Deposito: $_selectedDepositoType');
      print('Jumlah: ${_amountController.text}');

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Deposito berhasil ditambahkan'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  '/detail-deposito',
                  arguments: {
                    'deposit_id': 'D001',
                    'account_id': 'A001',
                    'deposit_name': _selectedDepositoType,
                    'amount': _amountController.text,
                    'time_period': '12',
                    'time_stamp': DateTime.now().toString(),
                  },
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Deposito'),
        backgroundColor: Color(0xFF6582AE),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/deposito', (route) => false);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Jenis Deposito (Dropdown)
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: DropdownButtonFormField<String>(
                    value: _selectedDepositoType,
                    decoration: const InputDecoration(
                      labelText: 'Jenis Deposito',
                      border: InputBorder.none,
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedDepositoType = newValue;
                      });
                    },
                    items: _depositoTypes
                        .map((type) => DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jenis Deposito harus dipilih';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Jumlah (Rp.)
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Jumlah (Rp.)',
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jumlah tidak boleh kosong';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Harap masukkan angka yang valid';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Tombol Simpan
              ElevatedButton(
                onPressed: _saveDeposito,
                child: const Text(
                  'Simpan Deposito',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6582AE),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
