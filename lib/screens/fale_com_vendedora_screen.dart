import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/peca.dart';
import '../stores/favoritos_store.dart';
import '../theme/app_colors.dart';

/// Atividade 2: tela interativa cobrindo os 5 tipos de evento pedidos.
class FaleComVendedoraScreen extends StatefulWidget {
  final Peca peca;
  const FaleComVendedoraScreen({super.key, required this.peca});

  @override
  State<FaleComVendedoraScreen> createState() => _FaleComVendedoraScreenState();
}

class _FaleComVendedoraScreenState extends State<FaleComVendedoraScreen> {
  final _controller = TextEditingController();
  String _mensagem = '';

  bool get _mensagemValida => _mensagem.trim().length >= 10;

  // evento 1: TextField -> onChanged
  void _aoDigitar(String valor) {
    setState(() => _mensagem = valor);
    // ignore: avoid_print
    print('Mensagem digitada: $valor (${valor.length} caracteres)');
  }

  // evento 2: botão principal -> onPressed, com condição e encadeamento
  void _enviarMensagem() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mensagem enviada pra vendedora!'), backgroundColor: AppColors.bordo),
    );

    // encadeamento: enviar -> SnackBar -> depois abre um AlertDialog
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Bora garimpar!'),
          content: const Text('A vendedora costuma responder em até 1 dia.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _limparCampo(); // encadeamento 2: fechar o alerta já limpa o campo
              },
              child: const Text('Entendi'),
            ),
          ],
        ),
      );
    });
  }

  // evento 3: botão secundário -> comportamento e feedback diferentes
  void _limparCampo() {
    _controller.clear();
    setState(() => _mensagem = '');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Campo limpo.'), duration: Duration(seconds: 1)),
    );
  }

  // evento 4a: gesto simples
  void _aoTocarNaPeca() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.peca.nome} · toque simples'), duration: const Duration(seconds: 1)),
    );
  }

  // evento 4b: gesto longo -> resposta diferente do toque
  void _aoSegurarNaPeca() {
    final store = context.read<FavoritosStore>();
    store.alternar(widget.peca);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(store.isFavorita(widget.peca) ? 'Adicionada aos favoritos!' : 'Removida dos favoritos.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoritada = context.watch<FavoritosStore>().isFavorita(widget.peca);
    return Scaffold(
      appBar: AppBar(title: const Text('Fale com a vendedora')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _aoTocarNaPeca,
              onLongPress: _aoSegurarNaPeca,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.bege,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: favoritada ? AppColors.terracota : Colors.transparent, width: 2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.checkroom, color: AppColors.bordo),
                    const SizedBox(width: 10),
                    Expanded(child: Text(widget.peca.nome)),
                    Icon(favoritada ? Icons.favorite : Icons.favorite_border, color: AppColors.terracota),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text('Toque pra ver a peça, segure pra favoritar.',
                style: TextStyle(fontSize: 12, color: AppColors.muted)),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              onChanged: _aoDigitar,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Sua mensagem',
                helperText: _mensagemValida ? 'Pronto pra enviar!' : 'Mínimo de 10 caracteres (${_mensagem.length}/10)',
                helperStyle: TextStyle(color: _mensagemValida ? AppColors.condTxt : AppColors.muted2),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.terracota, foregroundColor: Colors.white),
                    onPressed: _mensagemValida ? _enviarMensagem : null,
                    child: const Text('Enviar mensagem'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(onPressed: _limparCampo, child: const Text('Limpar')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}