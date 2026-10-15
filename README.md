# Integrantes

- Enzo Damasceno Falcão
- Cristian Brandão Tavares

# Jogo da Forca

Jogo da Forca desenvolvido em Flutter/Dart para a disciplina de Programação
para Dispositivos Móveis (UESPI). Funciona totalmente offline: as respostas,
categorias, níveis e dicas são lidos em tempo de execução de um arquivo JSON
incluído nos assets.

## Funcionalidades

- Escolha de categoria por um menu (Animais, Corpo humano, Esportes, Tecnologia) e de
  dificuldade (Fácil, Médio, Difícil), com resumo das opções antes de iniciar.
- Sorteio aleatório sem repetição de respostas durante a sessão; quando uma
  combinação se esgota, o usuário é avisado e pode escolher outra combinação
  ou liberar as respostas novamente.
- Respostas com uma ou mais palavras; espaços e hífens exibidos
  automaticamente desde o início.
- Teclado apenas com letras (A–Z); a comparação ignora acentos e cedilha
  (`A` revela `Ã`, `C` revela `Ç`), preservando a grafia original na tela.
- Forca desenhada progressivamente: cabeça, tronco, braços e pernas
  (limite de 6 erros).
- Dica por rodada, contabilizada uma única vez.
- Tela de resultado com vitória/derrota, resposta, erros e uso de dica.
- Estatísticas da sessão: rodadas, vitórias, derrotas (com percentuais),
  erros e dicas.
- Tela "Sobre" com os nomes da equipe.

## Tecnologias

- Flutter 3.27 ou superior / Dart 3.6 ou superior
- Material 3
- Nenhum pacote externo além de `flutter_lints` (análise estática)

## Como executar

```bash
git clone https://github.com/<usuario>/hangman-game.git
cd hangman-game
flutter pub get
flutter run -d chrome
```

Verificações de qualidade:

```bash
flutter analyze
dart format .
flutter test
```

## Estrutura

```
assets/data/hangman_entries.json   dados fornecidos com a atividade
lib/
  domain/        regras do jogo e modelos (sem dependência de Flutter)
    models/      Answer, HangmanEntry, HangmanRound, SessionStatistics, enums
    repositories/ contrato EntryRepository
  data/          leitura do asset e desserialização do JSON
  application/   EntryPool (sorteio sem repetição) e GameController (estado)
  presentation/  telas, widgets, textos em português e tema
test/            testes de unidade e de widget
docs/            documentação das decisões de projeto
```

Detalhes das decisões de modelagem estão em [docs/architecture.md](docs/architecture.md).
