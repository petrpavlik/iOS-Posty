//
//  MessagesTableViewController.h
//  MailClient
//
//  Created by Petr Pavlik on 20/07/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Inbox.h>

@class MessagesTableViewController;

@protocol MessagesTableViewControllerDelegate <NSObject>

- (void)messagesTableViewControllerDidCompleteDataFetch:(MessagesTableViewController*)controller;
- (void)messagesTableViewController:(MessagesTableViewController*)controller dataFetchDidFailWithError:(NSError*)error;

@end

@interface MessagesTableViewController : UITableViewController <INModelProviderDelegate>

@property(nonatomic, strong) INMessageProvider* messageProvider;

@property(nonatomic, strong) id <MessagesTableViewControllerDelegate> delegate;

@end
