import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../models/usuario_atual.dart';
import 'home_screen.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});
  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  bool _aceitouTermos = false;
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();

  InputDecoration _campo(String label) => InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.searchBg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      );

  void _irParaHome() {
    // guarda o que foi digitado antes de navegar
    if (_nomeController.text.trim().isNotEmpty) {
      UsuarioAtual.nome = _nomeController.text.trim();
    }
    UsuarioAtual.email = _emailController.text.trim();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  Widget _bandeirinha(Color cor) => ClipPath(
        clipper: _TrianguloClipper(),
        child: Container(width: 14, height: 20, color: cor),
      );

  @override
  Widget build(BuildContext context) {
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
              TextField(controller: _emailController, decoration: _campo('E-mail')),
              const SizedBox(height: 12),
              TextField(obscureText: true, decoration: _campo('Senha')),
              const SizedBox(height: 12),
              TextField(obscureText: true, decoration: _campo('Confirmar senha')),
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
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.terracota,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                ),
                onPressed: _aceitouTermos ? _irParaHome : null,
                child: const Text('CRIAR CONTA', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
              ),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: _irParaHome,
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

