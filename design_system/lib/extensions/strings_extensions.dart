extension StringCasingExtension on String {
  /// `bulbasaur` → `Bulbasaur`, `mr-mime` → `Mr Mime`.
  String get capitalize {
    if (isEmpty) return this;
    return split(RegExp('[-_ ]'))
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  /// Limpia saltos de línea y caracteres de control de los textos de PokeAPI.
  String get cleanFlavorText =>
      replaceAll(RegExp(r'[\n\f\r]'), ' ').replaceAll(RegExp(' +'), ' ').trim();
}
