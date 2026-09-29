import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class EditarPerfilScreen extends StatelessWidget {
  const EditarPerfilScreen({super.key});

  InputDecoration _campo(String label) => InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.searchBg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.texto),
        title: Text('EDITAR PERFIL', style: GoogleFonts.bevan(fontSize: 16, color: AppColors.terracota)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(color: AppColors.bege, shape: BoxShape.circle),
                    child: const Icon(Icons.person, color: AppColors.bordo, size: 48),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: AppColors.terracota, shape: BoxShape.circle),
                      child: const Icon(Icons.edit, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(decoration: _campo('Nome completo')),
            const SizedBox(height: 12),
            TextField(decoration: _campo('E-mail')),
            const SizedBox(height: 12),
            TextField(decoration: _campo('Telefone')),
            const SizedBox(height: 12),
            TextField(
              maxLines: 3,
              decoration: _campo('Sobre mim').copyWith(
                hintText: 'Vendo peças com carinho e muito borogodó desde 2026.',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.terracota,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('SALVAR ALTERAÇÕES', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
            ),
          ],
        ),
      ),
    );
  }
}

