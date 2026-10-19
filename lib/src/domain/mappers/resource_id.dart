/// Extrae el id numérico de una url de PokeAPI.
/// `https://pokeapi.co/api/v2/region/1/` → `1`.
int resourceIdFromUrl(String? url) {
  if (url == null || url.isEmpty) return 0;
  final segments = Uri.parse(url).pathSegments.where((s) => s.isNotEmpty);
  return segments.isEmpty ? 0 : int.tryParse(segments.last) ?? 0;
}
