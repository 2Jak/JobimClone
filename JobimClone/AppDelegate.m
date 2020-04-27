//
//  AppDelegate.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 01/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "AppDelegate.h"
@interface AppDelegate ()
@end
@implementation AppDelegate
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[FIRAuth auth] setAPNSToken: deviceToken type:FIRAuthAPNSTokenTypeProd];
}
-(void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)notification
      fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    if ([[FIRAuth auth] canHandleNotification:notification])
    {
      completionHandler(UIBackgroundFetchResultNoData);
      return;
    }
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FIRApp configure];
    return YES;
}
@end
