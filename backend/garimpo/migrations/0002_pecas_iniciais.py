from django.db import migrations

PECAS = [
    ("Vestido floral", "Vestido", "M", 45, 75, "Poucos usos", "à venda"),
    ("Blusa de renda", "Blusa", "P", 30, None, "Poucos usos", "vendida"),
    ("Calça jeans", "Calça", "G", 55, 90, "Seminova", "à venda"),
    ("Saia jeans", "Saia", "M", 38, None, "Poucos usos", "à venda"),
    ("Vestido de chita", "Vestido", "G", 60, 110, "Nova com etiqueta", "à venda"),
    ("Camisa de linho", "Blusa", "M", 42, 70, "Seminova", "à venda"),
    ("Saia midi estampada", "Saia", "P", 35, None, "Poucos usos", "à venda"),
    ("Macacão bordado", "Macacão", "M", 80, 140, "Seminova", "à venda"),
]


# cria as peças
def criar(apps, schema_editor):
    Peca = apps.get_model("garimpo", "Peca")
    for nome, categoria, tamanho, preco, original, condicao, status in PECAS:
        Peca.objects.create(
            nome=nome, categoria=categoria, tamanho=tamanho, preco=preco,
            preco_original=original, condicao=condicao, status=status,
        )


# desfaz
def apagar(apps, schema_editor):
    apps.get_model("garimpo", "Peca").objects.all().delete()


class Migration(migrations.Migration):
    dependencies = [("garimpo", "0001_initial")]
    operations = [migrations.RunPython(criar, apagar)]