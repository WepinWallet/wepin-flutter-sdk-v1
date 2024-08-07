library wepin_flutter_modal;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WepinModal {
  late String platformType = 'web';
  final String domain = Uri.base.toString();
  // InAppWebViewController? _modalWebViewController;
  ChromeSafariBrowser? _inAppBrowser;
  BuildContext? _modalContext;

  // Constructor
  WepinModal() {
    platformType = Platform.isIOS? 'ios' : 'android';
    PlatformInAppWebViewController.debugLoggingSettings.enabled = false;
  }

  Future<void> openModal(BuildContext context, String url, dynamic Function(List<dynamic>) callback) async {
    _modalContext = context; // Save the context
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          alignment: Alignment.bottomCenter,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 0,
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(url)),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                clearCache: true,
                // useHybridComposition: true, // for Android
                allowsInlineMediaPlayback: true, // for iOS
                transparentBackground: true,
                useShouldOverrideUrlLoading: true,
                javaScriptCanOpenWindowsAutomatically: true,
                safeBrowsingEnabled: true,
                isInspectable: true,
              ),
              onWebViewCreated: (controller) {
                // InAppWebViewController? _modalWebViewController;
                // _modalWebViewController = controller;
                controller.addJavaScriptHandler(
                  handlerName: 'flutterHandler',
                  callback: (args) async  {
                    String? response = await callback(args);
                    if (response != null && response.isNotEmpty) {
                      return response; // 웹뷰로 response 반환
                    }
                  },
                );
              },
              onPermissionRequest: (controller, request) async {
                return PermissionResponse(
                resources: request.resources,
                action: PermissionResponseAction.GRANT);
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                if (Platform.isAndroid) {
                  if ( navigationAction.request.url != null && navigationAction.request.url!.isValidUri) {
                    openAuthBrowser(navigationAction.request.url);
                    return NavigationActionPolicy.CANCEL;
                  }
                }
                return NavigationActionPolicy.ALLOW;
              },
              onReceivedServerTrustAuthRequest: (controller, challenge) async {
                if (challenge.protectionSpace.host.contains("localhost") ||
                    challenge.protectionSpace.host.contains("127.0.0.1") ||
                    challenge.protectionSpace.host.contains("[::1]")) {
                  // Localhost의 경우 SSL 인증서 오류 무시
                  return ServerTrustAuthResponse(
                      action: ServerTrustAuthResponseAction.PROCEED);
                }
                return null;
              },
              onCreateWindow: (controller, createWindowAction) async {
                if ( createWindowAction.request.url != null && createWindowAction.request.url!.isValidUri) {
                  openAuthBrowser(createWindowAction.request.url);
                }
                return true;
              },
            ),
          ),
        );
      },
    ).then((value) {
      /// Navigator.pop 의 return 값이 들어옵니다.
    }).whenComplete(() {
      /// 다이얼로그가 종료됐을 때 호출됩니다.
    });
  }

  // Close the modal
  Future<void> closeModal() async {
    if (_modalContext != null && _modalContext!.mounted) {
      Navigator.of(_modalContext!).pop(); // Close the dialog
      _modalContext = null;
    }
  }

  // Open an in-app browser
  Future<void> openAuthBrowser(dynamic url) async {
    final webUrl = url is String ? WebUri(url) : url;
    _inAppBrowser = ChromeSafariBrowser();
    _inAppBrowser?.open(
      url: webUrl,
      settings: ChromeSafariBrowserSettings(
        shareState: CustomTabsShareState.SHARE_STATE_OFF,
        isSingleInstance: false,
        isTrustedWebActivity: true,
        keepAliveEnabled: true,
      ),
    );
  }

  // Close the in-app browser
  Future<void> closeAuthBrowser() async {
    if(_inAppBrowser != null && _inAppBrowser!.isOpened()){
      _inAppBrowser!.close();
    }
  }

}
