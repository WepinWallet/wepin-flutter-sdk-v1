import AppAuth
import AuthenticationServices
import Flutter
import UIKit

public class WepinFlutterLoginLibPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "wepin_flutter_login_lib", binaryMessenger: registrar.messenger())
        let instance = WepinFlutterLoginLibPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    private var flutterAppAuthTaskId: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    private static let kStateSizeBytes = 32
    private static let kCodeVerifierBytes = 32
    
    func currentViewController() -> UIViewController? {
       return UIApplication.shared.delegate?.window??.rootViewController?.presentedViewController ?? UIApplication.shared.delegate?.window??.rootViewController
    }
   //    var authorizationFlowManagerDelegate: RNAppAuthFlowManagerDelegate!
       

    private var currentSession: OIDExternalUserAgentSession?

    @objc func resumeExternalUserAgentFlow(with url: URL) -> Bool {
       return currentSession?.resumeExternalUserAgentFlow(with: url) ?? false
    }

    @objc static func requiresMainQueueSetup() -> Bool {
       return true
    }


    func authorization(arguments: [String : Any]?, result: @escaping FlutterResult) {
        guard let args = arguments,
              let clientId = args["clientId"] as? String,
              let clientSecret = args["wepinAppId"] as? String else {
          result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid argument for authorization", details: nil))
          return
        }
          
        let configuration = createServiceConfiguration(args["serviceConfiguration"]! as! [String : Any])
        authorizeWithConfiguration(
            wepinAppId: args["wepinAppId"] as! String,
            configuration: configuration,
            redirectUrl: args["redirectUrl"] as! String,
            clientId: args["clientId"] as! String,
            scopes: args["scopes"] as! [String],
            additionalParameters: args["additionalParameters"] as? [String : String],
            skipCodeExchange: args["skipCodeExchange"] as! Bool,
            result: result
        )
    }
    
    private func createServiceConfiguration(_ serviceConfiguration: [String: Any]) -> OIDServiceConfiguration {
        // Create OIDServiceConfiguration from the dictionary
        let authorizationEndpoint = URL(string: serviceConfiguration["authorizationEndpoint"] as! String)!
        let tokenEndpoint = URL(string: serviceConfiguration["tokenEndpoint"] as! String)!

        let configuration = OIDServiceConfiguration(
            authorizationEndpoint: authorizationEndpoint,
            tokenEndpoint: tokenEndpoint
        )

        return configuration
    }
    
    private static func generateCodeVerifier() -> String? {
      return OIDTokenUtilities.randomURLSafeString(withSize: UInt(kCodeVerifierBytes))
    }

    private static func generateState() -> String? {
      return OIDTokenUtilities.randomURLSafeString(withSize: UInt(kStateSizeBytes))
    }

    private static func codeChallengeS256(for codeVerifier: String) -> String? {
        //    guard let codeVerifierData = codeVerifier.data(using: .ascii) else {
        //        return nil
        //    }
        let sha256Verifier = OIDTokenUtilities.sha256(codeVerifier)
        return OIDTokenUtilities.encodeBase64urlNoPadding(sha256Verifier)
    }
    
    /*
    * Authorize a user in exchange for a token with provided OIDServiceConfiguration
    */
    private func authorizeWithConfiguration(
       wepinAppId: String,
       configuration: OIDServiceConfiguration,
       redirectUrl: String,
       clientId: String,
       scopes: [String],
       additionalParameters: [String: String]?,
       skipCodeExchange: Bool,
       result: @escaping FlutterResult
    ) {
       let codeVerifier = Self.generateCodeVerifier()
       let codeChallenge = Self.codeChallengeS256(for: codeVerifier!)
       let state = additionalParameters?["state"] as? String ?? Self.generateState()
       var parameter = additionalParameters
       
       if ((additionalParameters?["state"] as? String) != nil){  parameter?.removeValue(forKey: "state") }
       
       // builds authentication request
       let request = OIDAuthorizationRequest(
           configuration: configuration,
           clientId: clientId,
           clientSecret: nil,
           scope: OIDScopeUtilities.scopes(with: scopes),
           redirectURL: URL(string: redirectUrl)!,
           responseType: OIDResponseTypeCode,
           state: additionalParameters?["state"] as? String ?? Self.generateState(),
           nonce: nil,
           codeVerifier: codeVerifier,
           codeChallenge: codeChallenge,
           codeChallengeMethod: OIDOAuthorizationRequestCodeChallengeMethodS256,
           additionalParameters: additionalParameters
       )

       // performs authentication request
    //    guard let appDelegate = UIApplication.shared.delegate as? (UIApplicationDelegate & RNAppAuthFlowManager) else {
    //        NSException(name: NSExceptionName(rawValue: "RNAppAuth Missing protocol conformance"),
    //                    reason: "\(String(describing: UIApplication.shared.delegate)) does not conform to RNAppAuthFlowManager",
    //                    userInfo: nil).raise()
    //        return
    //    }
    //
    //    appDelegate.authorizationFlowManagerDelegate = self
       weak var weakSelf = self

        flutterAppAuthTaskId = UIApplication.shared.beginBackgroundTask {
           UIApplication.shared.endBackgroundTask(self.flutterAppAuthTaskId)
           self.flutterAppAuthTaskId = UIBackgroundTaskIdentifier.invalid
       }

       let presentingViewController = currentViewController()

       let callback: OIDAuthorizationCallback = { authorizationResponse, error in
           guard let strongSelf = weakSelf else { return }
           strongSelf.currentSession = nil
           UIApplication.shared.endBackgroundTask(strongSelf.flutterAppAuthTaskId)
           strongSelf.flutterAppAuthTaskId = UIBackgroundTaskIdentifier.invalid
           if let authorizationResponse = authorizationResponse {
               result(self.formatAuthorizationResponse(authorizationResponse, withCodeVerifier: codeVerifier))
           } else {
               result(FlutterError(code: self.getErrorCode(error! as NSError, defaultCode: "authentication_failed"), message: self.getErrorMessage(error! as NSError), details: nil))
           }
       }
       
       let tokenCallback: OIDTokenCallback = { authState, error in
           guard let strongSelf = weakSelf else { return }
           strongSelf.currentSession = nil
           UIApplication.shared.endBackgroundTask(strongSelf.flutterAppAuthTaskId)
           strongSelf.flutterAppAuthTaskId = UIBackgroundTaskIdentifier.invalid
           if let authState = authState {
               result(self.formatResponse(authState))
           } else {
               result(FlutterError(code: self.getErrorCode(error! as NSError, defaultCode: "authentication_failed"),
                                   message: self.getErrorMessage(error! as NSError), details: nil))
           }
       }

       let presentationContextProvider = WepinPresentationContextProvider(window: presentingViewController!.view.window)
       let authSession = ASWebAuthenticationSession(url: request.externalUserAgentRequestURL(),
                                                     callbackURLScheme:  "wepin.\(wepinAppId)") { callbackURL, error in
           
           if let callbackURL = callbackURL {
               // Handle the callback URL and process the authentication response
               let authResponse = OIDAuthorizationResponse(request: request, parameters: OIDURLQueryComponent(url: callbackURL)!.dictionaryValue)
               let authState = OIDAuthState(authorizationResponse: authResponse)
               
               if !skipCodeExchange {
                   // Exchange authorization code for access token
                   if let authorizationCode = authState.lastAuthorizationResponse.authorizationCode, let codeVerifier = authState.lastAuthorizationResponse.request.codeVerifier {
                       let tokenRequest = OIDTokenRequest(
                           configuration: configuration,
                           grantType: OIDGrantTypeAuthorizationCode,
                           authorizationCode: authorizationCode,
                           redirectURL: request.redirectURL,
                           clientID: clientId,
                           clientSecret: nil,
                           scope: request.scope,
                           refreshToken: nil,
                           codeVerifier: codeVerifier,
                           additionalParameters: nil)
                       
                       OIDAuthorizationService.perform(tokenRequest, callback: tokenCallback)
                   } else {
                       result(FlutterError(code: self.getErrorCode(error! as NSError, defaultCode: "Missing authorization code or code verifier"), message:
                              self.getErrorMessage(error! as NSError), details: nil))
                   }
               } else {
                   callback(authState.lastAuthorizationResponse, error)
               }
               
           } else if let error = error {
               guard let strongSelf = weakSelf else { return }
               strongSelf.currentSession = nil
               result(FlutterError(code: self.getErrorCode(error as NSError, defaultCode: "authentication_failed"),
                                   message: self.getErrorMessage(error as NSError), details: nil))
           } else {
               guard let strongSelf = weakSelf else { return }
               strongSelf.currentSession = nil
               result(FlutterError(code: "authentication_failed", message: "unknown", details: nil))
           }
       }
           
       authSession.presentationContextProvider = presentationContextProvider
       authSession.start()
    }
    
    /*
    * Take raw OIDAuthorizationResponse and turn it to response format to pass to JavaScript caller
    */
    func formatAuthorizationResponse(_ response: OIDAuthorizationResponse, withCodeVerifier codeVerifier: String?) -> [String: Any] {
      let dateFormatter = DateFormatter()
      dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
      dateFormatter.locale = Locale(identifier: "en_US_POSIX")
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
      
      var result: [String: Any] = [
          "authorizationCode": response.authorizationCode ?? "",
          "state": response.state ?? "",
          "accessToken": response.accessToken ?? "",
          "accessTokenExpirationDate": response.accessTokenExpirationDate != nil ? dateFormatter.string(from: response.accessTokenExpirationDate!) : "",
          "tokenType": response.tokenType ?? "",
          "idToken": response.idToken ?? "",
          "scopes": response.scope != nil ? response.scope!.components(separatedBy: " ") : [],
          "additionalParameters": response.additionalParameters as Any
      ]
      
      if let codeVerifier = codeVerifier {
          result["codeVerifier"] = codeVerifier
      }
      
      return result
    }

    /*
    * Take raw OIDTokenResponse and turn it to a token response format to pass to JavaScript caller
    */
    func formatResponse(_ response: OIDTokenResponse) -> [String: Any] {
      let dateFormatter = DateFormatter()
      dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
      dateFormatter.locale = Locale(identifier: "en_US_POSIX")
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
      
      return [
          "accessToken": response.accessToken ?? "",
          "accessTokenExpirationDate": response.accessTokenExpirationDate != nil ? dateFormatter.string(from: response.accessTokenExpirationDate!) : "",
          "additionalParameters": response.additionalParameters as Any,
          "idToken": response.idToken ?? "",
          "refreshToken": response.refreshToken ?? "",
          "tokenType": response.tokenType ?? ""
      ]
    }

    func getErrorCode(_ error: NSError, defaultCode: String) -> String {
        
        if error.domain == OIDOAuthAuthorizationErrorDomain {
            switch error.code {
            case OIDErrorCodeOAuth.invalidRequest.rawValue:
                return "invalid_request"
            case OIDErrorCodeOAuth.unauthorizedClient.rawValue:
                return "unauthorized_client"
            case OIDErrorCodeOAuth.accessDenied.rawValue:
                return "access_denied"
            case OIDErrorCodeOAuth.unsupportedResponseType.rawValue:
                return "unsupported_response_type"
            case OIDErrorCodeOAuth.invalidScope.rawValue:
                return "invalid_scope"
            case OIDErrorCodeOAuth.serverError.rawValue:
                return "server_error"
            case OIDErrorCodeOAuth.temporarilyUnavailable.rawValue:
                return "temporarily_unavailable"
            default:
                break
            }
        } else if error.domain == OIDOAuthTokenErrorDomain {
            switch error.code {
            case OIDErrorCodeOAuthToken.invalidRequest.rawValue:
                return "invalid_request"
            case OIDErrorCodeOAuthToken.invalidClient.rawValue:
                return "invalid_client"
            case OIDErrorCodeOAuthToken.invalidGrant.rawValue:
                return "invalid_grant"
            case OIDErrorCodeOAuthToken.unauthorizedClient.rawValue:
                return "unauthorized_client"
            case OIDErrorCodeOAuthToken.unsupportedGrantType.rawValue:
                return "unsupported_grant_type"
            case OIDErrorCodeOAuthToken.invalidScope.rawValue:
                return "invalid_scope"
            default:
                break
            }
        } else if error.domain == ASWebAuthenticationSessionErrorDomain {
            switch error.code {
            case ASWebAuthenticationSessionError.canceledLogin.rawValue:
                return "user_canceled"
            case ASWebAuthenticationSessionError.presentationContextNotProvided.rawValue:
                return "required_context"
            case ASWebAuthenticationSessionError.presentationContextNotProvided.rawValue:
                return "invalid_context"
            default:
                break;
            }
        }
        switch error.code {
        case OIDErrorCode.userCanceledAuthorizationFlow.rawValue:
            return "user_canceled"
        case OIDErrorCode.browserOpenError.rawValue:
            return "browser_open_error"
        case OIDErrorCode.networkError.rawValue:
            return "network_error"
        default:
            break
        }
        

        return defaultCode
    }

    func getErrorMessage(_ error: NSError) -> String {
        if let userInfo = error.userInfo as? [String: Any],
           let oauthError = userInfo[OIDOAuthErrorResponseErrorKey] as? [String: Any],
           let errorDescription = oauthError[OIDOAuthErrorFieldErrorDescription] as? String {
            return errorDescription
        } else {
            return error.localizedDescription
        }
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "authorize":
            authorization(arguments: (call.arguments as! [String : Any]), result: result)
        default:
          result(FlutterMethodNotImplemented)
        }
    }
}

class WepinPresentationContextProvider: NSObject, ASWebAuthenticationPresentationContextProviding {
    private weak var window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
    }

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return window ?? ASPresentationAnchor()
    }
}

