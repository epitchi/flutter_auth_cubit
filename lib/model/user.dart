import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String username;
  final DateTime created;
  final DateTime updated;
  final UserMetadata metadata;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.username,
    required this.created,
    required this.updated,
    required this.metadata,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
      metadata: UserMetadata.fromJson(json['metadata'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'username': username,
      'created': created,
      'updated': updated,
      'metadata': metadata
    };
  }

  @override
  List<Object?> get props => [id, email, name, username, created, updated, metadata];
}

class UserMetadata extends Equatable {
  final String? reference;
  final String? demo;

  const UserMetadata({
    this.reference,
    this.demo
  });

  factory UserMetadata.fromJson(Map<String, dynamic> json) {
    return UserMetadata(
      reference: json['reference'],
      demo: json['demo']
    );
  }

  @Object()
  List<Object?> get props => [reference, demo];
}