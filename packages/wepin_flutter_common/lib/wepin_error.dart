enum WepinErrorCode {
  apiRequestError,
  invalidParameters,
  notInitialized,
  invalidAppKey,
  invalidLoginProvider,
  invalidToken,
  invalidLoginSession,
  userCancelled,
  unknownError,
  notConnectedInternet,
  failedLogin,
  alreadyLogout,
  alreadyInitialized,
  invalidEmailDomain,
  failedSendEmail,
  requiredEmailVerified,
  incorrectEmailForm,
  incorrectPasswordForm,
  notInitializedNetwork,
  requiredSignupEmail,
  failedEmailVerified,
  failedPasswordStateSetting,
  failedPasswordSetting,
  existedEmail,
  // Wepin Widget SDK Error
  incorrectLifecycleException,
  failedRegister,
  failedSend,
  nftNotFound,
  invalidContext,
  accountNotFound,
  noBalancesFound,
}

extension WepinLoginErrorCodeExtension on WepinErrorCode {
  String get code {
    switch (this) {
      case WepinErrorCode.apiRequestError:
        return 'ApiRequestError';
      case WepinErrorCode.invalidParameters:
        return 'InvalidParameters';
      case WepinErrorCode.notInitialized:
        return 'NotInitialized';
      case WepinErrorCode.invalidAppKey:
        return 'InvalidAppKey';
      case WepinErrorCode.invalidLoginProvider:
        return 'InvalidLoginProvider';
      case WepinErrorCode.invalidToken:
        return 'InvalidToken';
      case WepinErrorCode.invalidLoginSession:
        return 'InvalidLoginSession';
      case WepinErrorCode.userCancelled:
        return 'UserCancelled';
      case WepinErrorCode.unknownError:
        return 'UnknownError';
      case WepinErrorCode.notConnectedInternet:
        return 'NotConnectedInternet';
      case WepinErrorCode.failedLogin:
        return 'FailedLogin';
      case WepinErrorCode.alreadyLogout:
        return 'AlreadyLogout';
      case WepinErrorCode.alreadyInitialized:
        return 'AlreadyInitialized';
      case WepinErrorCode.invalidEmailDomain:
        return 'InvalidEmailDomain';
      case WepinErrorCode.failedSendEmail:
        return 'FailedSendEmail';
      case WepinErrorCode.requiredEmailVerified:
        return 'RequiredEmailVerified';
      case WepinErrorCode.incorrectEmailForm:
        return 'IncorrectEmailForm';
      case WepinErrorCode.incorrectPasswordForm:
        return 'IncorrectPasswordForm';
      case WepinErrorCode.notInitializedNetwork:
        return 'NotInitializedNetwork';
      case WepinErrorCode.requiredSignupEmail:
        return 'RequiredSignupEmail';
      case WepinErrorCode.failedEmailVerified:
        return 'FailedEmailVerified';
      case WepinErrorCode.failedPasswordStateSetting:
        return 'FailedPasswordStateSetting';
      case WepinErrorCode.failedPasswordSetting:
        return 'FailedPasswordSetting';
      case WepinErrorCode.existedEmail:
        return 'ExistedEmail';
      case WepinErrorCode.invalidContext:
        return 'InvalidContext';
      case WepinErrorCode.incorrectLifecycleException:
        return 'IncorrectLifecycleException';
      case WepinErrorCode.failedRegister:
        return 'FailedRegister';
      case WepinErrorCode.accountNotFound:
        return 'AccountNotFound';
      case WepinErrorCode.nftNotFound:
        return 'NftNotFound';
      case WepinErrorCode.failedSend:
        return 'FailedSend';
      default:
        return 'UnknownError';
    }
  }
}

class WepinError extends Error {
  final WepinErrorCode code;
  final String message;

  WepinError(this.code, [String? message])
      : message = message ?? code.code,
        super();

  @override
  String toString() {
    return 'WepinError(code: ${code.code}, message: $message)';
  }
}