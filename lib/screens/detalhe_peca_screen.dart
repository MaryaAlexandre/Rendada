import 'package:flutter/material.dart';
import '../models/peca.dart';

class DetalhePecaScreen extends StatefulWidget {
  final Peca peca;
  const DetalhePecaScreen({super.key, required this.peca});
  @override
  State<DetalhePecaScreen> createState() => _DetalhePecaScreenState();
}

class _DetalhePecaScreenState extends State<DetalhePecaScreen> {
  bool mostrarCep = false;
  final cepController = TextEditingController();
  final tamanhos = ['P', 'M', 'G'];

  Widget _iconCircle(IconData icon, Color color) => Container(
    padding: const EdgeInsets.all(6),
    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
    child: Icon(icon, size: 18, color: color),
  );

  @override
  Widget build(BuildContext context) {
    final peca = widget.peca;
    final vendida = peca.status == 'vendida';

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Container(
                  height: 260,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEADFC8),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                  ),
                  child: const Center(child: Icon(Icons.checkroom, size: 64, color: Color(0xFF7A2E2E))),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: _iconCircle(Icons.arrow_back, const Color(0xFF3A2A1F)),
                  ),
                ),
                Positioned(top: 16, right: 16, child: _iconCircle(Icons.favorite_border, const Color(0xFFC1502E))),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(peca.categoria, style: const TextStyle(fontSize: 13, color: Color(0xFFA89985))),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFE3F3F1), borderRadius: BorderRadius.circular(10)),
                        child: Text(peca.condicao, style: const TextStyle(fontSize: 12, color: Color(0xFF1F7A6E))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(peca.nome, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFF3A2A1F))),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (peca.precoOriginal != null) ...[
                        Text(
                          'R\$ ${peca.precoOriginal!.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 15, color: Color(0xFFA89985), decoration: TextDecoration.lineThrough),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        'R\$ ${peca.preco.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Color(0xFF3A2A1F)),
                      ),
                      if (peca.percentualDesconto != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFFFBE4E8), borderRadius: BorderRadius.circular(10)),
                          child: Text('-${peca.percentualDesconto}%', style: const TextStyle(fontSize: 12, color: Color(0xFFC23A55))),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text('Tamanho', style: TextStyle(fontSize: 13, color: Color(0xFFA89985))),
                  const SizedBox(height: 8),
                  Row(
                    children: tamanhos.map((t) {
                      final selecionado = t == peca.tamanho;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: selecionado ? const Color(0xFFC1502E) : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(color: selecionado ? Colors.transparent : const Color(0xFFEADFC8)),
                          ),
                          alignment: Alignment.center,
                          child: Text(t, style: TextStyle(color: selecionado ? Colors.white : const Color(0xFF7A6B5C))),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      const Icon(Icons.sell_outlined, size: 18, color: Color(0xFF8A7B6C)),
                      const SizedBox(width: 8),
                      Text('${peca.categoria} · Tam. ${peca.tamanho}', style: const TextStyle(fontSize: 14, color: Color(0xFF3A2A1F))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.autorenew, size: 18, color: Color(0xFF8A7B6C)),
                      const SizedBox(width: 8),
                      Text('Moda circular · ${peca.condicao.toLowerCase()}', style: const TextStyle(fontSize: 14, color: Color(0xFF3A2A1F))),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (mostrarCep) ...[
                    const Text('CEP do comprador:'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: cepController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: '59000-000'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Buscar endereço'),
                    ),
                    const SizedBox(height: 80),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: vendida
          ? null
          : Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFEFE0CB))),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFEADFC8)),
              ),
              child: const Icon(Icons.favorite_border, color: Color(0xFF7A2E2E)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A2E2E),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                ),
                onPressed: () => setState(() => mostrarCep = true),
                child: const Text('Marcar como vendida', overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        ),
      ),
    );
  }
}