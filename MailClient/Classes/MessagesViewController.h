//
//  MessagesViewController.h
//  MailClient
//
//  Created by Petr Pavlik on 17/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import <UIKit/UIKit.h>

@class INThread;

@interface MessagesViewController : UIViewController

@property(nonatomic, strong) INThread* thread;
@property(nonatomic, strong) NSString* namespaceId;

@end
