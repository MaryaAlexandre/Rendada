import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/peca_api.dart';
import '../services/api_exceptions.dart';
import '../services/api_service.dart';
import '../services/preferencias_service.dart';
import '../stores/auth_store.dart';
import '../theme/app_colors.dart';
import 'home_screen.dart';
import 'login_screen.dart';

/// Consulta ao endpoint protegido
class ConsultaScreen extends StatefulWidget {
  const ConsultaScreen({super.key});

  @override
  State<ConsultaScreen> createState() => _ConsultaScreenState();
}

class _ConsultaScreenState extends State<ConsultaScreen> {
  final _prefs = PreferenciasService();
  final _buscaController = TextEditingController();

  List<PecaApi> _pecas = [];
  bool _carregando = true;
  String? _erro;
  String? _token;

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _iniciar() async {
    final auth = context.read<AuthStore>();
    _buscaController.text = await _prefs.lerUltimaBusca();
    _token = await auth.tokenAtual();
    await _carregar();
  }

  // GET protegido
  Future<void> _carregar({ModoTeste modo = ModoTeste.normal}) async {
    if (!mounted) return;
    setState(() {
      _carregando = true;
      _erro = null;
    });

    final auth = context.read<AuthStore>();
    try {
      final lista = await auth.api.buscarPecas(modo: modo);
      if (!mounted) return;
      setState(() => _pecas = lista);
    } on TokenExpiradoException catch (e) {
      // 401: apaga o token e volta ao login
      await auth.sair();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen(mensagem: e.mensagem)),
            (route) => false,
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _erro = e.mensagem);
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  // testes
  Future<void> _executarTeste(String teste) async {
    final auth = context.read<AuthStore>();
    switch (teste) {
      case 'token':
        try {
          await auth.corromperToken();
        } on ApiException catch (e) {
          setState(() => _erro = e.mensagem);
          return;
        }
        await _carregar();
      case 'timeout':
        await _carregar(modo: ModoTeste.timeout);
      case 'json':
        await _carregar(modo: ModoTeste.jsonInvalido);
    }
  }

  Future<void> _sair() async {
    await context.read<AuthStore>().sair();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  List<PecaApi> get _filtrados {
    final termo = _buscaController.text.trim().toLowerCase();
    if (termo.isEmpty) return _pecas;
    return _pecas
        .where((p) => p.nome.toLowerCase().contains(termo) || p.categoria.toLowerCase().contains(termo))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final nome = context.watch<AuthStore>().nome;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        title: Text('Garimpo online', style: GoogleFonts.bevan(color: AppColors.terracota, fontSize: 18)),
        actions: [
          IconButton(
            tooltip: 'Meus achados',
            icon: const Icon(Icons.home_outlined, color: AppColors.bordo),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen())),
          ),
          PopupMenuButton<String>(
            tooltip: 'Testes de erro',
            icon: const Icon(Icons.bug_report_outlined, color: AppColors.bordo),
            onSelected: _executarTeste,
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'token', child: Text('Simular token inválido (401)')),
              PopupMenuItem(value: 'timeout', child: Text('Simular timeout')),
              PopupMenuItem(value: 'json', child: Text('Simular JSON inválido')),
            ],
          ),
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout, color: AppColors.descTxt),
            onPressed: _sair,
          ),
        ],
      ),
      body: Column(
        children: [
          // sessão
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.condBg, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                const Icon(Icons.verified_user_outlined, color: AppColors.condTxt),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${nome.isEmpty ? 'Sessão ativa' : 'Oi, $nome!'} Token salvo no flutter_secure_storage: '
                        '${_token == null ? '...' : '${_token!.substring(0, _token!.length < 16 ? _token!.length : 16)}…'}',
                    style: const TextStyle(fontSize: 12, color: AppColors.condTxt),
                  ),
                ),
              ],
            ),
          ),
          // busca
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _buscaController,
              onChanged: (_) => setState(() {}),
              onSubmitted: _prefs.salvarUltimaBusca,
              decoration: InputDecoration(
                hintText: 'Buscar (a última busca fica no SharedPreferences)',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.searchBg,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: _conteudo()),
        ],
      ),
    );
  }

  Widget _conteudo() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator(color: AppColors.terracota));
    }

    if (_erro != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 48, color: AppColors.descTxt),
              const SizedBox(height: 12),
              Text(_erro!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.texto)),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _carregar,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar de novo'),
              ),
            ],
          ),
        ),
      );
    }

    final itens = _filtrados;
    if (itens.isEmpty) {
      return const Center(child: Text('Nenhuma peça encontrada.', style: TextStyle(color: AppColors.muted)));
    }

    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        itemCount: itens.length,
        separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.linha),
        itemBuilder: (_, i) {
          final p = itens[i];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 4),
            leading: const CircleAvatar(
              backgroundColor: AppColors.bege,
              child: Icon(Icons.checkroom, color: AppColors.bordo),
            ),
            title: Text(p.nome, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text('${p.categoria} · Tam. ${p.tamanho} · ${p.condicao} · ${p.status}'),
            trailing: Text('R\$ ${p.preco.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.terracota)),
          );
        },
      ),
    );
  }
}