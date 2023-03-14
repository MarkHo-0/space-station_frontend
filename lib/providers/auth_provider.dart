import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_station/api/http.dart';
import '../api/interfaces/user_api.dart' show loginUser, logoutUser;
import '../models/user.dart';

const _kDataKey = 'logined_data';

class AuthProvider extends ChangeNotifier {
  late SharedPreferences pref;
  UserInfo? user;

  AuthProvider(this.pref) {
    final loginedData = pref.getStringList(_kDataKey);
    if (loginedData != null) {
      user = UserInfo.fromString(loginedData[0]);
      HttpClient().setAuthKey(loginedData[1]);
    }
  }

  bool get isLogined {
    return user != null;
  }

  Future<void> login(int sid, String password) async {
    return loginUser(sid, password).then((data) {
      //寫入緩存
      HttpClient().setAuthKey(data.token);
      user = data.user;
      //寫入本地
      pref.setStringList(_kDataKey, [
        user.toString(),
        data.token,
        data.validTime.toString(),
      ]);
      return notifyListeners();
    });
  }

  Future<void> logout() async {
    if (!isLogined) return Future.value();
    return logoutUser()
        .then((_) => clearLoginData())
        .then((_) => notifyListeners());
  }

  Future<bool> clearLoginData() {
    user = null;
    HttpClient().setAuthKey('');
    return pref.remove(_kDataKey);
  }
}
