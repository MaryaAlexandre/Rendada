import 'package:flutter/material.dart';
import '../models/peca.dart';
import '../theme/app_colors.dart';
import 'fale_com_vendedora_screen.dart';

/// Atividade 1: StatelessWidget, sem lógica de negócio/API/persistência.
/// Estrutura em 3 seções (cabeçalho, conteúdo, rodapé) e responsivo via LayoutBuilder.
class DetalhePecaScreen extends StatelessWidget {
  final Peca peca;
  const DetalhePecaScreen({super.key, required this.peca});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final telaEstreita = constraints.maxWidth < 600;
            return telaEstreita ? _LayoutRetrato(peca: peca) : _LayoutPaisagem(peca: peca);
          },
        ),
      ),
    );
  }
}

// Celular: cabeçalho, conteúdo e rodapé empilhados numa Column.
class _LayoutRetrato extends StatelessWidget {
  final Peca peca;
  const _LayoutRetrato({required this.peca});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Cabecalho(peca: peca, altura: 280),
        Expanded(child: SingleChildScrollView(child: _Conteudo(peca: peca))),
        _Rodape(peca: peca),
      ],
    );
  }
}

// Tablet/web: foto de um lado, conteúdo+rodapé do outro.
class _LayoutPaisagem extends StatelessWidget {
  final Peca peca;
  const _LayoutPaisagem({required this.peca});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: _Cabecalho(peca: peca, altura: double.infinity)),
        Expanded(
          child: Column(
            children: [
              Expanded(child: SingleChildScrollView(child: _Conteudo(peca: peca))),
              _Rodape(peca: peca),
            ],
          ),
        ),
      ],
    );
  }
}

/// ---------------- Seção 1: Cabeçalho ----------------
class _Cabecalho extends StatelessWidget {
  final Peca peca;
  final double altura;
  const _Cabecalho({required this.peca, required this.altura});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: altura,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.bege,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: const Center(child: Icon(Icons.checkroom, size: 64, color: AppColors.bordo)),
          ),
          Positioned(top: 16, left: 16, child: _botaoCirculo(context, Icons.arrow_back, AppColors.texto)),
          Positioned(top: 16, right: 16, child: _botaoCirculo(context, Icons.favorite_border, AppColors.terracota)),
        ],
      ),
    );
  }

  Widget _botaoCirculo(BuildContext context, IconData icon, Color cor) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: icon == Icons.arrow_back ? () => Navigator.pop(context) : null,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: cor),
      ),
    );
  }
}

/// ---------------- Seção 2: Conteúdo ----------------
class _Conteudo extends StatelessWidget {
  final Peca peca;
  const _Conteudo({required this.peca});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(peca.categoria, style: const TextStyle(fontSize: 13, color: AppColors.muted2)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.condBg, borderRadius: BorderRadius.circular(10)),
                child: Text(peca.condicao, style: const TextStyle(fontSize: 12, color: AppColors.condTxt)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(peca.nome, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.texto)),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (peca.precoOriginal != null) ...[
                Text(
                  'R\$ ${peca.precoOriginal!.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 15, color: AppColors.muted2, decoration: TextDecoration.lineThrough),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                'R\$ ${peca.preco.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: AppColors.texto),
              ),
              if (peca.percentualDesconto != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.descBg, borderRadius: BorderRadius.circular(10)),
                  child: Text('-${peca.percentualDesconto}%', style: const TextStyle(fontSize: 12, color: AppColors.descTxt)),
                ),
              ],
            ],
          ),
          const SizedBox(height: 18),
          const Text('Tamanho', style: TextStyle(fontSize: 13, color: AppColors.muted2)),
          const SizedBox(height: 8),
          Row(
            children: ['P', 'M', 'G'].map((t) {
              final selecionado = t == peca.tamanho;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: selecionado ? AppColors.terracota : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: selecionado ? Colors.transparent : AppColors.bege),
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
              const Icon(Icons.sell_outlined, size: 18, color: AppColors.muted),
              const SizedBox(width: 8),
              Text('${peca.categoria} · Tam. ${peca.tamanho}', style: const TextStyle(fontSize: 14, color: AppColors.texto)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.autorenew, size: 18, color: AppColors.muted),
              const SizedBox(width: 8),
              Text('Moda circular · ${peca.condicao.toLowerCase()}', style: const TextStyle(fontSize: 14, color: AppColors.texto)),
            ],
          ),
        ],
      ),
    );
  }
}

/// ---------------- Seção 3: Rodapé ----------------
/// Botão leva pra tela de eventos (Atividade 2) em vez de simular venda aqui,
/// já que esta tela não deve ter lógica de negócio.
class _Rodape extends StatelessWidget {
  final Peca peca;
  const _Rodape({required this.peca});

  @override
  Widget build(BuildContext context) {
    if (peca.status == 'vendida') {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.linha)),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(color: AppColors.soldBg, borderRadius: BorderRadius.circular(26)),
          child: const Text('Essa já voou!', style: TextStyle(color: AppColors.soldTxt, fontWeight: FontWeight.w600)),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.linha)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.bege)),
            child: const Icon(Icons.favorite_border, color: AppColors.bordo),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.bordo,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FaleComVendedoraScreen(nomePeca: peca.nome)),
              ),
              child: const Text('Falar com a vendedora', overflow: TextOverflow.ellipsis),
            ),
          ),
        ],
      ),
    );
  }
}

