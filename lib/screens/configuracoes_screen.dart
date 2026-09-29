import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import 'editar_perfil_screen.dart';
import 'alterar_senha_screen.dart';
import 'sobre_screen.dart';

class ConfiguracoesScreen extends StatefulWidget {
  const ConfiguracoesScreen({super.key});
  @override
  State<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  bool _notificacoes = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.texto),
        title: Text('CONFIGURAÇÕES', style: GoogleFonts.bevan(fontSize: 16, color: AppColors.terracota)),
      ),
      body: ListView(
        children: [
          _secao('CONTA'),
          _linha(
            icon: Icons.person_outline,
            label: 'Editar perfil',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditarPerfilScreen())),
          ),
          _linha(
            icon: Icons.lock_outline,
            label: 'Alterar senha',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AlterarSenhaScreen())),
          ),
          _secao('PREFERÊNCIAS'),
          _linha(
            icon: Icons.notifications_none,
            label: 'Notificações',
            trailing: Switch(
              value: _notificacoes,
              activeColor: AppColors.terracota,
              onChanged: (v) => setState(() => _notificacoes = v),
            ),
          ),
          _secao('SOBRE'),
          _linha(
            icon: Icons.info_outline,
            label: 'Sobre o Rendada',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SobreScreen())),
          ),
          _linha(icon: Icons.description_outlined, label: 'Termos de uso', onTap: () {}),
        ],
      ),
    );
  }

  Widget _secao(String titulo) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        child: Text(titulo, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.muted2)),
      );

  Widget _linha({required IconData icon, required String label, VoidCallback? onTap, Widget? trailing}) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(backgroundColor: AppColors.bege, foregroundColor: AppColors.bordo, child: Icon(icon, size: 20)),
          title: Text(label),
          trailing: trailing ?? const Icon(Icons.chevron_right, color: AppColors.muted2),
          onTap: onTap,
        ),
        const Divider(height: 1, color: AppColors.linha, indent: 16, endIndent: 16),
      ],
    );
  }
}

