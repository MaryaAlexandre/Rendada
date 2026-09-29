class Peca {
  final String nome;
  final String categoria;
  final String tamanho;
  final double preco;
  final double? precoOriginal;
  final String condicao;
  final String status;

  Peca({
    required this.nome,
    required this.categoria,
    required this.tamanho,
    required this.preco,
    this.precoOriginal,
    this.condicao = 'Poucos usos',
    this.status = 'à venda',
  });

  int? get percentualDesconto {
    if (precoOriginal == null || precoOriginal == 0) return null;
    return (((precoOriginal! - preco) / precoOriginal!) * 100).round();
  }
}
