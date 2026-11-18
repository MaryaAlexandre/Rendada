import time

from django.conf import settings
from django.http import HttpResponse
from rest_framework import generics
from rest_framework.permissions import AllowAny
from rest_framework.views import APIView
from rest_framework_simplejwt.views import TokenObtainPairView

from .models import Peca
from .serializers import CadastroSerializer, LoginSerializer, PecaSerializer


class CadastroView(generics.CreateAPIView):
    # público
    permission_classes = [AllowAny]
    authentication_classes = []
    serializer_class = CadastroSerializer


class LoginView(TokenObtainPairView):
    serializer_class = LoginSerializer


class PecaListView(generics.ListAPIView):
    # protegido (IsAuthenticated é o padrão)
    queryset = Peca.objects.all()
    serializer_class = PecaSerializer

    def list(self, request, *args, **kwargs):
        # teste de timeout: /api/pecas/?atraso=6
        atraso = request.query_params.get("atraso")
        if settings.DEBUG and atraso and atraso.isdigit():
            time.sleep(min(int(atraso), 10))
        return super().list(request, *args, **kwargs)


class TextoPuroView(APIView):
    # teste de JSON inválido
    def get(self, request):
        return HttpResponse("isto não é JSON", content_type="text/plain; charset=utf-8")