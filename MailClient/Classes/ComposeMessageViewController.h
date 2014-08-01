//
//  ComposeMessageViewController.h
//  MailClient
//
//  Created by Petr Pavlik on 22/07/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  INMessage;

@interface ComposeMessageViewController : UIViewController

@property(nonatomic, strong) INMessage* messageToReplyTo;

@end
