import 'package:flutter/foundation.dart';
import '../models/peca.dart';

/// Estado compartilhado dos favoritos (Provider + ChangeNotifier).
class FavoritosStore extends ChangeNotifier {
  final List<Peca> _favoritas = [];

  // leitura
  List<Peca> get favoritas => List.unmodifiable(_favoritas);
  int get total => _favoritas.length;
  bool isFavorita(Peca peca) => _favoritas.any((p) => p.nome == peca.nome);

  // alterna
  void alternar(Peca peca) {
    if (isFavorita(peca)) {
      _favoritas.removeWhere((p) => p.nome == peca.nome);
    } else {
      _favoritas.add(peca);
    }
    notifyListeners();
  }

  // remove
  void remover(Peca peca) {
    _favoritas.removeWhere((p) => p.nome == peca.nome);
    notifyListeners();
  }
}