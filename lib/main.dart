import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/sessao_gate.dart';
import 'stores/auth_store.dart';
import 'stores/favoritos_store.dart';

void main() {
  runApp(
    // providers globais
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritosStore()),
        ChangeNotifierProvider(create: (_) => AuthStore()),
      ],
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
      home: const SessaoGate(),
    );
  }
}