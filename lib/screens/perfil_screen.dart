import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../models/usuario_atual.dart';
import 'favoritos_screen.dart';
import 'historico_vendas_screen.dart';
import 'configuracoes_screen.dart';
import 'onboarding_screen.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              decoration: const BoxDecoration(
                color: AppColors.terracota,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.flutter_dash, size: 18, color: Colors.white),
                          const SizedBox(width: 4),
                          Text('Rendada', style: GoogleFonts.bevan(fontSize: 18, color: Colors.white)),
                          const SizedBox(width: 2),
                          const Icon(Icons.auto_awesome, size: 12, color: AppColors.mostarda),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('MEU PERFIL', style: TextStyle(color: Color(0xFFF3D9C9), fontSize: 12, letterSpacing: 1)),
                  ),
                  const SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.person, size: 48, color: AppColors.terracota),
                      ),
                      Positioned(top: 0, right: 100, child: _dot(AppColors.mostarda, 10)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(UsuarioAtual.nome, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                  const Text('Vendedora no Rendada desde 2026', style: TextStyle(color: Color(0xFFF3D9C9), fontSize: 12)),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -24),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.linha),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _estatistica('12', 'à venda'),
                    _divisor(),
                    _estatistica('8', 'vendidas'),
                    _divisor(),
                    _estatistica('4.9', 'avaliação', icone: Icons.star, corIcone: AppColors.mostarda),
                  ],
                ),
              ),
            ),
            _menu(context, icon: Icons.sell_outlined, label: 'Meus achados', onTap: () => Navigator.pop(context)),
            _menu(context, icon: Icons.favorite_border, label: 'Favoritos',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritosScreen()))),
            _menu(context, icon: Icons.inventory_2_outlined, label: 'Histórico de vendas',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoricoVendasScreen()))),
            _menu(context, icon: Icons.settings_outlined, label: 'Configurações',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConfiguracoesScreen()))),
            _menu(context, icon: Icons.logout, label: 'Sair', corTexto: AppColors.descTxt,
                onTap: () => Navigator.pushAndRemoveUntil(
                    context, MaterialPageRoute(builder: (_) => const OnboardingScreen()), (route) => false)),
          ],
        ),
      ),
    );
  }

  Widget _dot(Color cor, double tamanho) =>
      Container(width: tamanho, height: tamanho, decoration: BoxDecoration(color: cor, shape: BoxShape.circle));

  Widget _divisor() => Container(width: 1, height: 30, color: AppColors.linha);

  Widget _estatistica(String valor, String label, {IconData? icone, Color? corIcone}) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icone != null) ...[Icon(icone, size: 14, color: corIcone), const SizedBox(width: 2)],
            Text(valor, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.texto)),
          ],
        ),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
      ],
    );
  }

  Widget _menu(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onTap, Color? corTexto}) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: corTexto != null ? const Color(0xFFFBE4E8) : AppColors.bege,
            foregroundColor: corTexto ?? AppColors.bordo,
            child: Icon(icon, size: 20),
          ),
          title: Text(label, style: TextStyle(color: corTexto ?? AppColors.texto)),
          trailing: const Icon(Icons.chevron_right, color: AppColors.muted2),
          onTap: onTap,
        ),
        const Divider(height: 1, color: AppColors.linha, indent: 16, endIndent: 16),
      ],
    );
  }
}

