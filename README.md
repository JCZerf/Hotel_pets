# Pet Hotel - Frontend Flutter

Esse é o app mobile em Flutter que desenvolvi para o desafio técnico do Pet Hotel. Ele se comunica com a API backend para gerenciar pets hospedados, permitindo cadastro, edição, exclusão e visualização detalhada dos pets e seus tutores.

---

## Funcionalidades principais

- Listagem dos pets hospedados com nome do tutor e datas de entrada e saída.
- Modal de detalhes completo ao clicar no pet.
- Cadastro e edição de pets via formulário.
- Exclusão de pets com confirmação.
- Interface simples, responsiva e intuitiva.
- Integração com backend via API REST.

---

## Tecnologias usadas

- Flutter (Dart)
- Material Design para UI
- Comunicação HTTP com API backend

---

## Como rodar o projeto

1. Clone o repositório:

```bash
git clone https://github.com/seu-usuario/pet-hotel-flutter.git
cd pet-hotel-flutter
```

2. Instale as dependências:

```bash
flutter pub get
```

3. Configure o endpoint da API (se necessário) no arquivo `api_service.dart`.

4. Rode o app em um emulador ou dispositivo real:

```bash
flutter run
```

---

## Estrutura do projeto

- `lib/models` - Modelos de dados (PetModel)
- `lib/services` - Comunicação com API (ApiService)
- `lib/screens` - Telas do app (lista, formulário)
- `lib/widgets` - Componentes reutilizáveis (se houver)
- `main.dart` - Entrada principal do app


