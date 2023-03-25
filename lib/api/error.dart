typedef JsonObj = Map<String, dynamic>;

Exception handleException(int statusCode) {
  switch (statusCode) {
    case 400:
      return GeneralError();
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
  GeneralError() : super();
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
