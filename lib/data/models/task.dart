// Modelo de Tarefa local (exemplo de entidade para operar offline e sincronizar no Bitrix24).

class TaskModel {
  final String id; // UUID local
  final String title;
  final String? description;
  final String status; // e.g., "open", "done"
  final int createdAt;
  final int updatedAt;
  final String? remoteId; // ID retornado pelo Bitrix após sync

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.remoteId,
  });

  TaskModel copyWith({
    String? title,
    String? description,
    String? status,
    int? updatedAt,
    String? remoteId,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      remoteId: remoteId ?? this.remoteId,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'status': status,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'remote_id': remoteId,
      };

  factory TaskModel.fromMap(Map<String, dynamic> map) => TaskModel(
        id: map['id'] as String,
        title: map['title'] as String,
        description: map['description'] as String?,
        status: map['status'] as String,
        createdAt: map['created_at'] as int,
        updatedAt: map['updated_at'] as int,
        remoteId: map['remote_id'] as String?,
      );
}