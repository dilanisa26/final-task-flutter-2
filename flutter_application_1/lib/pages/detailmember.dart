part of 'pages.dart';

class MemberDetailPage extends StatefulWidget {
  final int memberId;

  const MemberDetailPage({super.key, required this.memberId});

  @override
  _MemberDetailPageState createState() => _MemberDetailPageState();
}

class _MemberDetailPageState extends State<MemberDetailPage> {
  final Dio _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';
  Member? _member;
  int saldo = 0;
  bool _isMemberActive = false;

  @override
  void initState() {
    super.initState();
    getMemberDetail();
    getSaldoMember();
  }

  Future<void> getMemberDetail() async {
    try {
      final response = await _dio.get(
        '$_apiUrl/anggota/${widget.memberId}',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      if (response.statusCode == 200) {
        final responseData = response.data;
        final memberData = responseData['data']['anggota'];
        setState(() {
          _member = Member.fromJson(memberData);
          _isMemberActive = _member!.statusAktif == 1;
        });
        print(response.data);
      } else {
        print('Failed to load deposito detail: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to load deposito detail',
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to load deposito detail',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  Future<void> getSaldoMember() async {
    try {
      final response = await _dio.get(
        '$_apiUrl/saldo/${widget.memberId}',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      if (response.statusCode == 200) {
        final responseData = response.data;
        setState(() {
          saldo = responseData['data']['saldo'];
        });
        print(response.data);
      } else {
        print('Failed to load saldo: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Deposito',
          style: blackTextStyle.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: _member == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: defaultMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  const CircleAvatar(
                    radius: 50,
                    // backgroundImage: NetworkImage(_member!.profileImageUrl ?? ''),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: buildDetailCard("ID", _member!.id.toString()),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: buildDetailCard(
                            "Nomor Induk", _member!.nomorInduk.toString()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  buildDetailCard("Nama", _member!.name),
                  const SizedBox(height: 10),
                  buildDetailCard("Alamat", _member!.alamat),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: buildDetailCard(
                            "Tanggal Lahir", _member!.tanggalLahir),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: buildDetailCard("Telepon", _member!.telepon),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  buildStatusCard("Status",
                      _member!.statusAktif == 1 ? 'Active' : 'Inactive'),
                  const SizedBox(height: 10),
                  buildSaldoCard("Saldo",
                      'Rp${NumberFormat("#,##0", "id_ID").format(saldo)}'),
                  const SizedBox(height: 105),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/listtabungan',
                              arguments: _member!.id,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            backgroundColor: secondaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            'Daftar Transaksi',
                            style: whiteTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isMemberActive
                              ? () {
                                  Navigator.pushNamed(
                                    context,
                                    '/addtabungan',
                                    arguments: {
                                      'id': _member!.id,
                                      'nomor_induk': _member!.nomorInduk,
                                      'nama': _member!.name,
                                    },
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            backgroundColor:
                                _isMemberActive ? secondaryColor : Colors.grey,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            'Add Transaksi',
                            style: whiteTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildDetailCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 241, 238, 247),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: blackTextStyle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: blackTextStyle.copyWith(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatusCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: value == 'Active' ? Colors.green[100] : Colors.red[100],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            value == 'Active' ? Icons.check_circle : Icons.cancel,
            color: value == 'Active' ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Text(
            '$label: $value',
            style: blackTextStyle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSaldoCard(String label, String value) {
    return Container(
      // onTap: () {
      //   if (_isMemberActive) {
      //     Navigator.pushNamed(
      //       context,
      //       '/addbunga',
      //       arguments: _isMemberActive,
      //     );
      //   } else {
      //     // Tampilkan pesan bahwa member tidak aktif
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         content: Text(
      //           'Member is not active. Cannot add bunga.',
      //           textAlign: TextAlign.center,
      //         ),
      //         duration: Duration(seconds: 3),
      //         behavior: SnackBarBehavior.floating,
      //       ),
      //     );
      //   }
      // },
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.account_balance_wallet,
            color: Colors.blue,
          ),
          const SizedBox(width: 8),
          Text(
            '$label: $value',
            style: blackTextStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
        ],
      ),
    );
  }
}
