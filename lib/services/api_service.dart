import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/peca_api.dart';
import 'api_exceptions.dart';
import 'token_storage.dart';

/// Cenários para demonstrar o tratamento de erros.
enum ModoTeste { normal, timeout, jsonInvalido }

/// Comunicação com a API Django (backend/ deste repositório).
class ApiService {
  // dev: http://127.0.0.1:8000/api (Linux) | http://10.0.2.2:8000/api (emulador)
  // produção: https://...
  static const _base = String.fromEnvironment('API_URL', defaultValue: 'http://127.0.0.1:8000/api');
  static const _tempoLimite = Duration(seconds: 4);
  static const _json = {'Content-Type': 'application/json'};

  final http.Client _client;
  final TokenStorage _storage;

  ApiService({http.Client? client, TokenStorage? storage})
      : _client = client ?? http.Client(),
        _storage = storage ?? TokenStorage();

  // cadastro
  Future<void> cadastrar(String nome, String email, String senha) async {
    final resposta = await _enviar(() => _client.post(
      Uri.parse('$_base/cadastro/'),
      headers: _json,
      body: jsonEncode({'nome': nome, 'email': email, 'senha': senha}),
    ));

    if (resposta.statusCode == 400) {
      throw CadastroInvalidoException(_mensagensDeErro(_texto(resposta)));
    }
    if (resposta.statusCode != 201) _checarStatus(resposta);
  }

  // login
  Future<({String token, String nome})> login(String email, String senha) async {
    final resposta = await _enviar(() => _client.post(
      Uri.parse('$_base/token/'),
      headers: _json,
      body: jsonEncode({'username': email.trim().toLowerCase(), 'password': senha}),
    ));

    if (resposta.statusCode == 400 || resposta.statusCode == 401) {
      throw const CredenciaisInvalidasException();
    }
    _checarStatus(resposta);

    final json = _decodificar(_texto(resposta));
    if (json is! Map<String, dynamic>) throw const JsonInvalidoException();

    final token = json['access'];
    if (token is! String || token.isEmpty) throw const JsonInvalidoException();

    final nome = json['nome'] is String ? json['nome'] as String : email;
    return (token: token, nome: nome);
  }

  // consulta protegida
  Future<List<PecaApi>> buscarPecas({ModoTeste modo = ModoTeste.normal}) async {
    final token = await _storage.ler();
    if (token == null || token.isEmpty) throw const TokenExpiradoException();

    final caminho = switch (modo) {
      ModoTeste.normal => '/pecas/',
      ModoTeste.timeout => '/pecas/?atraso=6',
      ModoTeste.jsonInvalido => '/teste/texto-puro/',
    };

    final resposta = await _enviar(() => _client.get(
      Uri.parse('$_base$caminho'),
      headers: {'Authorization': 'Bearer $token'},
    ));

    if (resposta.statusCode == 401) throw const TokenExpiradoException();
    _checarStatus(resposta);

    final lista = _decodificar(_texto(resposta));
    if (lista is! List) throw const JsonInvalidoException();

    try {
      return lista.map((item) => PecaApi.fromJson(item as Map<String, dynamic>)).toList();
    } on FormatException {
      throw const JsonInvalidoException();
    } on TypeError {
      throw const JsonInvalidoException();
    }
  }

  // timeout e rede
  Future<http.Response> _enviar(Future<http.Response> Function() requisicao) async {
    try {
      return await requisicao().timeout(_tempoLimite);
    } on TimeoutException {
      throw const TempoEsgotadoException();
    } on http.ClientException {
      throw const ServidorIndisponivelException();
    }
  }

  // status
  void _checarStatus(http.Response resposta) {
    if (resposta.statusCode >= 500) throw const ServidorIndisponivelException();
    if (resposta.statusCode != 200) throw RespostaInesperadaException(resposta.statusCode);
  }

  // corpo em UTF-8 (acentos)
  String _texto(http.Response resposta) => utf8.decode(resposta.bodyBytes, allowMalformed: true);

  // json
  dynamic _decodificar(String corpo) {
    try {
      return jsonDecode(corpo);
    } on FormatException {
      throw const JsonInvalidoException();
    }
  }

  // erros de validação do Django
  String _mensagensDeErro(String corpo) {
    try {
      final json = jsonDecode(corpo);
      if (json is Map) {
        return json.values.expand((v) => v is List ? v : [v]).join('\n');
      }
    } on FormatException {
      // segue
    }
    return 'Não foi possível criar a conta.';
  }
}