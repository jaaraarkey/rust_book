import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? profilePictureUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isEmailVerified;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.profilePictureUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.isEmailVerified,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        profilePictureUrl,
        createdAt,
        updatedAt,
        isEmailVerified,
      ];

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? profilePictureUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEmailVerified,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }
}
