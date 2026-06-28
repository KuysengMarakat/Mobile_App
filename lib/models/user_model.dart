/// Model representing an authenticated user session.
class UserModel {
  final String id;
  final String displayName;
  final String authMethod; // 'biometric' or 'demo'
  final DateTime loggedInAt;

  UserModel({
    required this.id,
    required this.displayName,
    required this.authMethod,
    required this.loggedInAt,
  });

  /// Create a demo user for presentation/testing purposes.
  factory UserModel.demo() {
    return UserModel(
      id: 'demo_user_001',
      displayName: 'Demo User',
      authMethod: 'demo',
      loggedInAt: DateTime.now(),
    );
  }

  /// Create a biometric-authenticated user.
  factory UserModel.biometric() {
    return UserModel(
      id: 'bio_user_001',
      displayName: 'Authenticated User',
      authMethod: 'biometric',
      loggedInAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,
      'authMethod': authMethod,
      'loggedInAt': loggedInAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      displayName: map['displayName'] as String,
      authMethod: map['authMethod'] as String,
      loggedInAt: DateTime.parse(map['loggedInAt'] as String),
    );
  }

  @override
  String toString() =>
      'UserModel(id: $id, name: $displayName, auth: $authMethod)';
}
