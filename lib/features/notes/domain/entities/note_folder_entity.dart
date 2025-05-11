class NoteFolderEntity {
  final String id;
  final String name;
  final String? color;

  NoteFolderEntity({required this.id, required this.name, this.color});
  NoteFolderEntity copyWith({String? id, String? name, String? color}) {
    return NoteFolderEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  factory NoteFolderEntity.fromJson(Map<String, dynamic> json) {
    return NoteFolderEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      color: json['color'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'color': color};
  }
}
