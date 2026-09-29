import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/peca.dart';
import 'nova_peca_screen.dart';
import 'detalhe_peca_screen.dart';
import 'favoritos_screen.dart';
import 'perfil_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String categoriaSelecionada = 'Todas';
  final categorias = ['Todas', 'Vestidos', 'Blusas', 'Calças'];

  final List<Peca> pecas = [
    Peca(nome: 'Vestido floral', categoria: 'Vestido', tamanho: 'M', preco: 45, precoOriginal: 75, condicao: 'Poucos usos'),
    Peca(nome: 'Blusa de renda', categoria: 'Blusa', tamanho: 'P', preco: 30, status: 'vendida'),
    Peca(nome: 'Calça jeans', categoria: 'Calça', tamanho: 'G', preco: 55, precoOriginal: 90, condicao: 'Seminova'),
    Peca(nome: 'Saia jeans', categoria: 'Calça', tamanho: 'M', preco: 38),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width >= 900 ? 4 : (width >= 600 ? 3 : 2);
    final aspectRatio = width >= 600 ? 0.85 : 0.72;
    final hPad = width >= 600 ? 32.0 : 16.0;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
                    child: Row(
                      children: [
                        const Icon(Icons.flutter_dash, size: 20, color: Color(0xFF7A2E2E)),
                        const SizedBox(width: 4),
                        Text('Rendada', style: GoogleFonts.bevan(fontSize: 22, color: const Color(0xFFC1502E))),
                        const SizedBox(width: 2),
                        const Icon(Icons.auto_awesome, size: 14, color: Color(0xFFF0A202)),
                      ],
                    ),
                  ),
                  const Icon(Icons.notifications_none, color: Color(0xFF7A2E2E)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text('Oi, flor! Bora garimpar hoje?', style: TextStyle(fontSize: 13, color: Color(0xFF8A7B6C))),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Garimpar peça...',
                  hintStyle: const TextStyle(color: Color(0xFFA89985)),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFFA89985)),
                  filled: true,
                  fillColor: const Color(0xFFF5EEE2),
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 12),
              color: const Color(0xFF2A9D8F),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Garimpo da semana', style: TextStyle(fontSize: 12, color: Color(0xFFDFF4F1))),
                      Text('até 30% off', style: GoogleFonts.bevan(fontSize: 18, color: Colors.white)),
                    ],
                  ),
                  const Icon(Icons.sell_outlined, color: Colors.white, size: 26),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text('Meus achados', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF3A2A1F))),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 34,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: hPad),
                itemCount: categorias.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final selecionada = categorias[i] == categoriaSelecionada;
                  return GestureDetector(
                    onTap: () => setState(() => categoriaSelecionada = categorias[i]),
                    child: Chip(
                      label: Text(categorias[i], style: TextStyle(color: selecionada ? Colors.white : const Color(0xFF7A6B5C))),
                      backgroundColor: selecionada ? const Color(0xFFC1502E) : Colors.white,
                      side: BorderSide(color: selecionada ? Colors.transparent : const Color(0xFFEADFC8)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 16),
                itemCount: pecas.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: aspectRatio),
                itemBuilder: (context, index) {
                  final peca = pecas[index];
                  final vendida = peca.status == 'vendida';
                  final paleta = [
                    (const Color(0xFFFBE4E8), const Color(0xFFC23A55)), // rosa
                    (const Color(0xFFFCE9C7), const Color(0xFF8A5A02)), // mostarda
                    (const Color(0xFFE0F2EF), const Color(0xFF2A9D8F)), // turquesa
                  ];
                  final (corFundo, corTexto) = paleta[index % paleta.length];
                  return GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetalhePecaScreen(peca: peca))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(color: const Color(0xFFEADFC8), borderRadius: BorderRadius.circular(14)),
                                child: const Icon(Icons.checkroom, color: Color(0xFF7A2E2E), size: 32),
                              ),
                              if (peca.percentualDesconto != null)
                                Positioned(
                                  top: 6, left: 6,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: corFundo, borderRadius: BorderRadius.circular(6)),
                                    child: Text('-${peca.percentualDesconto}%', style: TextStyle(fontSize: 11, color: corTexto)),
                                  ),
                                ),
                              if (vendida)
                                Positioned(
                                  top: 6, left: 6,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: const Color(0xFFEDEDE8), borderRadius: BorderRadius.circular(6)),
                                    child: const Text('Essa já voou!', style: TextStyle(fontSize: 10, color: Color(0xFF8A8A85))),
                                  ),
                                ),
                              Positioned(
                                top: 6, right: 6,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                  child: const Icon(Icons.favorite_border, size: 12, color: Color(0xFFC1502E)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(peca.nome, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                        Row(
                          children: [
                            Text('R\$ ${peca.preco.toStringAsFixed(0)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                            if (peca.precoOriginal != null) ...[
                              const SizedBox(width: 5),
                              Text('R\$ ${peca.precoOriginal!.toStringAsFixed(0)}',
                                  style: const TextStyle(fontSize: 11, color: Color(0xFFB5A894), decoration: TextDecoration.lineThrough)),
                            ],
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFC1502E),
        shape: const CircleBorder(),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NovaPecaScreen())),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(Icons.home, color: Color(0xFFC1502E)),
            const Icon(Icons.search, color: Color(0xFFB8AB98)),
            const SizedBox(width: 40),
            IconButton(
              icon: const Icon(Icons.favorite_border, color: Color(0xFFB8AB98)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritosScreen())),
            ),
            IconButton(
              icon: const Icon(Icons.person_outline, color: Color(0xFFB8AB98)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PerfilScreen())),
            ),
          ],
        ),
      ),
    );
  }
}
