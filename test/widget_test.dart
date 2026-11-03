import 'package:flutter_test/flutter_test.dart';
import 'package:rendada/models/peca.dart';
import 'package:rendada/stores/favoritos_store.dart';

void main() {
  test('FavoritosStore alterna e notifica', () {
    final store = FavoritosStore();
    final peca = Peca(nome: 'Vestido floral', categoria: 'Vestido', tamanho: 'M', preco: 45);
    var notificacoes = 0;
    store.addListener(() => notificacoes++);

    store.alternar(peca);
    expect(store.isFavorita(peca), isTrue);
    expect(store.total, 1);

    store.alternar(peca);
    expect(store.isFavorita(peca), isFalse);
    expect(store.total, 0);
    expect(notificacoes, 2);
  });
}