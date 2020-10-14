import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated }

class AuthController extends GetxController {
  var authStatus = Rx<AuthStatus>(AuthStatus.initial);
  var username = RxString();

  GetStorage getStorage = GetStorage();

  Future<void> authCheck() async {
    if (await getStorage.read('username') != null) {
      username.value = await getStorage.read('username');
      authStatus.value = AuthStatus.authenticated;
    } else {
      authStatus.value = AuthStatus.unauthenticated;
    }
  }

  Future<void> login(String username) async {
    await getStorage.write('username', username);
    this.username.value = username;
    authStatus.value = AuthStatus.loading;
    await Future.delayed(Duration(seconds: 1));
    authStatus.value = AuthStatus.authenticated;
  }

  Future<void> logout() async {
    await getStorage.remove('username');
    this.username.value = '';
    authStatus.value = AuthStatus.loading;
    await Future.delayed(Duration(seconds: 1));
    authStatus.value = AuthStatus.unauthenticated;
  }
}
