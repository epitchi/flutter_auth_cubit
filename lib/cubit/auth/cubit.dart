
import 'package:flutter_auth_cubit/cubit/auth/state.dart';
import 'package:flutter_auth_cubit/repo/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
    final AuthRepo _authRepo;

    AuthCubit({required AuthRepo authRepo})
        : _authRepo = authRepo,
            super(const AuthState.initial());

    Future<void> checkAuthStatus() async {
        final isLoggedIn = await _authRepo.isLoggedIn();
        if (isLoggedIn) {
            final user = await _authRepo.getCurrentUser();
            if (user != null){
                emit(AuthState.authenticated(user));
            } else {
                emit(const AuthState.unauthenticated());
            }
        } else {
            emit(const AuthState.unauthenticated());
        }

    }

    void userLoggedIn(String token) async {
        final user = await _authRepo.getCurrentUser();
        if (user != null) {
            emit(AuthState.authenticated(user));
        }
    }

    Future<void> logout() async {
        await _authRepo.logout();
        emit(const AuthState.unauthenticated());
    }

}