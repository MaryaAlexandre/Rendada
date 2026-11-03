import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/onboarding_screen.dart';
import 'stores/favoritos_store.dart';

void main() {
  runApp(
    // provider global
    ChangeNotifierProvider(
      create: (_) => FavoritosStore(),
      child: const RendadaApp(),
    ),
  );
}

class RendadaApp extends StatelessWidget {
  const RendadaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rendada',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFFFF8F0)),
      home: const OnboardingScreen(),
    );
  }
}