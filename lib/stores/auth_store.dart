import 'package:flutter/foundation.dart';
import '../services/api_exceptions.dart';
import '../services/api_service.dart';
import '../services/token_storage.dart';

class AuthStore extends ChangeNotifier {
  final ApiService _api;
  final TokenStorage _storage;

  AuthStore({ApiService? api, TokenStorage? storage})
      : _storage = storage ?? TokenStorage(),
        _api = api ?? ApiService(storage: storage);

  bool _carregando = false;
  String? _erro;
  String _nome = '';

  bool get carregando => _carregando;
  String? get erro => _erro;
  String get nome => _nome;
  ApiService get api => _api;

  Future<bool> temSessao() async {
    try {
      final token = await _storage.ler();
      return token != null && token.isNotEmpty;
    } on ArmazenamentoException {
      return false;
    }
  }

  Future<bool> entrar(String usuario, String senha) async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      final resultado = await _api.login(usuario, senha);
      await _storage.salvar(resultado.token);
      _nome = resultado.nome;
      return true;
    } on ApiException catch (e) {
      _erro = e.mensagem;
      return false;
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<bool> cadastrar(String nome, String email, String senha) async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      await _api.cadastrar(nome, email, senha);
    } on ApiException catch (e) {
      _erro = e.mensagem;
      _carregando = false;
      notifyListeners();
      return false;
    }

    return entrar(email, senha);
  }

  void limparErro() {
    _erro = null;
    notifyListeners();
  }

  Future<void> sair() async {
    try {
      await _storage.apagar();
    } on ArmazenamentoException {
    }
    _nome = '';
    notifyListeners();
  }

  Future<String?> tokenAtual() async {
    try {
      return await _storage.ler();
    } on ArmazenamentoException {
      return null;
    }
  }

  Future<void> corromperToken() => _storage.salvar('token_corrompido');
}