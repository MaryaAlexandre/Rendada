import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/peca.dart';
import '../theme/app_colors.dart';

class FavoritosScreen extends StatelessWidget {
  const FavoritosScreen({super.key});

  static final _favoritas = [
    Peca(nome: 'Vestido floral', categoria: 'Vestido', tamanho: 'M', preco: 45, precoOriginal: 75),
    Peca(nome: 'Calça jeans', categoria: 'Calça', tamanho: 'G', preco: 55, precoOriginal: 90),
    Peca(nome: 'Saia midi', categoria: 'Calça', tamanho: 'M', preco: 42),
    Peca(nome: 'Blusa de renda', categoria: 'Blusa', tamanho: 'P', preco: 30),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.flutter_dash, size: 18, color: AppColors.bordo),
                        const SizedBox(width: 4),
                        Text('Rendada', style: GoogleFonts.bevan(fontSize: 18, color: AppColors.terracota)),
                        const SizedBox(width: 2),
                        const Icon(Icons.auto_awesome, size: 12, color: AppColors.mostarda),
                      ],
                    ),
                  ),
                  const Icon(Icons.notifications_none, color: AppColors.bordo),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text('FAVORITOS', style: GoogleFonts.bevan(fontSize: 24, color: AppColors.terracota)),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 0),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.rosa,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${_favoritas.length} PEÇAS SALVAS',
                      style: GoogleFonts.bevan(fontSize: 15, color: Colors.white)),
                  const Icon(Icons.favorite, color: Colors.white),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _favoritas.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.78),
                itemBuilder: (context, index) {
                  final peca = _favoritas[index];
                  final paleta = [
                    (const Color(0xFFFBE4E8), const Color(0xFFC23A55)),
                    (const Color(0xFFFCE9C7), const Color(0xFF8A5A02)),
                    (const Color(0xFFE0F2EF), const Color(0xFF2A9D8F)),
                  ];
                  final (corFundo, corTexto) = paleta[index % paleta.length];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(color: AppColors.bege, borderRadius: BorderRadius.circular(14)),
                              child: const Icon(Icons.checkroom, color: AppColors.bordo, size: 32),
                            ),
                            if (peca.percentualDesconto != null)
                              Positioned(
                                top: 6,
                                left: 6,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: corFundo, borderRadius: BorderRadius.circular(6)),
                                  child: Text('-${peca.percentualDesconto}%', style: TextStyle(fontSize: 11, color: corTexto)),
                                ),
                              ),
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                child: const Icon(Icons.favorite, size: 12, color: AppColors.terracota),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(peca.nome, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                      Row(
                        children: [
                          Text('R\$ ${peca.preco.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          if (peca.precoOriginal != null) ...[
                            const SizedBox(width: 5),
                            Text('R\$ ${peca.precoOriginal!.toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 11, color: AppColors.muted2, decoration: TextDecoration.lineThrough)),
                          ],
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

