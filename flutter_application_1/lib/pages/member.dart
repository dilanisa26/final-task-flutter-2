part of 'pages.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({super.key});

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  final Dio _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';
  List<Member> _members = [];

  String _searchKeyword = '';

  @override
  void initState() {
    super.initState();
    _loadMembersList(); // Panggil metode untuk memuat anggota saat widget diinisialisasi
  }

  Future<void> _loadMembersList() async {
    try {
      final response = await _dio.get(
        '$_apiUrl/anggota',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      print(response.data);
      if (response.statusCode == 200) {
        // Parsing data JSON
        Map<String, dynamic> responseData = response.data;
        List<dynamic> anggotaList = responseData['data']['anggotas'];

        // Mengubah setiap item dalam daftar anggota menjadi objek Member
        List<Member> members =
            anggotaList.map((item) => Member.fromJson(item)).toList();

        // Memperbarui daftar anggota dalam state
        setState(() {
          _members = members;
        });
      } else {
        // Respons gagal
        print('Failed to load Deposito: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to load Deposito',
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      Navigator.pushReplacementNamed(context, '/');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Token is expired. Please login again.',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showMemberDetail(Member member) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemberDetailPage(memberId: member.id),
      ),
    );
  }

  void _editMember(Member member) {
    Navigator.pushNamed(
      context,
      '/editmember',
      arguments: member, // Meneruskan data anggota sebagai argumen
    );
  }

  void _confirmDeleteMember(Member member) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Deposito'),
          content: const Text('Are you sure to delete this Deposito?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                _deleteMember(member.id); // Hapus anggota
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteMember(int id) async {
    try {
      final response = await _dio.delete(
        '$_apiUrl/anggota/$id',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      print(response.data);
      Navigator.pushNamed(context, '/member');
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Delete failed. Please login again',
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
        title: const Text('Deposito'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/addmember');
            },
            icon: const Icon(Icons.add),
            iconSize: 35,
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchKeyword = value.toLowerCase();
                });
              },
              style: blackTextStyle.copyWith(
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _members.length,
              itemBuilder: (context, index) {
                final member = _members[index];
                if (_searchKeyword.isEmpty ||
                    member.name.toLowerCase().contains(_searchKeyword) ||
                    member.alamat.toLowerCase().contains(_searchKeyword) || member.nomorInduk.toString().contains(_searchKeyword)) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5), // Tambahkan padding di sini
                    child: Card(
                      child: ListTile(
                        title: Text(
                          member.name,
                          style: blackTextStyle.copyWith(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          // '${member.alamat}',
                          // style: blackTextStyle.copyWith(fontSize: 14),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              member.alamat,
                              style: blackTextStyle.copyWith(fontSize: 14),
                            ),
                            Text(
                              '${member.nomorInduk}',
                              style: blackTextStyle.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                _editMember(member);
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                _confirmDeleteMember(member);
                              },
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                            ),
                          ],
                        ),
                        onTap: () {
                          _showMemberDetail(member);
                        },
                      ),
                    ),
                  );
                } else {
                  // Jika anggota tidak cocok dengan pencarian, kembalikan widget kosong
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Model data untuk anggota
class Member {
  final int id;
  final int nomorInduk;
  final String name;
  final String alamat;
  final String tanggalLahir;
  final String telepon;
  final int statusAktif;

  Member({
    required this.id,
    required this.nomorInduk,
    required this.name,
    required this.alamat,
    required this.tanggalLahir,
    required this.telepon,
    required this.statusAktif,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      nomorInduk: json['nomor_induk'],
      name: json['nama'],
      alamat: json['alamat'],
      tanggalLahir: json['tgl_lahir'],
      telepon: json['telepon'],
      statusAktif: json['status_aktif'],
    );
  }
}
