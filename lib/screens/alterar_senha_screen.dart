import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class AlterarSenhaScreen extends StatelessWidget {
  const AlterarSenhaScreen({super.key});

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
        title: Text('ALTERAR SENHA', style: GoogleFonts.bevan(fontSize: 16, color: AppColors.terracota)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(color: AppColors.bege, shape: BoxShape.circle),
                child: const Icon(Icons.lock_outline, color: AppColors.bordo, size: 36),
              ),
            ),
            const SizedBox(height: 24),
            TextField(obscureText: true, decoration: _campo('Senha atual')),
            const SizedBox(height: 12),
            TextField(obscureText: true, decoration: _campo('Nova senha')),
            const SizedBox(height: 12),
            TextField(obscureText: true, decoration: _campo('Confirmar nova senha')),
            const SizedBox(height: 8),
            const Text('Use pelo menos 8 caracteres.', style: TextStyle(fontSize: 12, color: AppColors.muted2)),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.terracota,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('SALVAR NOVA SENHA', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
            ),
          ],
        ),
      ),
    );
  }
}

