class TeamEntity {
  TeamEntity({
    this.id,
    required this.name,
    required this.region,
    required this.pokemon,
    required this.createdAt,
  });

  factory TeamEntity.fromMap(Map<String, Object?> row) => TeamEntity(
        id: row['id'] as int?,
        name: row['name'] as String? ?? '',
        region: row['region'] as String? ?? '',
        pokemon: row['pokemon'] as String? ?? '[]',
        createdAt: row['created_at'] as String? ?? '',
      );

  final int? id;
  final String name;
  final String region;

  /// Lista de pokémon serializada en JSON.
  final String pokemon;
  final String createdAt;

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'name': name,
        'region': region,
        'pokemon': pokemon,
        'created_at': createdAt,
      };
}
