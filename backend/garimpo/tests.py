from rest_framework.test import APITestCase


class FluxoJwtTest(APITestCase):
    def cadastrar(self, email="cordelia@rendada.com", senha="Garimpo@2026"):
        return self.client.post(
            "/api/cadastro/", {"nome": "Cordélia", "email": email, "senha": senha}, format="json"
        )

    def test_cadastro_e_login(self):
        self.assertEqual(self.cadastrar().status_code, 201)
        resposta = self.client.post(
            "/api/token/", {"username": "cordelia@rendada.com", "password": "Garimpo@2026"}, format="json"
        )
        self.assertEqual(resposta.status_code, 200)
        self.assertIn("access", resposta.data)
        self.assertEqual(resposta.data["nome"], "Cordélia")

    def test_email_repetido(self):
        self.cadastrar()
        resposta = self.cadastrar()
        self.assertEqual(resposta.status_code, 400)
        self.assertIn("email", resposta.data)

    def test_senha_fraca(self):
        self.assertEqual(self.cadastrar(senha="123").status_code, 400)

    def test_login_invalido(self):
        resposta = self.client.post("/api/token/", {"username": "x@x.com", "password": "errada"}, format="json")
        self.assertEqual(resposta.status_code, 401)

    def test_pecas_sem_token(self):
        self.assertEqual(self.client.get("/api/pecas/").status_code, 401)

    def test_pecas_token_invalido(self):
        self.client.credentials(HTTP_AUTHORIZATION="Bearer token_corrompido")
        self.assertEqual(self.client.get("/api/pecas/").status_code, 401)

    def test_pecas_com_token(self):
        self.cadastrar()
        token = self.client.post(
            "/api/token/", {"username": "cordelia@rendada.com", "password": "Garimpo@2026"}, format="json"
        ).data["access"]
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {token}")
        resposta = self.client.get("/api/pecas/")
        self.assertEqual(resposta.status_code, 200)
        self.assertEqual(len(resposta.data), 8)
        self.assertEqual(resposta.data[0]["nome"], "Vestido floral")