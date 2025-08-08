import 'package:equatable/equatable.dart';
import 'package:flutter_auth_cubit/model/user.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;

  const AuthState._({
    required this.status,
    this.user,
  });

  const AuthState.initial() : this._(status: AuthStatus.initial);

  const AuthState.authenticated(User user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  @override
  List<Object?> get props => [status, user];
}