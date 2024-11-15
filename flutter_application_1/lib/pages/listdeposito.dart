import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

part of 'pages.dart';

class ListDepositoPage extends StatefulWidget {
  const ListDepositoPage({super.key});

  @override
  _ListDepositoPageState createState() => _ListDepositoPageState();
}

class _ListDepositoPageState extends State<ListDepositoPage> {
  List<Map<String, dynamic>> depositoList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDepositoList();
  }

  Future<void> fetchDepositoList() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/v1/account/login/listdeposito'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          depositoList = data.map((item) => {
            'id': item['id'],
            'name': item['name'],
            'minAmount': item['minAmount'],
            'maxAmount': item['maxAmount'],
            'bonus': item['bonus']
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load deposito list');
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
        title: const Text(
          'List Deposito',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/deposito'); // Arahkan ke halaman AddBungaPage
          },
        ),
        backgroundColor: const Color(0xFF6582AE), // Warna AppBar #6582AE
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : depositoList.isEmpty
              ? const Center(child: Text('No deposito available'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: depositoList.length,
                    itemBuilder: (context, index) {
                      var deposito = depositoList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        color: const Color(0xFFE2DAD7), // Warna Card #E2DAD7
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // Rounded corners
                        ),
                        child: ListTile(
                          title: Text(
                            deposito['name'] ?? 'N/A',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFF6582AE), // Warna teks nama deposito #6582AE
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bonus: ${deposito['bonus'] ?? 'N/A'}',
                                style: const TextStyle(
                                  color: Color(0xFF7FA1C4), // Warna teks bonus #7FA1C4
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Min Amount: ${deposito['minAmount']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black, // Warna teks bold untuk jumlah minimum
                                ),
                              ),
                              Text(
                                'Max Amount: ${deposito['maxAmount']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black, // Warna teks bold untuk jumlah maksimum
                                ),
                              ),
                            ],
                          ),
                          trailing: Text(
                            'ID: ${deposito['id']}',
                            style: const TextStyle(
                              color: Color(0xFF7FA1C4), // Warna teks ID #7FA1C4
                            ),
                          ),
                          onTap: () {
                            // Navigasi ke halaman detail deposito
                            Navigator.pushNamed(
                              context,
                              '/detail-deposito',
                              arguments: deposito,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
