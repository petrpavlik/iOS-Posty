//
//  MailViewController.h
//  MailClient
//
//  Created by Petr Pavlik on 20/07/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import <UIKit/UIKit.h>

@class INMessage;

@interface MessageViewController : UIViewController

@property(nonatomic, strong) INMessage* message;
@property(nonatomic, strong) NSString* messageId;

@end
