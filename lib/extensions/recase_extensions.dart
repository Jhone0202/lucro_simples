class ReCase {
  final RegExp _upperAlphaRegex = RegExp(r'[A-Z]');

  final symbolSet = {' ', '\\'};

  late String originalText;
  late List<String> _words;

  ReCase(String text) {
    originalText = text;
    _words = _groupIntoWords(text);
  }

  List<String> _groupIntoWords(String text) {
    StringBuffer sb = StringBuffer();
    List<String> words = [];
    bool isAllCaps = text.toUpperCase() == text;

    for (int i = 0; i < text.length; i++) {
      String char = text[i];
      String? nextChar = i + 1 == text.length ? null : text[i + 1];

      if (symbolSet.contains(char)) {
        continue;
      }

      sb.write(char);

      bool isEndOfWord = nextChar == null ||
          (_upperAlphaRegex.hasMatch(nextChar) && !isAllCaps) ||
          symbolSet.contains(nextChar);

      if (isEndOfWord) {
        words.add(sb.toString());
        sb.clear();
      }
    }

    return words;
  }

  String get titleCase => _getPascalCase(separator: ' ');

  String _getPascalCase({String separator = ''}) {
    List<String> words = _words.map(_upperCaseFirstLetter).toList();

    return words.join(separator);
  }

  String _upperCaseFirstLetter(String word) {
    return '${word.substring(0, 1).toUpperCase()}${word.substring(1).toLowerCase()}';
  }

  String get textCase => _upperCaseFirstLetter(originalText);
}

extension StringReCase on String {
  String get titleCase => ReCase(this).titleCase;
  String get textCase => ReCase(this).textCase;
}
