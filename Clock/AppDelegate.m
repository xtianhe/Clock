//
//  AppDelegate.m
//  Clock
//
//  Created by mehome-Tim on 2018/8/30.
//  Copyright © 2018 MH. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self registerUserNotification];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kwillEnterBackgroudNotify object:nil];

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[NSNotificationCenter defaultCenter] postNotificationName:kwillEnterFrontgroudNotify object:nil];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)registerUserNotification
{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    //UILocalNotification * notification=[[UILocalNotification alloc] init];
    

    [center requestAuthorizationWithOptions:UNAuthorizationOptionSound |
     UNAuthorizationOptionAlert  completionHandler:^(BOOL granted, NSError * _Nullable error) {
          NSLog(@"Authorization completionHandler");
         if (error) {
             NSLog(@"%@",error);
         }
     }];
    
    
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        NSLog(@"settings %@",settings);
    }];
    
      UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"beginRest" title:@"开始休息" options:UNNotificationActionOptionForeground];
    
    
    UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"beginLearn" title:@"开始学习" options:UNNotificationActionOptionDestructive];
    
 
    
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"rest_category" actions:@[action2] intentIdentifiers:@[] options:@[]];

     UNNotificationCategory *category2 = [UNNotificationCategory categoryWithIdentifier:@"learn_category" actions:@[action1] intentIdentifiers:@[] options:@[]];
    
    
      [center setNotificationCategories:[NSSet setWithArray:@[category,category2]]];
  //  [[UIApplication sharedApplication] registerForRemoteNotifications];

    
    
 

    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    
   // completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
    
    NSLog(@"willPresentNotification");
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    NSString *categoryIdentify = response.notification.request.content.categoryIdentifier;
    NSLog(@"didReceiveNotificationResponse :%@",categoryIdentify);
    
NSString *actionIdef = response.actionIdentifier;
       NSLog(@"didReceive actionIdef :%@",actionIdef);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kwillPushActoinNotify object:actionIdef];

    
//    if ([categoryIdentify isEqualToString:@"closeCategory"]) {
//
//        if ([response.actionIdentifier isEqualToString:@"closeAlarmIdentify"]) {
//            //操作Identify
//            self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
//        }
//    }
    completionHandler();
}





@end
