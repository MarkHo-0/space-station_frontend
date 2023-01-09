Exception handleException(int statusCode) {
  switch (statusCode) {
    case 400:
      return GeneralError("General Error");
    case 401:
      return AuthorizationError("Authorization Error");
    case 403:
      return PermissionError("Permission Error");
    case 404:
      return NoResourceError("NoResource Error");
    case 422:
      return ParametersError("Parameters Error");
    case 460:
      return FrquentError("Frquent Error");
    default:
      return NetWorkError("NetWork Error");
  }
}

class GeneralError implements Exception {
  String errormsg;
  GeneralError(this.errormsg);
}

class AuthorizationError implements Exception {
  String errormsg;
  AuthorizationError(this.errormsg);
}

class PermissionError implements Exception {
  String errormsg;
  PermissionError(this.errormsg);
}

class NoResourceError implements Exception {
  String errormsg;
  NoResourceError(this.errormsg);
}

class ParametersError implements Exception {
  String errormsg;
  ParametersError(this.errormsg);
}

class FrquentError implements Exception {
  String errormsg;
  FrquentError(this.errormsg);
}

class NetWorkError implements Exception {
  String errormsg;
  NetWorkError(this.errormsg);
}
