import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone1/models/user_models.dart';
import '../../../apis/auth_api.dart';
import '../../../core/core.dart';
import '../view/login_view.dart';
import '../../../apis/user_api.dart';
import '../../home/view/home_view.dart';
import 'package:appwrite/models.dart' as model;

final authControllerProvider =
    StateNotifierProvider<AuthController,bool>((ref) {
  return AuthController(
    authAPI: ref.watch(authAPIProvider),
    userApi: ref.watch(userApiProvider),
  );
});

final currentUserAccountProvider = FutureProvider((ref) {
 final authController = ref.watch(authControllerProvider.notifier);
 return authController.currentUser();
});


class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserApi _userApi;
  AuthController({required AuthAPI authAPI,required UserApi userApi})
      : _authAPI = authAPI,
      _userApi = userApi,
        super(false);
  // state = isLoading

Future<model.Account?>currentUser() => _authAPI.currentUserAccount();
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
      (r) async {
        UserModel userModel = UserModel(email: email, name: getNamefromEmail(email), followers:const [], following:const [], profilePic: '', bannerPic: '', uid: '', bio: '', isTwitterBlue: false);
        final res2 = await _userApi.saveUserData(userModel);
        res2.fold((l) => showSnackbar(context,l.message), (r) {showSnackbar(context,'akun telah dibuat,silahkan login');
        Navigator.push(context,LoginView.route());
        });
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
