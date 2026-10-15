# Arquitetura e decisões de projeto

## Camadas e dependências

```
presentation  →  application  →  domain  ←  data
```

- **domain** (`lib/domain`): regras do jogo em Dart puro. Não conhece
  Flutter, JSON nem a interface. Define o contrato `EntryRepository`.
- **data** (`lib/data`): implementa `EntryRepository` lendo o asset com
  `rootBundle` (`AssetEntryRepository`) e convertendo o JSON em objetos de
  domínio (`EntryJsonParser`). Erros viram `EntryDataException`.
- **application** (`lib/application`): `EntryPool` sorteia respostas sem
  repetição; `GameController` (`ChangeNotifier`) guarda a seleção, a rodada
  atual e as estatísticas e notifica a interface.
- **presentation** (`lib/presentation`): telas e widgets. Os textos em
  português dos enums ficam em `labels.dart`, fora do domínio.

A dependência aponta para o domínio: a camada de dados implementa uma
interface definida no domínio (inversão de dependência), e o `main.dart` é o
único lugar que escolhe a implementação concreta.

## Carregamento do JSON

1. `AssetEntryRepository.loadEntries()` lê
   `assets/data/hangman_entries.json` (declarado no `pubspec.yaml`).
2. `EntryJsonParser.parse()` valida a estrutura (`entries` como lista, cada
   entrada como objeto, `answer` como texto, `hints` como lista não vazia).
3. `category` e `difficulty` são convertidos para `AnswerCategory` e
   `Difficulty` pelo método genérico `_parseEnum`, que compara o texto do
   JSON com `Enum.name`. Valores desconhecidos geram `EntryDataException`.
4. Em caso de erro, a tela de carregamento mostra a mensagem e permite
   tentar novamente.

## Modelagem da resposta

- `Answer` divide o texto por espaços em `words` (lista de palavras). O
  espaço não é guardado como caractere: a separação é a própria lista, e a
  interface desenha cada palavra como um bloco.
- Cada caractere é um `AnswerCharacter` com `original` (grafia exibida),
  `normalized` (usado na comparação) e `isLetter`.
- Hífens e outros caracteres têm `isLetter == false`: são sempre visíveis
  (`HangmanRound.isRevealed`), não aparecem no teclado e não entram em
  `Answer.letters`, o conjunto usado na condição de vitória.

## Normalização de acentos

`letter_normalizer.dart` converte o caractere para maiúscula e o mapeia para
a letra base (`Ã` → `A`, `É` → `E`, `Ç` → `C`). Ela é usada apenas para
comparar; `AnswerCharacter.original` nunca é alterado, então a tela continua
mostrando `CORAÇÃO`. O `Ç` foi mapeado para `C` porque o teclado contém
apenas as 26 letras de A a Z.

## Regras da rodada (`HangmanRound`)

- `guess` aplica a letra à resposta inteira (todas as palavras de uma vez).
- Letra já usada → `GuessOutcome.repeated`, sem novo erro.
- Caractere que não é letra → `GuessOutcome.invalid`.
- Rodada encerrada → `GuessOutcome.roundFinished`; nada muda.
- `status` é derivado: derrota se `errors >= maxErrors`, vitória se todas as
  letras de `Answer.letters` foram descobertas. Os dois estados são
  exclusivos porque nenhuma tentativa é aceita após o fim.
- `maxErrors = 6`, uma parte do boneco por erro.
- `useHint` retorna `true` só na primeira vez; consultas seguintes não
  contam de novo.

## Sorteio sem repetição (`EntryPool`)

Guarda as entradas usadas na sessão. `pick` sorteia apenas entre as não
usadas da combinação; quando não há nenhuma, retorna `null` e a interface
avisa o usuário, que escolhe outra combinação ou libera as respostas
(`resetUsage`). Não há repetição silenciosa.

## Estatísticas (`SessionStatistics`)

Registradas pelo `GameController` quando a rodada termina, uma única vez por
rodada. Percentuais = vitórias (ou derrotas) ÷ rodadas concluídas. Uma
rodada abandonada antes do fim (com confirmação) não é contabilizada, mas
sua resposta continua marcada como utilizada. Os dados ficam só em memória.
