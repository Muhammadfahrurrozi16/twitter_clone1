import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../model/user_models.dart';
import '../../../apis/user_api.dart';

final searchControllerProvider = StateNotifierProvider((ref) {
  return SearchControllers(userApi: ref.watch(userApiProvider),);

});

final searchUserProvider = FutureProvider.family((ref,String name) async {
  final searchController = ref.watch(searchControllerProvider.notifier);
  return searchController.searchUser(name);
});

class SearchControllers extends StateNotifier<bool> {
  final UserApi _userApi;
  SearchControllers({
    required UserApi userApi,
  }): _userApi = userApi, 
  super(false);

  Future<List<UserModel>> searchUser(String name) async{
    final users = await _userApi.searchUserByname(name);
    return users.map((e) => UserModel.fromMap(e.data)).toList();
  }
  
}