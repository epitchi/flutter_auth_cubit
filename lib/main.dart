import 'package:flutter/material.dart';
import 'package:flutter_auth_cubit/api/endpoint.dart';
import 'package:flutter_auth_cubit/cubit/auth/cubit.dart';
import 'package:flutter_auth_cubit/cubit/auth/state.dart';
import 'package:flutter_auth_cubit/cubit/login/cubit.dart';
import 'package:flutter_auth_cubit/repo/auth.dart';
import 'package:flutter_auth_cubit/screen/home.dart';
import 'package:flutter_auth_cubit/screen/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase(Endpoints.baseURL);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepo(),
      child: BlocProvider(
        create: (context) =>
            AuthCubit(authRepo: context.read<AuthRepo>())..checkAuthStatus(),

        child: MaterialApp(
          title: 'Flutter Cubit',
          theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
          home: const AuthWrapper(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        switch (state.status) {
          case AuthStatus.authenticated:
            return const HomeScreen();
          case AuthStatus.unauthenticated:
            return BlocProvider(
              create: (context) => LoginCubit(
                authRepo: context.read<AuthRepo>(),
                authCubit: context.read<AuthCubit>(),
              ),
              child: const LoginScreen(),
            );
          case AuthStatus.initial:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
        }
      },
    );
  }
}
