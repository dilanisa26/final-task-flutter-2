part of 'pages.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5ECED), // Latar belakang menggunakan warna #F5ECED yang cerah dan lembut
      body: Center( // Memastikan konten berada di tengah layar
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0), // Margin horizontal
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, // Menjaga agar konten tetap rata tengah
              children: [
                // Menambahkan ruang vertikal sebelum gambar
                const SizedBox(height: 40),

                // Gambar dengan ukuran lebih kecil
                Image.asset(
                  'assets/images/celengan4.png', // Gambar yang baru
                  height: 150, // Ukuran gambar yang lebih kecil
                  fit: BoxFit.fill,
                ),

                // Memberikan jarak sebelum tombol
                const SizedBox(height: 40),

                // Menampilkan tombol Login dan Register
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Tombol Login
                    SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6582AE), // Warna tombol Login dengan #6582AE (biru gelap)
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5, // Menambahkan sedikit bayangan untuk efek 3D
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white, // Teks berwarna putih agar kontras dengan tombol
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Jarak antara tombol login dan register
                    // Tombol Register
                    SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF7FA1C4), // Warna tombol Register dengan #7FA1C4 (biru muda)
                          elevation: 5, // Menambahkan sedikit bayangan untuk efek 3D
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white, // Teks berwarna putih
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40), // Memberikan ruang vertikal agar komponen tidak terlalu padat
              ],
            ),
          ),
        ),
      ),
    );
  }
}
