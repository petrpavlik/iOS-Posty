//
//  ThreadTableViewCell+Inbox.h
//  MailClient
//
//  Created by Petr Pavlik on 11/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "ThreadTableViewCell.h"

@class INThread;

@interface ThreadTableViewCell (Inbox)

- (void)setupWithThread:(INThread*)thread;

@end
