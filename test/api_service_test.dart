import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:rendada/services/api_exceptions.dart';
import 'package:rendada/services/api_service.dart';
import 'package:rendada/services/token_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TokenStorage storage;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    storage = TokenStorage();
  });

  ApiService api(MockClientHandler handler) => ApiService(client: MockClient(handler), storage: storage);

  http.Response jsonUtf8(Object corpo, int status) =>
      http.Response.bytes(utf8.encode(jsonEncode(corpo)), status, headers: {'content-type': 'application/json'});

  test('cadastro ok (201)', () async {
    final servico = api((req) async => jsonUtf8({'id': 1, 'nome': 'Cordélia', 'email': 'c@r.com'}, 201));
    await servico.cadastrar('Cordélia', 'c@r.com', 'Garimpo@2026');
  });

  test('cadastro inválido mostra as mensagens do Django', () async {
    final servico = api((req) async => jsonUtf8({'email': ['Já existe uma conta com este e-mail.']}, 400));
    expect(
      servico.cadastrar('C', 'c@r.com', 'Garimpo@2026'),
      throwsA(isA<CadastroInvalidoException>()
          .having((e) => e.mensagem, 'mensagem', 'Já existe uma conta com este e-mail.')),
    );
  });

  test('login ok extrai o access do JSON', () async {
    final servico = api((req) async => jsonUtf8({'access': 'abc.def.ghi', 'refresh': 'x', 'nome': 'Cordélia'}, 200));
    final r = await servico.login('c@r.com', 'Garimpo@2026');
    expect(r.token, 'abc.def.ghi');
    expect(r.nome, 'Cordélia');
  });

  test('credenciais inválidas (401)', () async {
    final servico = api((req) async => jsonUtf8({'detail': 'No active account'}, 401));
    expect(servico.login('x', 'y'), throwsA(isA<CredenciaisInvalidasException>()));
  });

  test('GET envia Authorization: Bearer <token> lido do storage', () async {
    await storage.salvar('meu_token');
    String? cabecalho;
    final servico = api((req) async {
      cabecalho = req.headers['Authorization'];
      return jsonUtf8([
        {'id': 1, 'nome': 'Vestido floral', 'categoria': 'Vestido', 'tamanho': 'M', 'preco': 45.0,
          'preco_original': 75.0, 'condicao': 'Poucos usos', 'status': 'à venda'}
      ], 200);
    });
    final lista = await servico.buscarPecas();
    expect(cabecalho, 'Bearer meu_token');
    expect(lista.single.nome, 'Vestido floral');
    expect(lista.single.status, 'à venda');
  });

  test('token expirado (401)', () async {
    await storage.salvar('vencido');
    final servico = api((req) async => jsonUtf8({'code': 'token_not_valid'}, 401));
    expect(servico.buscarPecas(), throwsA(isA<TokenExpiradoException>()));
  });

  test('JSON inválido', () async {
    await storage.salvar('ok');
    final servico = api((req) async => http.Response('isto não é JSON', 200));
    expect(servico.buscarPecas(), throwsA(isA<JsonInvalidoException>()));
  });

  test('servidor indisponível', () async {
    await storage.salvar('ok');
    final servico = api((req) async => throw http.ClientException('Connection refused'));
    expect(servico.buscarPecas(), throwsA(isA<ServidorIndisponivelException>()));
  });

  test('sem token salvo conta como sessão inválida', () async {
    final servico = api((req) async => jsonUtf8([], 200));
    expect(servico.buscarPecas(), throwsA(isA<TokenExpiradoException>()));
  });
}