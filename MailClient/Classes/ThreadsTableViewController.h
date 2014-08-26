//
//  ThreadsTableViewController.h
//  MailClient
//
//  Created by Petr Pavlik on 19/07/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreadsTableViewController : UITableViewController

- (void)fetchNewThreadsWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

@end
