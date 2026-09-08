import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Widget _bandeirinha(Color cor) {
    return ClipPath(
      clipper: _TrianguloClipper(),
      child: Container(width: 16, height: 22, color: cor),
    );
  }

  Widget _dot(Color cor, double tamanho) => Container(
      width: tamanho, height: tamanho, decoration: BoxDecoration(color: cor, shape: BoxShape.circle));

  @override
  Widget build(BuildContext context) {
    final cores = [
      const Color(0xFFF0A202),
      const Color(0xFFE85D75),
      const Color(0xFF2A9D8F),
      const Color(0xFFC1502E),
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(8, (i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: _bandeirinha(cores[i % cores.length]),
              )),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: const BoxDecoration(
                color: Color(0xFFC1502E),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 140, height: 140,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.checkroom, size: 60, color: Color(0xFFC1502E)),
                    ),
                    Positioned(top: -4, right: 6, child: _dot(const Color(0xFFF0A202), 14)),
                    Positioned(bottom: 4, left: -8, child: _dot(const Color(0xFFE85D75), 12)),
                    Positioned(bottom: -8, right: 30, child: _dot(const Color(0xFF2A9D8F), 10)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text('Moda circular,\norgulho nordestino.',
                textAlign: TextAlign.center,
                style: GoogleFonts.bevan(fontSize: 26, color: const Color(0xFF3A2A1F), height: 1.35)),
            const SizedBox(height: 10),
            const Text('Desapegos com borogodó.', style: TextStyle(fontSize: 14, color: Color(0xFF8A7B6C))),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC1502E),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                ),
                onPressed: () => Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => const HomeScreen())),
                child: const Text('Bora garimpar!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 20, height: 8, decoration: BoxDecoration(color: const Color(0xFFC1502E), borderRadius: BorderRadius.circular(4))),
                const SizedBox(width: 6),
                Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFEADFC8), shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFEADFC8), shape: BoxShape.circle)),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _TrianguloClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}