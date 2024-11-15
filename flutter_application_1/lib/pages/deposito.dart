part of 'pages.dart';

class DepositoPage extends StatefulWidget {
  const DepositoPage({super.key});

  @override
  _DepositoPageState createState() => _DepositoPageState();
}

class _DepositoPageState extends State<DepositoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2DAD7),  // Latar belakang menggunakan warna #E2DAD7 (light beige)
      appBar: AppBar(
        title: const Text(
          'Deposito',
          style: TextStyle(color: Colors.white),  // Teks AppBar berwarna putih
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false);
          },
        ),
        backgroundColor: const Color(0xFF6582AE),  // Warna AppBar menggunakan #6582AE (biru gelap)
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tombol List Deposito dengan Ikon
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/list-deposito');
              },
              icon: const Icon(Icons.list_alt, color: Colors.white), // Ikon List
              label: const Text(
                'List Deposito',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7FA1C4),  // Tombol menggunakan warna #7FA1C4 (biru muda)
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),  // Lebar penuh
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),  // Sudut sedikit melengkung
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Detail Deposito User dengan Ikon
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/detail-deposito-user',
                  arguments: {
                    'deposit_id': '123',
                    'account_id': '456',
                    'deposit_name': 'Deposito A',
                    'amount': 1000000,
                    'time_period': 12,
                    'time_stamp': DateTime.now().toString(),
                  },
                );
              },
              icon: const Icon(Icons.details, color: Colors.white), // Ikon Detail
              label: const Text(
                'Detail Deposito User',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7FA1C4),  // Tombol menggunakan warna #7FA1C4 (biru muda)
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),  // Lebar penuh
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),  // Sudut sedikit melengkung
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Add Deposito dengan Ikon
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/adddeposito');
              },
              icon: const Icon(Icons.add_circle_outline, color: Colors.white), // Ikon Add
              label: const Text(
                'Add Deposito',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6582AE),  // Tombol menggunakan warna #6582AE (biru gelap)
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),  // Lebar penuh
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),  // Sudut sedikit melengkung
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
