import 'package:flutter/material.dart';

class NovaPecaScreen extends StatefulWidget {
  const NovaPecaScreen({super.key});
  @override
  State<NovaPecaScreen> createState() => _NovaPecaScreenState();
}

class _NovaPecaScreenState extends State<NovaPecaScreen> {
  String categoria = 'Vestido';
  String tamanho = 'M';
  final categorias = ['Vestido', 'Blusa', 'Calça'];
  final tamanhos = ['P', 'M', 'G'];

  Widget _chip(String label, bool selecionado, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selecionado ? const Color(0xFFC1502E) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selecionado ? Colors.transparent : const Color(0xFFEADFC8)),
        ),
        child: Text(label, style: TextStyle(color: selecionado ? Colors.white : const Color(0xFF7A6B5C), fontSize: 12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF3A2A1F)),
        title: const Text('Nova peça', style: TextStyle(color: Color(0xFF3A2A1F))),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(color: const Color(0xFFEADFC8), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.add_a_photo_outlined, color: Color(0xFF7A2E2E)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(child: Container(height: 90, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE0D3BE))))),
                const SizedBox(width: 8),
                Expanded(child: Container(height: 90, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE0D3BE))))),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Categoria', style: TextStyle(fontSize: 12, color: Color(0xFFA89985))),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: categorias.map((c) => _chip(c, c == categoria, () => setState(() => categoria = c))).toList()),
            const SizedBox(height: 16),
            const Text('Tamanho', style: TextStyle(fontSize: 12, color: Color(0xFFA89985))),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: tamanhos.map((t) => _chip(t, t == tamanho, () => setState(() => tamanho = t))).toList()),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nome da peça',
                filled: true,
                fillColor: const Color(0xFFF5EEE2),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Preço',
                prefixText: 'R\$ ',
                filled: true,
                fillColor: const Color(0xFFF5EEE2),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC1502E),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Publicar peça'),
            ),
          ],
        ),
      ),
    );
  }
}