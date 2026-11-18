/// Erros da comunicação com a API, já com a mensagem para a usuária.
class ApiException implements Exception {
  final String mensagem;
  const ApiException(this.mensagem);

  @override
  String toString() => mensagem;
}

class ServidorIndisponivelException extends ApiException {
  const ServidorIndisponivelException()
      : super('Servidor indisponível. Confira sua internet e tente de novo.');
}

class TempoEsgotadoException extends ApiException {
  const TempoEsgotadoException()
      : super('O servidor demorou demais para responder (timeout).');
}

class CredenciaisInvalidasException extends ApiException {
  const CredenciaisInvalidasException() : super('E-mail ou senha incorretos.');
}

class CadastroInvalidoException extends ApiException {
  const CadastroInvalidoException(super.mensagem);
}

class TokenExpiradoException extends ApiException {
  const TokenExpiradoException()
      : super('Sua sessão expirou ou é inválida. Entre de novo.');
}

class JsonInvalidoException extends ApiException {
  const JsonInvalidoException()
      : super('O servidor respondeu num formato inesperado (JSON inválido).');
}

class ArmazenamentoException extends ApiException {
  const ArmazenamentoException()
      : super('Não foi possível acessar o armazenamento seguro do aparelho.');
}

class RespostaInesperadaException extends ApiException {
  RespostaInesperadaException(int status) : super('Erro inesperado do servidor (HTTP $status).');
}