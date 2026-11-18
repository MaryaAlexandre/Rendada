from django.contrib.auth.models import User
from django.contrib.auth.password_validation import validate_password
from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

from .models import Peca


class PecaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Peca
        fields = ["id", "nome", "categoria", "tamanho", "preco", "preco_original", "condicao", "status"]


class CadastroSerializer(serializers.Serializer):
    nome = serializers.CharField(max_length=150)
    email = serializers.EmailField()
    senha = serializers.CharField(write_only=True)

    # e-mail único
    def validate_email(self, valor):
        valor = valor.lower()
        if User.objects.filter(username=valor).exists():
            raise serializers.ValidationError("Já existe uma conta com este e-mail.")
        return valor

    # regras de senha do Django
    def validate_senha(self, valor):
        validate_password(valor)
        return valor

    def create(self, dados):
        return User.objects.create_user(
            username=dados["email"],
            email=dados["email"],
            password=dados["senha"],
            first_name=dados["nome"],
        )

    def to_representation(self, usuario):
        return {"id": usuario.id, "nome": usuario.first_name, "email": usuario.email}


class LoginSerializer(TokenObtainPairSerializer):
    # devolve o nome junto com o token
    def validate(self, attrs):
        dados = super().validate(attrs)
        dados["nome"] = self.user.first_name or self.user.username
        return dados