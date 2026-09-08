import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';

void main() => runApp(const RendadaApp());

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