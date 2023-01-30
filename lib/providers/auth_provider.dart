import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_station/api/http.dart';
import '../api/interfaces/user_api.dart' show loginUser, logoutUser;
import '../models/user.dart';

const _kDataKey = 'logined_user';

class AuthProvider extends ChangeNotifier {
  late SharedPreferences pref;
  User? user;

  AuthProvider(this.pref) {
    final loginedUser = pref.getStringList(_kDataKey);
    if (loginedUser != null) {
      user = User(
        uid: int.parse(loginedUser[0]),
        nickname: loginedUser[1],
      );
      HttpClient().setAuthKey(loginedUser[2]);
    }
  }

  bool get isLogined {
    return user != null;
  }

  Future<bool> login(int sid, String password) async {
    return loginUser(sid, password).then((data) {
      //寫入緩存
      HttpClient().setAuthKey(data.token);
      user = data.user;
      //寫入本地
      pref.setStringList(_kDataKey, [
        data.user.uid.toString(),
        data.user.nickname,
        data.token,
        data.validTime.toString(),
      ]);
      notifyListeners();
      return true;
    });
  }

  Future<void> logout() async {
    await logoutUser();
    clearLoginData();
    return Future.value();
  }

  void clearLoginData() {
    //清楚緩存資料
    user = null;
    HttpClient().setAuthKey('');
    //清楚本地資料
    pref.remove(_kDataKey);
    notifyListeners();
  }
}
