// lib/features/auth/data/models/auth_model.dart

/// Raw API response model — JSON lives only here.
class AuthModel {
  final String token;
  final String expiration;
  final String email;
  final String role;

  const AuthModel({
    required this.token,
    required this.expiration,
    required this.email,
    required this.role,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        token:      json['token']      as String,
        expiration: json['expiration'] as String,
        email:      json['email']      as String,
        role:       json['role']       as String,
      );
}
