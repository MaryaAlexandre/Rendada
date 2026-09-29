import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class _Venda {
  final String nome;
  final String data;
  final double preco;
  final String status;
  const _Venda(this.nome, this.data, this.preco, this.status);
}

class HistoricoVendasScreen extends StatelessWidget {
  const HistoricoVendasScreen({super.key});

  static const _vendas = [
    _Venda('Blusa de renda', '02/09', 30, 'Entregue'),
    _Venda('Saia midi', '28/08', 42, 'Enviado'),
    _Venda('Bolsa de palha', '20/08', 25, 'Entregue'),
    _Venda('Sandália rasteira', '15/08', 18, 'Entregue'),
  ];

  @override
  Widget build(BuildContext context) {
    final total = _vendas.fold<double>(0, (soma, v) => soma + v.preco);
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.texto),
        title: Text('HISTÓRICO DE VENDAS', style: GoogleFonts.bevan(fontSize: 16, color: AppColors.terracota)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.turquesa, borderRadius: BorderRadius.circular(16)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.inventory_2_outlined, color: Colors.white, size: 28),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total vendido', style: TextStyle(color: Color(0xFFDFF4F1), fontSize: 12)),
                          Text('R\$ ${total.toStringAsFixed(0)}',
                              style: GoogleFonts.bevan(fontSize: 22, color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                  Text('${_vendas.length} peças vendidas', style: const TextStyle(color: Color(0xFFDFF4F1), fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: _vendas.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final v = _vendas[i];
                  final entregue = v.status == 'Entregue';
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.linha),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(color: AppColors.bege, borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.checkroom, color: AppColors.bordo),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(v.nome, style: const TextStyle(fontWeight: FontWeight.w500)),
                              Text('Vendida em ${v.data}', style: const TextStyle(fontSize: 12, color: AppColors.muted2)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('R\$ ${v.preco.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: entregue ? AppColors.condBg : const Color(0xFFFCE9C7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(v.status,
                                  style: TextStyle(fontSize: 11, color: entregue ? AppColors.condTxt : const Color(0xFF8A5A02))),
                            ),
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
    );
  }
}

