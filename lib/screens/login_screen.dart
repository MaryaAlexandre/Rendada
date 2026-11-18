import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../stores/auth_store.dart';
import '../theme/app_colors.dart';
import 'cadastro_screen.dart';
import 'consulta_screen.dart';

class LoginScreen extends StatefulWidget {
  final String? mensagem;
  const LoginScreen({super.key, this.mensagem});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _senhaVisivel = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthStore>().limparErro();
      // aviso de redirecionamento
      if (widget.mensagem != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.mensagem!), backgroundColor: AppColors.bordo),
        );
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    final auth = context.read<AuthStore>();
    final ok = await auth.entrar(_emailController.text.trim(), _senhaController.text);
    if (!mounted || !ok) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const ConsultaScreen()),
          (route) => false,
    );
  }

  InputDecoration _campo(String label, {Widget? sufixo}) => InputDecoration(
    labelText: label,
    filled: true,
    fillColor: AppColors.searchBg,
    suffixIcon: sufixo,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
  );

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthStore>();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const Icon(Icons.lock_outline, size: 48, color: AppColors.terracota),
              const SizedBox(height: 12),
              Text('ENTRAR', textAlign: TextAlign.center, style: GoogleFonts.bevan(fontSize: 26, color: AppColors.terracota)),
              const SizedBox(height: 4),
              const Text('Acesse o garimpo online', textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted)),
              const SizedBox(height: 28),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _campo('E-mail'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _senhaController,
                obscureText: !_senhaVisivel,
                onSubmitted: (_) => _entrar(),
                decoration: _campo(
                  'Senha',
                  sufixo: IconButton(
                    icon: Icon(_senhaVisivel ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _senhaVisivel = !_senhaVisivel),
                  ),
                ),
              ),
              if (auth.erro != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.descBg, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.descTxt),
                      const SizedBox(width: 8),
                      Expanded(child: Text(auth.erro!, style: const TextStyle(color: AppColors.descTxt))),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.terracota,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                ),
                onPressed: auth.carregando ? null : _entrar,
                child: auth.carregando
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('ENTRAR', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CadastroScreen())),
                child: const Text('Ainda não tem conta? Criar conta', style: TextStyle(color: AppColors.bordo)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}