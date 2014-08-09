//
//  MessageHeaderView+InboxKit.h
//  MailClient
//
//  Created by Petr Pavlik on 09/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "MessageHeaderView.h"

@class INMessage;

@interface MessageHeaderView (InboxKit)

- (void)setupWithMessage:(INMessage *)message;

@end
