//
//  MessagesTableViewController.h
//  MailClient
//
//  Created by Petr Pavlik on 20/07/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import <UIKit/UIKit.h>

@class INThread;

@interface MessagesTableViewController : UITableViewController

@property(nonatomic, strong) INThread* thread;
@property(nonatomic, strong) NSString* namespaceId;

@end
