//
//  AppDelegate.m
//  MailClient
//
//  Created by Petr Pavlik on 19/07/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <Inbox.h>
#import <Heap.h>
#import <Crashlytics/Crashlytics.h>

#import "ThreadsTableViewController.h"
#import "NSTimer+Block.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
            
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* mailSignature = [userDefaults stringForKey:MailSignatureKey];
    
    if (!mailSignature) {
        
        mailSignature = @"<br/><br/>Sent with <a href=\"http://postyapp.com\">Posty for iOS</a>";
        [userDefaults setObject:mailSignature forKey:MailSignatureKey];
        [userDefaults setBool:YES forKey:MailSignatureIsHTMLKey];
        [userDefaults synchronize];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [Crashlytics startWithAPIKey:@"c8411cf93fbcb20e8dd6336cd727e16241dd5c68"];
    
    NSLocale* currentLocale = [NSLocale currentLocale];
    NSString* localeIdentifier = [currentLocale objectForKey:NSLocaleIdentifier];
    NSString* languageCode = [currentLocale objectForKey:NSLocaleLanguageCode];
    NSCalendar* calendar = [currentLocale objectForKey:NSLocaleCalendar];
    NSString* measurementSystem = [currentLocale objectForKey:NSLocaleMeasurementSystem];
    
    [Crashlytics setObjectValue:localeIdentifier forKey:@"Locale Identifier"];
    [Crashlytics setObjectValue:languageCode forKey:@"Language Code"];
    [Crashlytics setObjectValue:calendar.calendarIdentifier forKey:@"Calendar"];
    [Crashlytics setObjectValue:measurementSystem forKey:@"Measurement System"];
    
    [Heap setAppId:@"2401352668"];
    
    [Parse setApplicationId:@"QHYdEt23QGRfBQyB8OkegApK6nzoPdYklL02DhVz"
                  clientKey:@"6q0VjcUCBsDn7zrQY6pzy1mu9kGePIgQuXAszrym"];
    
    
    UIUserNotificationType types = UIUserNotificationTypeSound | UIUserNotificationTypeBadge | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [application registerUserNotificationSettings:notificationSettings];
    
    self.launchNotificationUserInfo = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[INAPIManager shared] handleURL: url];
}

#pragma mark -

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (error) {
    
            [[[UIAlertView alloc] initWithTitle:nil message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    [[[UIAlertView alloc] initWithTitle:nil message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    //if (application.applicationState != UIApplicationStateActive) {
        
        NSString* messageId = userInfo[@"messageId"];
        
        if (!messageId.length) {
            
            [[[UIAlertView alloc] initWithTitle:nil message:@"Unexpected format of push notification" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            
            return;
        }
        
    [[NSNotificationCenter defaultCenter] postNotificationName:DidReceiveMailNotification object:nil userInfo:@{MessageIdKey: messageId}];
    //}
}

#pragma mark - background fetch

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"should perform fetch");
    
    if (self.threadsControllerForBackgroundFetching) {
        
        __weak NSTimer* fetchWindowTimeoutTimer = [NSTimer scheduledTimerWithTimeInterval:20 block:^(NSTimer *timer) {
            
            completionHandler(UIBackgroundFetchResultFailed);
            
        } userInfo:nil repeats:NO];
        
        ThreadsTableViewController* threadsController = self.threadsControllerForBackgroundFetching;
        [threadsController fetchNewThreadsWithCompletionHandler:^(UIBackgroundFetchResult fetchResult) {
            
            [fetchWindowTimeoutTimer invalidate];
            completionHandler(fetchResult);
        }];
    }
    else {
        completionHandler(UIBackgroundFetchResultNoData);
    }
}

@end
