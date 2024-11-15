import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

part of 'pages.dart';

class DetailDepositoUserPage extends StatefulWidget {
  const DetailDepositoUserPage({super.key});

  @override
  _DetailDepositoUserPageState createState() => _DetailDepositoUserPageState();
}

class _DetailDepositoUserPageState extends State<DetailDepositoUserPage> {
  Map<String, dynamic>? depositoDetail;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    fetchDepositoDetail(args['account_id']); // Mengambil data berdasarkan `account_id`
  }

  Future<void> fetchDepositoDetail(int accountId) async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/v1/user/mutation/deposit/$accountId'));

      if (response.statusCode == 200) {
        setState(() {
          depositoDetail = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load deposito details');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Deposito User'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/deposito', (route) => false);
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : depositoDetail == null
              ? const Center(child: Text('No deposito details available'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ID: ${depositoDetail!['id']}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text('Deposit ID: ${depositoDetail!['deposit_id']}'),
                      Text('Account ID: ${depositoDetail!['account_id']}'),
                      Text('Deposit Name: ${depositoDetail!['deposit_name']}'),
                      Text('Amount: ${depositoDetail!['amount']}'),
                      Text('Time Period: ${depositoDetail!['time_period']} months'),
                      Text('Time Stamp: ${depositoDetail!['time_stamp']}'),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
    );
  }
}
