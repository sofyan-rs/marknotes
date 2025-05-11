class NoteFolderEntity {
  final String id;
  final String name;
  final String? color;
  final int index;

  NoteFolderEntity({
    required this.id,
    required this.name,
    required this.index,
    this.color,
  });

  NoteFolderEntity copyWith({
    String? id,
    String? name,
    String? color,
    int? index,
  }) {
    return NoteFolderEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      index: index ?? this.index,
      color: color ?? this.color,
    );
  }

  factory NoteFolderEntity.fromJson(Map<String, dynamic> json) {
    return NoteFolderEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      index: json['index'] as int,
      color: json['color'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'color': color, 'index': index};
  }
}
