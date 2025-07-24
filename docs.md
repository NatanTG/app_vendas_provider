# Documentação Técnica - Vendas App

> Informações detalhadas sobre arquitetura, requisitos, estrutura e práticas recomendadas do projeto.

## Sumário
- [Visão Geral](#visão-geral)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Dependências](#dependências)
- [Como Iniciar](#como-iniciar)
- [Funcionalidades](#funcionalidades)
- [Testes](#testes)
- [Observações](#observações)
- [Provider x GetIt: O que deve ser reativo?](#provider-x-getit-o-que-deve-ser-reativo)

## Visão Geral
O app permite que usuários façam login, visualizem produtos de uma API, adicionem itens ao carrinho, finalizem pedidos (salvos no Firestore) e consultem o histórico de compras. A arquitetura é baseada em features e controllers testáveis.

## Estrutura do Projeto
- `lib/core/app_theme.dart`: Tema global do app
- `lib/features/auth`: Autenticação (model, service, controller, página, widget)
- `lib/features/products`: Produtos (model, service, controller, página, widget)
- `lib/features/cart`: Carrinho (model, controller, página)
- `lib/features/orders`: Pedidos (model, service, controller, página)
- `lib/main.dart`: Inicialização, rotas e registro de dependências

## Dependências
- Flutter >= 3.8.1
- Firebase Core, Auth, Firestore
- http
- get_it (injeção de dependências)
- provider

## Requisitos Funcionais (RF)
- RF01: Usuário pode se autenticar (login/cadastro) via email/senha (Firebase Auth)
- RF02: Listar produtos de uma API REST (https://fakestoreapi.com/products)
- RF03: Adicionar produtos ao carrinho
- RF04: Visualizar e remover itens do carrinho
- RF05: Finalizar compra, salvando pedido no Firestore
- RF06: Visualizar histórico de pedidos

## Requisitos Não Funcionais (RNF)
- RNF01: Arquitetura limpa (separação por features, SOLID)
- RNF02: Gerenciamento de estado com Provider
- RNF03: Feedback visual para ações (loading, erro, sucesso)
- RNF04: Navegação simples e intuitiva
- RNF05: Código testável e extensível

## Como rodar o projeto
1. **Pré-requisitos:**
   - Flutter SDK instalado
   - Android Studio ou emulador Android/iOS
   - Firebase configurado (google-services.json para Android, GoogleService-Info.plist para iOS)

2. **Instale dependências:**
   ```bash
   flutter pub get
   ```

3. **Execute o app:**
   ```bash
   flutter run
   ```
   - Escolha o dispositivo/emulador desejado.

## Como testar as features
- Login/cadastro: tela inicial, insira email/senha
- Produtos: após login, navegue pela lista de produtos
- Carrinho: adicione produtos, acesse o ícone do carrinho
- Pedidos: finalize compra, acesse histórico

## Testes
- Para rodar testes unitários:
   ```bash
   flutter test
   ```

## Arquitetura
- Clean Architecture: separação por features, controllers, services, models
- Injeção de dependências com GetIt (`lib/di.dart`)
- Controllers como singletons, services como factories/singletons
- Navegação via rotas nomeadas

## Observações
- Certifique-se de que o Firebase está corretamente configurado para seu app
- Para dúvidas, consulte este docs ou abra uma issue

---

## Provider x GetIt: O que deve ser reativo?

**Provider (reativo):**
Use Provider para expor objetos que mudam e precisam atualizar a UI automaticamente:
- Controllers que estendem ChangeNotifier (ProductsController, CartController, OrdersController, AuthController)
- Qualquer model que muda e afeta a interface

**GetIt (singleton/injeção):**
Use GetIt para objetos que não mudam ou não precisam atualizar a UI:
- Services (ProductsService, OrdersService, AuthService)
- Helpers, utilitários, repositórios, clients de API
- Configurações globais, temas, loggers

**Resumo prático:**
- Provider: Controllers e modelos que mudam e afetam a interface
- GetIt: Services, helpers, singletons que não precisam reatividade
