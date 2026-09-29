import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class SobreScreen extends StatelessWidget {
  const SobreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.texto),
        title: Text('SOBRE', style: GoogleFonts.bevan(fontSize: 18, color: AppColors.terracota)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(color: AppColors.terracota, shape: BoxShape.circle),
              child: const Icon(Icons.checkroom, color: Colors.white, size: 40),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: GestureDetector(
              onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.flutter_dash, size: 20, color: AppColors.bordo),
                  const SizedBox(width: 4),
                  Text('RENDADA', style: GoogleFonts.bevan(fontSize: 22, color: AppColors.terracota)),
                  const SizedBox(width: 2),
                  const Icon(Icons.auto_awesome, size: 14, color: AppColors.mostarda),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Center(child: Text('Versão 1.0.0', style: TextStyle(fontSize: 12, color: AppColors.muted))),
          const SizedBox(height: 16),
          const Center(
            child: Text('Moda circular, afeto regional.',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.texto)),
          ),
          const SizedBox(height: 16),
          const Text(
            'O Rendada é um app de brechó feito com orgulho nordestino, pra dar uma segunda vida a peças de roupa com muito borogodó.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.muted2, height: 1.5),
          ),
          const SizedBox(height: 24),
          _linkRow(Icons.description_outlined, 'Termos de uso'),
          _linkRow(Icons.lock_outline, 'Política de privacidade'),
          _linkRow(Icons.info_outline, 'Fale conosco'),
          const SizedBox(height: 40),
          const Center(
            child: Text('Feito com carinho no Nordeste', style: TextStyle(fontSize: 11, color: AppColors.muted2)),
          ),
          const Center(
            child: Text('Marya Eduarda Alexandre · IFRN', style: TextStyle(fontSize: 11, color: AppColors.muted2)),
          ),
        ],
      ),
    );
  }

  Widget _linkRow(IconData icon, String label) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppColors.bordo),
          title: Text(label),
          trailing: const Icon(Icons.chevron_right, color: AppColors.muted2),
          onTap: () {},
        ),
        const Divider(height: 1, color: AppColors.linha),
      ],
    );
  }
}

