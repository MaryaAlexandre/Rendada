class PecaApi {
  final int id;
  final String nome;
  final String categoria;
  final String tamanho;
  final double preco;
  final double? precoOriginal;
  final String condicao;
  final String status;

  const PecaApi({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.tamanho,
    required this.preco,
    this.precoOriginal,
    required this.condicao,
    required this.status,
  });

  // json -> objeto
  factory PecaApi.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final nome = json['nome'];
    final categoria = json['categoria'];
    final tamanho = json['tamanho'];
    final preco = json['preco'];
    final original = json['preco_original'];

    if (id is! int || nome is! String || categoria is! String || tamanho is! String || preco is! num) {
      throw const FormatException('Peça com campos ausentes ou de tipo errado');
    }

    return PecaApi(
      id: id,
      nome: nome,
      categoria: categoria,
      tamanho: tamanho,
      preco: preco.toDouble(),
      precoOriginal: original is num ? original.toDouble() : null,
      condicao: json['condicao'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }
}