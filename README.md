##Rendada

**Moda circular, afeto regional.**
*Desapegos com borogodó.*

App mobile de brechó desenvolvido em Flutter para a disciplina de Dispositivos Móveis (ADS — IFRN), com identidade visual inspirada na cultura nordestina.

---

## Sobre o projeto

**Rendada** é um aplicativo para catalogar peças de roupa usada, acompanhar o status de cada venda e calcular o desconto em relação ao preço original — unindo referências visuais de marketplaces de moda modernos (Enjoei, Depop) com uma estética nordestina pensada para o público jovem feminino.

### Escopo da atividade

- ✅ Consumo de API (**ViaCEP**) para busca de endereço do comprador na finalização da venda
- ✅ Persistência local de dados (catálogo de peças)
- ✅ Protótipo de telas no Figma
- ✅ Layout implementado em Flutter

## Identidade visual

| Elemento | Descrição |
|---|---|
| Paleta | Terracota, bordô, turquesa e mostarda — inspirada em bandeirinhas de São João e tecidos de chita |
| Tipografia | [Bevan](https://fonts.google.com/specimen/Bevan) (estilo xilogravura) para títulos |
| Linguagem | Expressões regionais como *"garimpar"*, *"flor"* e *"borogodó"* nos textos do app |

## 🖼️ Telas

<p align="center">
  <img src="docs/screens/rendada_01_boas_vindas.svg" width="200" alt="Tela de boas-vindas"/>
  <img src="docs/screens/rendada_02_feed.svg" width="200" alt="Tela de feed / meus achados"/>
  <img src="docs/screens/rendada_03_detalhes.svg" width="200" alt="Tela de detalhes da peça"/>
</p>

| Tela | Descrição |
|---|---|
| **Boas-vindas** | Onboarding com a identidade da marca e call-to-action |
| **Meus achados** | Feed com busca, categorias, banner de promoção e grid de peças |
| **Nova peça** | Cadastro de peça com fotos, categoria e tamanho |
| **Detalhes** | Preço com desconto, seletor de tamanho e ação de marcar como vendida |

##Tecnologias

- [Flutter](https://flutter.dev) & Dart
- [google_fonts](https://pub.dev/packages/google_fonts) — fonte Bevan
- API [ViaCEP](https://viacep.com.br) — consulta de endereço por CEP
- Persistência local — *sqflite (em desenvolvimento)*

##Estrutura do projeto

```
lib/
├── main.dart
├── models/
│   └── peca.dart
└── screens/
    ├── onboarding_screen.dart
    ├── home_screen.dart
    ├── nova_peca_screen.dart
    └── detalhe_peca_screen.dart
```

##Como rodar

```bash
git clone https://github.com/MaryaAlexandre/Rendada.git
cd Rendada
flutter pub get
flutter run
```

