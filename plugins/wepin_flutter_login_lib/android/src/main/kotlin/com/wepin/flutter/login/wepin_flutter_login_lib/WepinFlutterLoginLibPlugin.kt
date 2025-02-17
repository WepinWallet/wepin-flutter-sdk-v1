package com.wepin.flutter.login.wepin_flutter_login_lib

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import androidx.browser.customtabs.CustomTabsIntent
import at.favre.lib.bytes.Bytes
import at.favre.lib.crypto.bcrypt.BCrypt
import at.favre.lib.crypto.bcrypt.BCrypt.SALT_LENGTH
import at.favre.lib.crypto.bcrypt.Radix64Encoder
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import net.openid.appauth.*
import net.openid.appauth.connectivity.ConnectionBuilder
import net.openid.appauth.connectivity.DefaultConnectionBuilder
import java.text.SimpleDateFormat
import java.util.*


/** WepinFlutterLoginLibPlugin */
class WepinFlutterLoginLibPlugin: FlutterPlugin, MethodCallHandler, PluginRegistry.ActivityResultListener, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private var applicationContext: Context? = null
  private var mainActivity: Activity? = null

//  private var authorizationRequestHeaders: Map<String, String>? = null
  private var additionalParametersMap: Map<String, String>? = null
  private var skipCodeExchange: Boolean? = null
//  private val mServiceConfigurations: ConcurrentHashMap<String, AuthorizationServiceConfiguration?> =
//    ConcurrentHashMap<String, AuthorizationServiceConfiguration?>()

  private var codeVerifier: String? = null
  private var state: String? = null

  private var result: Result? = null

  private fun setActivity(flutterActivity: Activity) {
    mainActivity = flutterActivity
  }

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    applicationContext = flutterPluginBinding.applicationContext
//    var defaultAuthorizationService = AuthorizationService(applicationContext!!)
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "wepin_flutter_login_lib")
    channel.setMethodCallHandler(this)
  }

  private fun authorize(
    argument: Map<String, Any>,
//    wepinAppId: String,
//    redirectUrl: String,
//    clientId: String,
//    scopes: ReadableArray?,
//    additionalParameters: ReadableMap?,
//    serviceConfiguration: ReadableMap?,
//    skipCodeExchange: Boolean,
//    connectionTimeoutMillis: Double,
//    customHeaders: ReadableMap?,
//    androidAllowCustomBrowsers: ReadableArray?,
//    androidTrustedWebActivity: Boolean,
    result: Result
  ) {
    val builder: ConnectionBuilder = createConnectionBuilder()
    val appAuthConfiguration: AppAuthConfiguration = createAppAuthConfiguration(builder)
    val additionalParametersMap: HashMap<String, String>? =
      if (argument.containsKey("additionalParameters")) argument["additionalParameters"] as HashMap<String, String> else null

    // store args in private fields for later use in onActivityResult handler
    this.additionalParametersMap = additionalParametersMap
    this.skipCodeExchange = argument["skipCodeExchange"] as Boolean
    this.result = result

    // when serviceConfiguration is provided, we don't need to hit up the OpenID
    // well-known id endpoint
    try {
      val serviceConfig: AuthorizationServiceConfiguration = createAuthorizationServiceConfiguration(
        if (argument.containsKey("serviceConfiguration")) argument["serviceConfiguration"] as HashMap<String, String> else null
      )
      authorizeWithConfiguration(
        serviceConfig,
        appAuthConfiguration,
        argument["clientId"] as String,
        if (argument["scopes"] != null) argument["scopes"] as List<String> else null,
        argument["redirectUrl"] as String,
        additionalParametersMap,
      )
    } catch (e: ActivityNotFoundException) {
      result.error("browser_not_found", e.message, null)
    } catch (e: Exception) {
      result.error("authentication_failed", e.message, null)
    }

  }

  /*
     * Authorize user with the provided configuration
     */
  private fun authorizeWithConfiguration(
    serviceConfiguration: AuthorizationServiceConfiguration?,
    appAuthConfiguration: AppAuthConfiguration,
    clientId: String,
    scopes: List<String>?,
    redirectUrl: String,
    additionalParametersMap: MutableMap<String, String>?,
  ) {
    var scopesString: String? = null
    if (scopes != null) {
      scopesString = arrayToString(scopes)
    }
//    val context: Context = reactContext
//    val currentActivity: Activity? = getCurrentActivity()
    val authRequestBuilder: AuthorizationRequest.Builder? =
      serviceConfiguration?.let {
        AuthorizationRequest.Builder(
          it,
          clientId,
          ResponseTypeValues.CODE,
          Uri.parse(redirectUrl)
        )
      }
    if(authRequestBuilder != null){
      if (scopesString != null) {
        authRequestBuilder.setScope(scopesString)
      }
      if (additionalParametersMap != null) {
        // handle additional parameters separately to avoid exceptions from AppAuth
        if (additionalParametersMap.containsKey("display")) {
          authRequestBuilder.setDisplay(additionalParametersMap["display"])
          additionalParametersMap.remove("display")
        }
        if (additionalParametersMap.containsKey("login_hint")) {
          authRequestBuilder.setLoginHint(additionalParametersMap["login_hint"])
          additionalParametersMap.remove("login_hint")
        }
        if (additionalParametersMap.containsKey("prompt")) {
          authRequestBuilder.setPrompt(additionalParametersMap["prompt"])
          additionalParametersMap.remove("prompt")
        }
        if (additionalParametersMap.containsKey("state")) {
          authRequestBuilder.setState(additionalParametersMap["state"])
          state = additionalParametersMap["state"]
          additionalParametersMap.remove("state")
        }
        if (additionalParametersMap.containsKey("nonce")) {
          authRequestBuilder.setNonce(additionalParametersMap["nonce"])
          additionalParametersMap.remove("nonce")
        }
        if (additionalParametersMap.containsKey("ui_locales")) {
          authRequestBuilder.setUiLocales(additionalParametersMap["ui_locales"])
          additionalParametersMap.remove("ui_locales")
        }
        if (additionalParametersMap.containsKey("response_mode")) {
          authRequestBuilder.setResponseMode(additionalParametersMap["response_mode"])
          additionalParametersMap.remove("response_mode")
        }
        authRequestBuilder.setAdditionalParameters(additionalParametersMap)
      }
      codeVerifier = CodeVerifierUtil.generateRandomCodeVerifier()
      authRequestBuilder.setCodeVerifier(codeVerifier)

//        if (!useNonce!!) {
//            authRequestBuilder.setNonce(null)
//        }
      val authRequest: AuthorizationRequest = authRequestBuilder.build()
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
        val authService = applicationContext?.let { AuthorizationService(it, appAuthConfiguration) }
        val intentBuilder: CustomTabsIntent.Builder? =
          authService?.createCustomTabsIntentBuilder()
        val customTabsIntent: CustomTabsIntent? = intentBuilder?.build()
//        if (androidTrustedWebActivity) {
//          customTabsIntent?.intent?.putExtra(
//            TrustedWebUtils.EXTRA_LAUNCH_AS_TRUSTED_WEB_ACTIVITY,
//            true
//          )
//        }
        val authIntent: Intent? = authService?.getAuthorizationRequestIntent(authRequest, customTabsIntent!!)
        mainActivity?.startActivityForResult(authIntent, 52)
      } else {
        if ( mainActivity != null){
          val authService = AuthorizationService(mainActivity!!, appAuthConfiguration)
          val pendingIntent = mainActivity!!.createPendingResult(52, Intent(), 0)
          authService.performAuthorizationRequest(authRequest, pendingIntent)
        }
      }

    }
  }

  /*
     * Create a space-delimited string from an array
     */
  private fun arrayToString(array: List<String>): String {
    val strBuilder = StringBuilder()
    for (i in array.indices) {
      if (i != 0) {
        strBuilder.append(' ')
      }
      strBuilder.append(array[i])
    }
    return strBuilder.toString()
  }

  /*
     * Create an App Auth configuration using the provided connection builder
     */
  private fun createAppAuthConfiguration(
    connectionBuilder: ConnectionBuilder,
  ): AppAuthConfiguration {
    return AppAuthConfiguration.Builder()
      .setConnectionBuilder(connectionBuilder)
      .build()
  }

  /*
   * Create appropriate connection builder based on provided settings
   */
  private fun createConnectionBuilder(): ConnectionBuilder {
    val proxiesBuilder: ConnectionBuilder
    proxiesBuilder = DefaultConnectionBuilder.INSTANCE

    return CustomConnectionBuilder(proxiesBuilder)
  }

  /*
   * Replicated private method from AuthorizationServiceConfiguration
   */
  private fun buildConfigurationUriFromIssuer(openIdConnectIssuerUri: Uri): Uri {
    return openIdConnectIssuerUri.buildUpon()
      .appendPath(AuthorizationServiceConfiguration.WELL_KNOWN_PATH)
      .appendPath(AuthorizationServiceConfiguration.OPENID_CONFIGURATION_RESOURCE)
      .build()
  }

  @Throws(Exception::class)
  private fun createAuthorizationServiceConfiguration(serviceConfiguration: Map<String, Any>?): AuthorizationServiceConfiguration {
    if(serviceConfiguration != null){
      if (!serviceConfiguration.containsKey("authorizationEndpoint")) {
        throw Exception("serviceConfiguration passed without an authorizationEndpoint")
      }
      if (!serviceConfiguration.containsKey("tokenEndpoint")) {
        throw Exception("serviceConfiguration passed without a tokenEndpoint")
      }
      val authorizationEndpoint =
        Uri.parse(serviceConfiguration["authorizationEndpoint"] as String?)
      val tokenEndpoint = Uri.parse(serviceConfiguration["tokenEndpoint"] as String?)
      return AuthorizationServiceConfiguration(
        authorizationEndpoint,
        tokenEndpoint,
      )
    } else {
      throw Exception("serviceConfiguration null")
    }

  }


  private fun handleAuthorizationException(
    fallbackErrorCode: String, ex: AuthorizationException?,
    result: Result
  ) {
    if (ex != null) {
      if (ex.errorDescription == null) {
        result.error(fallbackErrorCode, ex.localizedMessage ?: fallbackErrorCode, ex)
      } else {
        if (ex == AuthorizationException.GeneralErrors.USER_CANCELED_AUTH_FLOW) {
          result.error(
            "user_canceled",
            ex.localizedMessage,
            ex
          )
          return
        }
        result.error(
          ex.errorDescription ?: fallbackErrorCode,
          ex.localizedMessage,
          ex
        )
      }
    }
  }

  fun MethodCall.password(): String? {
    return this.argument("password")
  }

  fun MethodCall.salt(): String? {
    return this.argument("salt")
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    val arguments: Map<String, Any>? = call.arguments()
     if (call.method == "authorize"){
      authorize(arguments!!, result)
    } else if(call.method == "hashPw") {
       // Based on MIT-licensed code from Flutter_Bcrypt
       // Original repository: https://github.com/jeroentrappers/flutter_bcrypt
       val salt: String = call.salt()!!
       val realSalt: String
       val rounds: Int
       val off: Int
       var minor = 'b'
       val password: String = call.password()!!
       var version: BCrypt.Version = BCrypt.Version.VERSION_2B

       if (salt[0] != '\$' || salt[1] != '2') {
         throw Exception("Invalid salt version")
       }
       if (salt[2] == '\$') {
         off = 3
       } else {
         minor = salt[2]
         if ((minor != 'a' && minor != 'b' && minor != 'y') || salt[3] != '\$') {
           throw Exception("Invalid salt revision")
         }
         off = 4
       }

       // Extract number of rounds
       if (salt[off + 2] > '\$') {
         throw Exception("Missing salt rounds")
       }
       rounds = Integer.parseInt(salt.substring(off, off + 2))

       realSalt = salt.substring(off + 3, off + 25)

       if ('a' == minor) {
         version = BCrypt.Version.VERSION_2A
       } else if ('b' == minor) {
         version = BCrypt.Version.VERSION_2B
       }

       val hash = BCrypt.with(version).hash(
         rounds,
         Radix64Encoder.Default().decode(realSalt.toByteArray(Charsets.UTF_8)),
         password.toByteArray(Charsets.UTF_8)
       )

       val r = String(hash, Charsets.UTF_8)

       result.success(r)
     } else {
      result.notImplemented()
    }
  }


  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
    try {
      if (requestCode == 52) {
        val currentResult = result // promise를 로컬 변수로 복사하여 스마트 캐스트 문제 해결
        if (data == null) {
          currentResult?.error("authentication_error", "Data intent is null", null)
          return true
        }
//        val EXTRA_RESPONSE = "net.openid.appauth.AuthorizationResponse"
//        val res = data?.getStringExtra(EXTRA_RESPONSE)
//        Log.d("test2 response", res!!)
        val response: AuthorizationResponse? = AuthorizationResponse.fromIntent(data)
        val ex: AuthorizationException? = AuthorizationException.fromIntent(data)
        if (ex != null) {
          currentResult?.let { handleAuthorizationException("authentication_error", ex, it) }
          return true
        }
        if (skipCodeExchange == true) {
          if (response != null) {
            val authRes = authorizationResponseToMap(response)
            currentResult?.success(authRes)
          } else {
            currentResult?.error("authorization_error", "Response map is null", null)
          }
          return true
        }
        val configuration: AppAuthConfiguration = createAppAuthConfiguration(
          createConnectionBuilder()
        )
        val authService = AuthorizationService(applicationContext!!, configuration)
        val tokenRequest: TokenRequest?
        val additionalParams = additionalParametersMap
        tokenRequest = if (additionalParams == null) {
          response?.createTokenExchangeRequest()
        } else {
          response?.createTokenExchangeRequest(additionalParams)
        }
        val tokenResponseCallback: AuthorizationService.TokenResponseCallback =
          AuthorizationService.TokenResponseCallback { resp, ex ->
            if (resp != null && response != null) {
              val map = tokenResponseToMap(resp, response)
              result?.success(map)
            } else {
              currentResult?.let {
                handleAuthorizationException("token_exchange_failed", ex, it)
              }
            }
          }

        if(tokenRequest != null) {
          authService.performTokenRequest(tokenRequest, tokenResponseCallback)
        }

      }
      return true
    } catch (e: Exception) {
      val currentResult = result
      if (currentResult != null) {
        currentResult.error("run_time_exception", e.message, null)
      } else {
        throw e
      }
      return true
    }

    return false
  }

  private fun tokenResponseToMap(
    tokenResponse: TokenResponse,
    authResponse: AuthorizationResponse?
  ): Map<String, Any?>? {
    val responseMap: MutableMap<String, Any?> = HashMap()
    responseMap["accessToken"] = tokenResponse.accessToken
    responseMap["accessTokenExpirationTime"] =
      if (tokenResponse.accessTokenExpirationTime != null) DateUtil.formatTimestamp(tokenResponse.accessTokenExpirationTime) else null
    responseMap["refreshToken"] = tokenResponse.refreshToken
    responseMap["idToken"] = tokenResponse.idToken
    responseMap["tokenType"] = tokenResponse.tokenType
    responseMap["scopes"] =
      if (tokenResponse.scope != null) Arrays.asList(tokenResponse.scope!!.split(" ")) else null
    if (authResponse != null) {
      responseMap["authorizationAdditionalParameters"] = authResponse.additionalParameters
    }
    responseMap["tokenAdditionalParameters"] = tokenResponse.additionalParameters
    return responseMap
  }

  private fun authorizationResponseToMap(authResponse: AuthorizationResponse): Map<String, Any?>? {
    val responseMap: MutableMap<String, Any?> = HashMap()
    responseMap["codeVerifier"] = authResponse.request.codeVerifier
    responseMap["nonce"] = authResponse.request.nonce
    responseMap["authorizationCode"] = authResponse.authorizationCode
    responseMap["authorizationAdditionalParameters"] = authResponse.additionalParameters
    responseMap["state"] = authResponse.state
    return responseMap
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    binding.addActivityResultListener(this)
    mainActivity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    mainActivity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    binding.addActivityResultListener(this)
    mainActivity = binding.activity
  }

  override fun onDetachedFromActivity() {
    mainActivity = null
  }
}

object DateUtil {
  fun formatTimestamp(timestamp: Long?): String? {
    val expirationDate = timestamp?.let { Date(it) }
    val formatter = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", Locale.US)
    formatter.timeZone = TimeZone.getTimeZone("UTC")
    return expirationDate?.let { formatter.format(it) }
  }
}