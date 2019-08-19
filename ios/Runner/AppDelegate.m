#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  [GMSServices provideAPIKey:@"AIzaSyC-0trH4QU_Uqu7-Q1Es8yev0DBYpyQHt0"];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
