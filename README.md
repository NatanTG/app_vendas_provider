

<div align="center">
  <h1>Vendas App</h1>
  <p>Aplicativo Flutter para vendas, com autenticação, listagem de produtos, carrinho e pedidos.</p>
</div>

---

## Sobre o Projeto
O Vendas App é um exemplo de arquitetura limpa em Flutter, com autenticação via Firebase, produtos de uma API REST, carrinho de compras e histórico de pedidos. O projeto utiliza Provider para gerenciamento de estado e GetIt para injeção de dependências.

- Login/cadastro de usuário
- Listagem de produtos
- Carrinho de compras
- Finalização de pedidos (Firestore)
- Histórico de pedidos

## Instalação Rápida
```bash
flutter pub get
flutter run
```

> ⚠️ Para rodar, configure o Firebase (google-services.json para Android, GoogleService-Info.plist para iOS).

## Pré-requisitos
- Flutter SDK
- Emulador ou dispositivo Android/iOS
- Firebase configurado

## Testes
```bash
flutter test
```

## Documentação
Para detalhes de arquitetura, requisitos, estrutura e práticas recomendadas, consulte o arquivo [docs.md](docs.md).

## Licença
MIT