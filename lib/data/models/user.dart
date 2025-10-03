// Modelo de usuário autenticado.

class UserProfile {
  final String id;
  final String? name;
  final String? email;
  final String portalDomain;

  UserProfile({
    required this.id,
    required this.portalDomain,
    this.name,
    this.email,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'portal_domain': portalDomain,
      };

  factory UserProfile.fromMap(Map<String, dynamic> map) => UserProfile(
        id: map['id'] as String,
        name: map['name'] as String?,
        email: map['email'] as String?,
        portalDomain: map['portal_domain'] as String,
      );
}