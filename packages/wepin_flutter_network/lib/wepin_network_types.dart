// LoginRequest 클래스
import 'package:wepin_flutter_common/wepin_common_type.dart';

class LoginRequest {
  final String idToken;

  LoginRequest({required this.idToken});

  Map<String, dynamic> toJson() => {'idToken': idToken};
}

// LoginResponse 클래스
class LoginResponse {
  final String loginStatus;
  final bool? pinRequired;
  final String? walletId;
  final WepinToken token;
  final WepinAppUser userInfo;

  LoginResponse({
    required this.loginStatus,
    this.pinRequired,
    this.walletId,
    required this.token,
    required this.userInfo,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    // 토큰 필드 매핑을 위한 헬퍼 함수
    String? getTokenField(Map<String, dynamic> json, String primary, String fallback) {
      return json[primary] ?? json[fallback];
    }

    return LoginResponse(
      loginStatus: json['loginStatus'],
      pinRequired: json['pinRequired'],
      walletId: json['walletId'],
      token: WepinToken.fromJson({
        'accessToken': getTokenField(json['token'], 'accessToken', 'access'),
        'refreshToken': getTokenField(json['token'], 'refreshToken', 'refresh'),
      }),
      userInfo: WepinAppUser.fromJson(json['userInfo']),
    );
  }

  Map<String, dynamic> toJson() => {
    'loginStatus': loginStatus,
    'pinRequired': pinRequired,
    'walletId': walletId,
    'token': token.toJson(),
    'userInfo': userInfo.toJson(),
  };
}


// WepinAppUser 클래스
class WepinAppUser {
  final String userId;
  final String email;
  final String name;
  final String locale;
  final String currency;
  final String lastAccessDevice;
  final String lastSessionIP;
  final int userJoinStage;
  final String profileImage;
  final int userState;
  final int use2FA;

  WepinAppUser({
    required this.userId,
    required this.email,
    required this.name,
    required this.locale,
    required this.currency,
    required this.lastAccessDevice,
    required this.lastSessionIP,
    required this.userJoinStage,
    required this.profileImage,
    required this.userState,
    required this.use2FA,
  });

  factory WepinAppUser.fromJson(Map<String, dynamic> json) {
    return WepinAppUser(
      userId: json['userId'],
      email: json['email'],
      name: json['name'],
      locale: json['locale'],
      currency: json['currency'],
      lastAccessDevice: json['lastAccessDevice'],
      lastSessionIP: json['lastSessionIP'],
      userJoinStage: json['userJoinStage'],
      profileImage: json['profileImage'],
      userState: json['userState'],
      use2FA: json['use2FA'],
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'email': email,
    'name': name,
    'locale': locale,
    'currency': currency,
    'lastAccessDevice': lastAccessDevice,
    'lastSessionIP': lastSessionIP,
    'userJoinStage': userJoinStage,
    'profileImage': profileImage,
    'userState': userState,
    'use2FA': use2FA,
  };
}

// GetAccessTokenResponse 클래스
class GetAccessTokenResponse {
  final String token;

  GetAccessTokenResponse({required this.token});

  factory GetAccessTokenResponse.fromJson(Map<String, dynamic> json) {
    return GetAccessTokenResponse(token: json['token']);
  }

  Map<String, dynamic> toJson() => {'token': token};
}

// only for without pin
class RegisterRequest {
  final String appId;
  final String userId;
  final String loginStatus;
  final String walletId;

  RegisterRequest({
    required this.appId,
    required this.userId,
    required this.loginStatus,
    required this.walletId,
  });

  Map<String, dynamic> toJson() => {
    'appId': appId,
    'userId': userId,
    'loginStatus': loginStatus,
    'walletId': walletId,
  };
}

class RegisterResponse {
  final bool success;
  final String walletId;

  RegisterResponse({required this.success, required this.walletId});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['success'],
      walletId: json['walletId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'walletId': walletId,
  };
}

class ITermsAccepted {
  final bool termsOfService;
  final bool privacyPolicy;

  ITermsAccepted({required this.termsOfService, required this.privacyPolicy});

  factory ITermsAccepted.fromJson(Map<String, dynamic> json) {
    return ITermsAccepted(
      termsOfService: json['termsOfService'],
      privacyPolicy: json['privacyPolicy'],
    );
  }

  Map<String, dynamic> toJson() => {
    'termsOfService': termsOfService,
    'privacyPolicy': privacyPolicy,
  };
}

class UpdateTermsAcceptedRequest {
  final ITermsAccepted termsAccepted;

  UpdateTermsAcceptedRequest({required this.termsAccepted});

  Map<String, dynamic> toJson() => {
    'termsAccepted': termsAccepted.toJson(),
  };
}

class UpdateTermsAcceptedResponse extends UpdateTermsAcceptedRequest {
  UpdateTermsAcceptedResponse({required ITermsAccepted termsAccepted})
      : super(termsAccepted: termsAccepted);

  factory UpdateTermsAcceptedResponse.fromJson(Map<String, dynamic> json) {
    return UpdateTermsAcceptedResponse(
      termsAccepted: ITermsAccepted.fromJson(json['termsAccepted']),
    );
  }
}

class GetAccountListRequest {
  final String walletId;
  final String userId;
  final String localeId;

  GetAccountListRequest({
    required this.walletId,
    required this.userId,
    required this.localeId,
  });

  Map<String, dynamic> toJson() => {
    'walletId': walletId,
    'userId': userId,
    'localeId': localeId,
  };
}

class IAppAccount {
  final String accountId;
  final String address;
  final String? eoaAddress;
  final String addressPath;
  final int? coinId;
  final String? contract;
  final String symbol;
  final String label;
  final String name;
  final String network;
  final String balance;
  final int decimals;
  final String iconUrl;
  final String? ids;
  final String? accountTokenId;
  final int? cmkId;
  final bool? isAA;

  IAppAccount({
    required this.accountId,
    required this.address,
    this.eoaAddress,
    required this.addressPath,
    this.coinId,
    this.contract,
    required this.symbol,
    required this.label,
    required this.name,
    required this.network,
    required this.balance,
    required this.decimals,
    required this.iconUrl,
    this.ids,
    this.accountTokenId,
    this.cmkId,
    this.isAA
  });

  factory IAppAccount.fromJson(Map<String, dynamic> json) {
    return IAppAccount(
      accountId: json['accountId'],
      address: json['address'],
      eoaAddress: json['eoaAddress'],
      addressPath: json['addressPath'],
      coinId: json['coinId'],
      contract: json['contract'],
      symbol: json['symbol'],
      label: json['label'],
      name: json['name'],
      network: json['network'],
      balance: json['balance'],
      decimals: json['decimals'],
      iconUrl: json['iconUrl'],
      ids: json['ids'],
      accountTokenId: json['accountTokenId'],
      cmkId: json['cmkId'],
      isAA: json['isAA'],
    );
  }

  Map<String, dynamic> toJson() => {
    'accountId': accountId,
    'address': address,
    'eoaAddress': eoaAddress,
    'addressPath': addressPath,
    'coinId': coinId,
    'contract': contract,
    'symbol': symbol,
    'label': label,
    'name': name,
    'network': network,
    'balance': balance,
    'decimals': decimals,
    'iconUrl': iconUrl,
    'ids': ids,
    'accountTokenId': accountTokenId,
    'cmkId': cmkId,
    'isAA': isAA,
  };
}

class IAppNFT {
  final NFTContract contract;
  final String id;
  final String accountId;
  final String name;
  final String description;
  final String tokenId;
  final String externalLink;
  final String imageUrl;
  final String? contentUrl;
  final int? quantity;
  final int contentType;
  final int state;

  IAppNFT({
    required this.contract,
    required this.id,
    required this.accountId,
    required this.name,
    required this.description,
    required this.tokenId,
    required this.externalLink,
    required this.imageUrl,
    this.contentUrl,
    this.quantity,
    required this.contentType,
    required this.state,
  });

  static const Map<int, String> contentTypeMapping = {
    1: 'image',
    2: 'video',
  };

  factory IAppNFT.fromJson(Map<String, dynamic> json) {
    return IAppNFT(
      contract: NFTContract.fromJson(json['contract']),
      id: json['id'],
      accountId: json['accountId'],
      name: json['name'],
      description: json['description'],
      tokenId: json['tokenId'],
      externalLink: json['externalLink'],
      imageUrl: json['imageUrl'],
      contentUrl: json['contentUrl'],
      quantity: json['quantity'],
      contentType: json['contentType'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contract': contract.toJson(),
      'id': id,
      'accountId': accountId,
      'name': name,
      'description': description,
      'tokenId': tokenId,
      'externalLink': externalLink,
      'imageUrl': imageUrl,
      'contentUrl': contentUrl,
      'quantity': quantity,
      'contentType': contentType,
      'state': state,
    };
  }

  @override
  String toString() {
    return 'IAppNFT(contract: $contract, id: $id, accountId: $accountId, name: $name, description: $description, tokenId: $tokenId, externalLink: $externalLink, imageUrl: $imageUrl, contentUrl: $contentUrl, quantity: $quantity, contentType: $contentType, state: $state)';
  }
}

class NFTContract {
  final int coinId;
  final String name;
  final String address;
  final int scheme;
  final String? description;
  final String network;
  final String? externalLink;
  final String? imageUrl;

  NFTContract({
    required this.coinId,
    required this.name,
    required this.address,
    required this.scheme,
    this.description,
    required this.network,
    this.externalLink,
    this.imageUrl,
  });

  static const Map<int, String> schemeMapping = {
    1: 'ERC721',
    2: 'ERC1155',
    3: 'SBT',
    4: 'DNFT',
    5: 'SOLANA_SFA',
    6: 'KIP37',
    7: 'KIP17',
  };

  factory NFTContract.fromJson(Map<String, dynamic> json) {
    return NFTContract(
      coinId: json['coinId'],
      name: json['name'],
      address: json['address'],
      scheme: json['scheme'],
      description: json['description'],
      network: json['network'],
      externalLink: json['externalLink'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coinId': coinId,
      'name': name,
      'address': address,
      'scheme': scheme,
      'description': description,
      'network': network,
      'externalLink': externalLink,
      'imageUrl': imageUrl,
    };
  }

  @override
  String toString() {
    return 'NFTContract(coinId: $coinId, name: $name, address: $address, scheme: $scheme, description: $description, network: $network, externalLink: $externalLink, imageUrl: $imageUrl)';
  }
}

class GetNFTListRequest {
  final String walletId;
  final String userId;
  GetNFTListRequest({required this.walletId, required this.userId});
  Map<String, dynamic> toJson() => {
    'walletId': walletId,
    'userId': userId
  };
}

class GetNFTListResponse {
  final List<IAppNFT> nfts;

  GetNFTListResponse({
    required this.nfts,
  });

  factory GetNFTListResponse.fromJson(Map<String, dynamic> json) {
    return GetNFTListResponse(
      nfts: (json['nfts'] as List)
          .map((item) => IAppNFT.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'nfts': nfts.map((nft) => nft.toJson()).toList(),
  };
}

class GetAccountListResponse {
  final String walletId;
  final List<IAppAccount> accounts;
  final List<IAppAccount>? aa_accounts;

  GetAccountListResponse({
    required this.walletId,
    required this.accounts,
    this.aa_accounts,
  });

  factory GetAccountListResponse.fromJson(Map<String, dynamic> json) {
    return GetAccountListResponse(
      walletId: json['walletId'],
      accounts: (json['accounts'] as List)
          .map((item) => IAppAccount.fromJson(item))
          .toList(),
      aa_accounts: json['aa_accounts'] != null
          ? (json['aa_accounts'] as List)
          .map((item) => IAppAccount.fromJson(item))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'walletId': walletId,
    'accounts': accounts.map((account) => account.toJson()).toList(),
    'aa_accounts': aa_accounts?.map((account) => account.toJson()).toList(),
  };
}

class ITokenBalance {
  final String contract;
  final String? name;
  final int decimals;
  final String symbol;
  final int tokenId;
  final String balance;

  ITokenBalance({required this.contract, this.name, required this.decimals, required this.symbol, required this.balance, required this.tokenId});

  factory ITokenBalance.fromJson(Map<String, dynamic> json) {
    return ITokenBalance(
      contract: json['contract'],
      name: json['name'],
      decimals: json['decimals'],
      symbol: json['symbol'],
      tokenId: json['tokenId'],
      balance: json['balance']
    );
  }

  Map<String, dynamic> toJson() => {
    'contract': contract,
    'name': name,
    'decimals': decimals,
    'symbol': symbol,
    'tokenId': tokenId,
    'balance': balance,
  };
}

class GetAccountBalanceResponse {
  final int decimals;
  final String symbol;
  final List<ITokenBalance> tokens;
  final String balance;

  GetAccountBalanceResponse({required this.decimals, required this.symbol, required this.tokens, required this.balance});

  factory GetAccountBalanceResponse.fromJson(Map<String, dynamic> json) {
    return GetAccountBalanceResponse(
      decimals: json['decimals'],
      symbol: json['symbol'],
      tokens: (json['tokens'] as List)
          .map((item) => ITokenBalance.fromJson(item))
          .toList(),
      balance: json['balance']
    );
  }

  Map<String, dynamic> toJson() => {
    'decimals': decimals,
    'symbol': symbol,
    'tokens': tokens.map((token) => token.toJson()).toList(),
    'balance': balance,
  };
}

// OAuthTokenRequest 클래스
class OAuthTokenRequest {
  final String code;
  final String clientId;
  final String redirectUri;
  final String? state;
  final String? codeVerifier;

  OAuthTokenRequest({
    required this.code,
    required this.clientId,
    required this.redirectUri,
    this.state,
    this.codeVerifier,
  });

  Map<String, dynamic> toJson() => {
    'code': code,
    'clientId': clientId,
    'redirectUri': redirectUri,
    'state': state,
    'codeVerifier': codeVerifier,
  };
}

// OAuthTokenResponse 클래스
class OAuthTokenResponse {
  final String? idToken;
  final String accessToken;
  final String tokenType;
  final dynamic expiresIn;
  final String? refreshToken;
  final String? scope;

  OAuthTokenResponse({
    this.idToken,
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    this.refreshToken,
    this.scope,
  });

  factory OAuthTokenResponse.fromJson(Map<String, dynamic> json) {
    return OAuthTokenResponse(
      idToken: json['id_token'],
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
      refreshToken: json['refresh_token'],
      scope: json['scope'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id_token': idToken,
    'access_token': accessToken,
    'token_type': tokenType,
    'expires_in': expiresIn,
    'refresh_token': refreshToken,
    'scope': scope,
  };
}

// VerifyRequest 클래스
class VerifyRequest {
  final String type;
  final String email;
  final int? localeId;

  VerifyRequest({required this.type, required this.email, this.localeId});

  Map<String, dynamic> toJson() => {
    'type': type,
    'email': email,
    'localeId': localeId,
  };
}

// VerifyResponse 클래스
class VerifyResponse {
  final bool result;
  final String? oobReset;
  final String? oobVerify;

  VerifyResponse({required this.result, this.oobReset, this.oobVerify});

  factory VerifyResponse.fromJson(Map<String, dynamic> json) {
    return VerifyResponse(
      result: json['result'],
      oobReset: json['oobReset'],
      oobVerify: json['oobVerify'],
    );
  }

  Map<String, dynamic> toJson() => {
    'result': result,
    'oobReset': oobReset,
    'oobVerify': oobVerify,
  };
}

// PasswordStateResponse 클래스
class PasswordStateResponse {
  final bool isPasswordResetRequired;

  PasswordStateResponse({required this.isPasswordResetRequired});

  factory PasswordStateResponse.fromJson(Map<String, dynamic> json) {
    return PasswordStateResponse(
      isPasswordResetRequired: json['isPasswordResetRequired'],
    );
  }

  Map<String, dynamic> toJson() => {
    'isPasswordResetRequired': isPasswordResetRequired,
  };
}

// PasswordStateRequest 클래스
class PasswordStateRequest {
  final bool isPasswordResetRequired;

  PasswordStateRequest({required this.isPasswordResetRequired});

  Map<String, dynamic> toJson() => {
    'isPasswordResetRequired': isPasswordResetRequired,
  };
}

// CheckEmailExistResponse 클래스
class CheckEmailExistResponse {
  final bool isEmailExist;
  final bool isEmailVerified;
  final List<String> providerIds;

  CheckEmailExistResponse({
    required this.isEmailExist,
    required this.isEmailVerified,
    required this.providerIds,
  });

  factory CheckEmailExistResponse.fromJson(Map<String, dynamic> json) {
    return CheckEmailExistResponse(
      isEmailExist: json['isEmailExist'],
      isEmailVerified: json['isEmailverified'],
      providerIds: List<String>.from(json['providerIds']),
    );
  }

  Map<String, dynamic> toJson() => {
    'isEmailExist': isEmailExist,
    'isEmailVerified': isEmailVerified,
    'providerIds': providerIds,
  };
}

// LoginOauthAccessTokenRequest 클래스
class LoginOauthAccessTokenRequest {
  final String provider;
  final String accessToken;
  final String sign;

  LoginOauthAccessTokenRequest({
    required this.provider,
    required this.accessToken,
    required this.sign,
  });

  Map<String, dynamic> toJson() => {
    'provider': provider,
    'accessToken': accessToken,
    'sign': sign,
  };
}

// LoginOauthIdTokenRequest 클래스
class LoginOauthIdTokenRequest {
  final String idToken;
  final String sign;

  LoginOauthIdTokenRequest({required this.idToken, required this.sign});

  Map<String, dynamic> toJson() => {
    'idToken': idToken,
    'sign': sign,
  };
}

// LoginOauthIdTokenResponse 클래스
class LoginOauthIdTokenResponse {
  final bool result;
  final String? token;
  final String? error;

  LoginOauthIdTokenResponse({required this.result, this.token, this.error});

  factory LoginOauthIdTokenResponse.fromJson(Map<String, dynamic> json) {
    return LoginOauthIdTokenResponse(
      result: json['result'],
      token: json['token'],
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() => {
    'result': result,
    'token': token,
    'error': error,
  };
}

// WepinLoginWithEmailParams 클래스
class LoginWithEmailParams {
  final String email;
  final String password;
  final String locale;

  LoginWithEmailParams({
    required this.email,
    required this.password,
    this.locale = 'en',
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'locale': locale,
  };
}

