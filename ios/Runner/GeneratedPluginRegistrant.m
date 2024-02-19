//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<amplify_auth_cognito/AmplifyAuthCognitoPlugin.h>)
#import <amplify_auth_cognito/AmplifyAuthCognitoPlugin.h>
#else
@import amplify_auth_cognito;
#endif

#if __has_include(<amplify_datastore/AmplifyDataStorePlugin.h>)
#import <amplify_datastore/AmplifyDataStorePlugin.h>
#else
@import amplify_datastore;
#endif

#if __has_include(<amplify_secure_storage/AmplifySecureStoragePlugin.h>)
#import <amplify_secure_storage/AmplifySecureStoragePlugin.h>
#else
@import amplify_secure_storage;
#endif

#if __has_include(<connectivity_plus/ConnectivityPlusPlugin.h>)
#import <connectivity_plus/ConnectivityPlusPlugin.h>
#else
@import connectivity_plus;
#endif

#if __has_include(<device_info_plus/FPPDeviceInfoPlusPlugin.h>)
#import <device_info_plus/FPPDeviceInfoPlusPlugin.h>
#else
@import device_info_plus;
#endif

#if __has_include(<package_info_plus/FPPPackageInfoPlusPlugin.h>)
#import <package_info_plus/FPPPackageInfoPlusPlugin.h>
#else
@import package_info_plus;
#endif

#if __has_include(<path_provider_foundation/PathProviderPlugin.h>)
#import <path_provider_foundation/PathProviderPlugin.h>
#else
@import path_provider_foundation;
#endif

#if __has_include(<url_launcher_ios/URLLauncherPlugin.h>)
#import <url_launcher_ios/URLLauncherPlugin.h>
#else
@import url_launcher_ios;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [AmplifyAuthCognitoPlugin registerWithRegistrar:[registry registrarForPlugin:@"AmplifyAuthCognitoPlugin"]];
  [AmplifyDataStorePlugin registerWithRegistrar:[registry registrarForPlugin:@"AmplifyDataStorePlugin"]];
  [AmplifySecureStoragePlugin registerWithRegistrar:[registry registrarForPlugin:@"AmplifySecureStoragePlugin"]];
  [ConnectivityPlusPlugin registerWithRegistrar:[registry registrarForPlugin:@"ConnectivityPlusPlugin"]];
  [FPPDeviceInfoPlusPlugin registerWithRegistrar:[registry registrarForPlugin:@"FPPDeviceInfoPlusPlugin"]];
  [FPPPackageInfoPlusPlugin registerWithRegistrar:[registry registrarForPlugin:@"FPPPackageInfoPlusPlugin"]];
  [PathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"PathProviderPlugin"]];
  [URLLauncherPlugin registerWithRegistrar:[registry registrarForPlugin:@"URLLauncherPlugin"]];
}

@end
