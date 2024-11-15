import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

part of 'pages.dart';

class MutasiPage extends StatefulWidget {
  const MutasiPage({super.key});

  @override
  _MutasiPageState createState() => _MutasiPageState();
}

class _MutasiPageState extends State<MutasiPage> {
  final List<Map<String, dynamic>> _mutasiData = []; // Menggunakan data dari API nantinya
  final TextEditingController _accountIdController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _inOutController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMutasiData(); // Memuat data dari API saat pertama kali halaman dimuat
  }

  Future<void> fetchMutasiData() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/v1/user/mutation/deposit'));
      if (response.statusCode == 200) {
        setState(() {
          _mutasiData.clear();
          _mutasiData.addAll(List<Map<String, dynamic>>.from(json.decode(response.body)));
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load transactions: $e')),
      );
    }
  }

  Future<void> saveTransaction() async {
    final transactionData = {
      'account_id': _accountIdController.text,
      'transaction_category': _categoryController.text,
      'amount': int.parse(_amountController.text),
      'in_out': _inOutController.text,
    };

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/v1/user/mutation/deposit'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(transactionData),
      );

      if (response.statusCode == 201) {
        fetchMutasiData();
        _clearFormFields();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction saved successfully')),
        );
      } else {
        throw Exception('Failed to save transaction');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save transaction: $e')),
      );
    }
  }

  void _clearFormFields() {
    _accountIdController.clear();
    _categoryController.clear();
    _amountController.clear();
    _inOutController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2DAD7),
      appBar: AppBar(
        title: const Text(
          'Mutasi Transaksi',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color(0xFF6582AE),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Riwayat Transaksi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6582AE),
              ),
            ),
            const SizedBox(height: 10),
            _buildTransactionForm(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _mutasiData.length,
                itemBuilder: (context, index) {
                  final mutasi = _mutasiData[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: const Color(0xFFF5ECED),
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRow('ID', mutasi['Id'].toString()),
                          const SizedBox(height: 5),
                          _buildRow('Account ID', mutasi['Account_Id']),
                          const SizedBox(height: 5),
                          _buildRow('Transaction Category', mutasi['Transaction_Category']),
                          const SizedBox(height: 5),
                          _buildRow('Amount', 'Rp ${mutasi['Amount']}'),
                          const SizedBox(height: 5),
                          _buildRow('In/Out', mutasi['In_Out']),
                          const SizedBox(height: 5),
                          _buildRow('Timestamp', mutasi['Time_Stamp']),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _accountIdController,
          decoration: const InputDecoration(labelText: 'Account ID'),
        ),
        TextField(
          controller: _categoryController,
          decoration: const InputDecoration(labelText: 'Transaction Category'),
        ),
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Amount'),
        ),
        TextField(
          controller: _inOutController,
          decoration: const InputDecoration(labelText: 'In/Out'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: saveTransaction,
          child: const Text('Save Transaction'),
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6582AE),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF7FA1C4),
          ),
        ),
      ],
    );
  }
}
