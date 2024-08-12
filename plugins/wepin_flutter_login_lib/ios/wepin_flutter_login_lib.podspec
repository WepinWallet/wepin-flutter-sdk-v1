#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint wepin_flutter_login_lib.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'wepin_flutter_login_lib'
  s.version          = '0.0.1'
  s.summary          = 'wepin login library for flutter'
  s.description      = <<-DESC
wepin login library for flutter
                       DESC
  s.homepage         = 'https://github.com/WepinWallet/wepin-flutter-login'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'iotrust' => 'wepin.contact@iotrust.kr' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency "AppAuth" , "~> 1.7.5"
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
