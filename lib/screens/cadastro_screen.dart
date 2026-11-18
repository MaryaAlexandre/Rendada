import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/usuario_atual.dart';
import '../stores/auth_store.dart';
import '../theme/app_colors.dart';
import 'consulta_screen.dart';
import 'login_screen.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});
  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  bool _aceitouTermos = false;
  String? _erroLocal;
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<AuthStore>().limparErro());
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  InputDecoration _campo(String label) => InputDecoration(
    labelText: label,
    filled: true,
    fillColor: AppColors.searchBg,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
  );

  // cadastra na API
  Future<void> _criarConta() async {
    final nome = _nomeController.text.trim();
    final email = _emailController.text.trim();
    final senha = _senhaController.text;

    // validação local
    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      setState(() => _erroLocal = 'Preencha todos os campos.');
      return;
    }
    if (senha != _confirmarController.text) {
      setState(() => _erroLocal = 'As senhas não conferem.');
      return;
    }
    setState(() => _erroLocal = null);

    final ok = await context.read<AuthStore>().cadastrar(nome, email, senha);
    if (!mounted || !ok) return;

    UsuarioAtual.nome = nome;
    UsuarioAtual.email = email;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const ConsultaScreen()),
          (route) => false,
    );
  }

  Widget _bandeirinha(Color cor) => ClipPath(
    clipper: _TrianguloClipper(),
    child: Container(width: 14, height: 20, color: cor),
  );

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthStore>();
    final erro = _erroLocal ?? auth.erro;
    final cores = [AppColors.terracota, AppColors.mostarda, AppColors.turquesa, AppColors.rosa];

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  8,
                      (i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: _bandeirinha(cores[i % cores.length]),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('CRIE SUA CONTA', style: GoogleFonts.bevan(fontSize: 24, color: AppColors.terracota)),
              const SizedBox(height: 4),
              const Text('Junte-se ao garimpo nordestino', style: TextStyle(fontSize: 13, color: AppColors.muted)),
              const SizedBox(height: 24),
              TextField(controller: _nomeController, decoration: _campo('Nome completo')),
              const SizedBox(height: 12),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _campo('E-mail'),
              ),
              const SizedBox(height: 12),
              TextField(controller: _senhaController, obscureText: true, decoration: _campo('Senha (mín. 8 caracteres)')),
              const SizedBox(height: 12),
              TextField(controller: _confirmarController, obscureText: true, decoration: _campo('Confirmar senha')),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _aceitouTermos,
                    activeColor: AppColors.terracota,
                    onChanged: (v) => setState(() => _aceitouTermos = v ?? false),
                  ),
                  const Expanded(
                    child: Text('Li e aceito os termos de uso', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                  ),
                ],
              ),
              if (erro != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.descBg, borderRadius: BorderRadius.circular(12)),
                  child: Text(erro, style: const TextStyle(color: AppColors.descTxt)),
                ),
              ],
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.terracota,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                ),
                onPressed: _aceitouTermos && !auth.carregando ? _criarConta : null,
                child: auth.carregando
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('CRIAR CONTA', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
              ),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 13, color: AppColors.muted),
                      children: [
                        TextSpan(text: 'Já tem conta? '),
                        TextSpan(text: 'Entrar', style: TextStyle(color: AppColors.bordo, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
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