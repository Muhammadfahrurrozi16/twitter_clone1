import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../apis/auth_api.dart';
import '../../../core/core.dart';
import '../view/login_view.dart';
import '../home/home_view.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController,bool>((ref) {
  return AuthController(
    authAPI: ref.watch(authAPIProvider),
  );
});

// final currentUserAccountProvider = FutureProvider((ref) {
//  final authController = ref.watch(authControllerProvider.notifier);
//  return authController.currentUser();
// });


class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  AuthController({required AuthAPI authAPI})
      : _authAPI = authAPI,
        super(false);
  // state = isLoading

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackbar(context,l.message),
      (r) {
        showSnackbar(context,'akun telah dibuat,silahkan login');
        Navigator.push(context,LoginView.route());
      },
    );
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.login(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) {
        showSnackbar(context,l.message);
      },
      (r) {
        Navigator.push(context,Homeview.route());
        },
    );
  }
}
