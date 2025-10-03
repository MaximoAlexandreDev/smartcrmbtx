// Item de fila de sincronização que descreve uma chamada REST ao Bitrix.

class SyncJob {
  final String id; // UUID
  final String method; // Ex.: 'tasks.task.add' ou 'crm.contact.add'
  final String payload; // JSON string
  final String status; // PENDING | SUCCESS | ERROR
  final int attempts;
  final String? lastError;
  final int createdAt;
  final int updatedAt;

  SyncJob({
    required this.id,
    required this.method,
    required this.payload,
    required this.status,
    required this.attempts,
    required this.createdAt,
    required this.updatedAt,
    this.lastError,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'method': method,
        'payload': payload,
        'status': status,
        'attempts': attempts,
        'last_error': lastError,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  factory SyncJob.fromMap(Map<String, dynamic> map) => SyncJob(
        id: map['id'] as String,
        method: map['method'] as String,
        payload: map['payload'] as String,
        status: map['status'] as String,
        attempts: map['attempts'] as int,
        lastError: map['last_error'] as String?,
        createdAt: map['created_at'] as int,
        updatedAt: map['updated_at'] as int,
      );
}