import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../stores/auth_store.dart';
import 'consulta_screen.dart';
import 'onboarding_screen.dart';

class SessaoGate extends StatefulWidget {
  const SessaoGate({super.key});

  @override
  State<SessaoGate> createState() => _SessaoGateState();
}

class _SessaoGateState extends State<SessaoGate> {
  late final Future<bool> _temSessao;

  @override
  void initState() {
    super.initState();
    _temSessao = context.read<AuthStore>().temSessao();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _temSessao,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return snapshot.data == true ? const ConsultaScreen() : const OnboardingScreen();
      },
    );
  }
}