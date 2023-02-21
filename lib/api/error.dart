typedef JsonObj = Map<String, dynamic>;

Exception handleException(int statusCode, JsonObj errData) {
  switch (statusCode) {
    case 400:
      return GeneralError(errData);
    case 401:
      return AuthorizationError();
    case 403:
      return PermissionError();
    case 404:
      return NoResourceError();
    case 422:
      return ParametersError();
    case 460:
      return FrquentError();
    default:
      return NetworkError();
  }
}

class GeneralError implements Exception {
  late int reasonID;
  late dynamic extraData;
  GeneralError(JsonObj errData) {
    reasonID = errData['reason_id'] ?? 0;
    extraData = errData['extra_data'];
  }
}

class AuthorizationError implements Exception {
  AuthorizationError() : super();
}

class PermissionError implements Exception {
  PermissionError() : super();
}

class NoResourceError implements Exception {
  NoResourceError() : super();
}

class ParametersError implements Exception {
  ParametersError() : super();
}

class FrquentError implements Exception {
  FrquentError() : super();
}

class NetworkError implements Exception {
  NetworkError() : super();
}

class UnknownError implements Exception {
  UnknownError() : super();
}
