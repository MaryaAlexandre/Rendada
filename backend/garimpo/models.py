from django.db import models


class Peca(models.Model):
    nome = models.CharField(max_length=100)
    categoria = models.CharField(max_length=50)
    tamanho = models.CharField(max_length=5)
    preco = models.DecimalField(max_digits=8, decimal_places=2)
    preco_original = models.DecimalField(max_digits=8, decimal_places=2, null=True, blank=True)
    condicao = models.CharField(max_length=30, default="Poucos usos")
    status = models.CharField(max_length=20, default="à venda")

    class Meta:
        ordering = ["id"]

    def __str__(self):
        return self.nome