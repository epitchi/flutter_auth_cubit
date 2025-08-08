import 'package:equatable/equatable.dart';
import 'package:flutter_auth_cubit/model/user.dart';

class Auth extends Equatable {
  final String token;
  final User record;

  const Auth({
    required this.token,
    required this.record,
  });

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
      token: json['record'],
      record: User.fromJson(json['record'])
    );
  }

  @override
  List<Object?> get props => [token, record];
}

class AuthException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;

  const AuthException({
    required this.message,
    this.code,
    this.statusCode,
  });

  @override
  String toString() => message;
}