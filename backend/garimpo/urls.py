from django.urls import path
from rest_framework_simplejwt.views import TokenRefreshView

from . import views

urlpatterns = [
    path("cadastro/", views.CadastroView.as_view()),
    path("token/", views.LoginView.as_view()),
    path("token/refresh/", TokenRefreshView.as_view()),
    path("pecas/", views.PecaListView.as_view()),
    path("teste/texto-puro/", views.TextoPuroView.as_view()),
]