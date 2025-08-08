
import 'package:flutter_auth_cubit/cubit/auth/cubit.dart';
import 'package:flutter_auth_cubit/cubit/login/state.dart';
import 'package:flutter_auth_cubit/model/login_form.dart';
import 'package:flutter_auth_cubit/repo/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepo _authRepo;
  final AuthCubit _authCubit;

  LoginCubit({
    required AuthRepo authRepo,
    required AuthCubit authCubit,
  }) : _authRepo = authRepo,
      _authCubit = authCubit,
      super(const LoginState());
    
  void emailChanged(String value){
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      isValid: Formz.validate([email, state.password]),
      errorMessage: null,
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      isValid: Formz.validate([state.email, password]),
      errorMessage: null
    ));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  Future<void> login() async {
    if (!state.isValid) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      final auth = await _authRepo.login(state.email.value, state.password.value);

      emit(state.copyWith(status: FormzSubmissionStatus.success));

      _authCubit.userLoggedIn(auth.token);
    } catch (error){
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: error.toString().replaceFirst('Exception', '')
      ));
    }
  }

  void resetForm() {
    emit(const LoginState());
  }
}