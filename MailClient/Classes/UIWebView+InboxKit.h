//
//  UIWebView+InboxKit.h
//  MailClient
//
//  Created by Petr Pavlik on 09/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import <UIKit/UIKit.h>

@class INMessage;

@interface UIWebView (InboxKit)

- (void)setupWithMessage:(INMessage*)message;

@end
