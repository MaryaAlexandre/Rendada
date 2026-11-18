import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_exceptions.dart';

/// Guarda o JWT no armazenamento seguro (Keystore no Android, libsecret no Linux).
class TokenStorage {
  static const _chave = 'jwt_access_token';
  final FlutterSecureStorage _storage;

  TokenStorage({FlutterSecureStorage? storage}) : _storage = storage ?? const FlutterSecureStorage();

  // grava
  Future<void> salvar(String token) async {
    try {
      await _storage.write(key: _chave, value: token);
    } catch (_) {
      throw const ArmazenamentoException();
    }
  }

  // lê
  Future<String?> ler() async {
    try {
      return await _storage.read(key: _chave);
    } catch (_) {
      throw const ArmazenamentoException();
    }
  }

  // apaga
  Future<void> apagar() async {
    try {
      await _storage.delete(key: _chave);
    } catch (_) {
      throw const ArmazenamentoException();
    }
  }
}