//
//  AppDelegate.h
//  MailClient
//
//  Created by Petr Pavlik on 19/07/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ThreadsTableViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, strong) NSDictionary* launchNotificationUserInfo;

@property(nonatomic, weak) ThreadsTableViewController* threadsControllerForBackgroundFetching;

@end

