//
//  ThreadTableViewCell+Inbox.m
//  MailClient
//
//  Created by Petr Pavlik on 11/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "ThreadTableViewCell+Inbox.h"
#import <Inbox.h>
#import "DateFormatter.h"

@implementation ThreadTableViewCell (Inbox)

- (void)setupWithThread:(INThread*)thread {
    
    NSString* participants = nil;
    
    NSArray* linkedEmailAddresses = [[INAPIManager shared] namespaceEmailAddresses];
    
    for (NSDictionary* participant in thread.participants) {
        
        BOOL isMe = NO;
        for (NSString* linkedEmail in linkedEmailAddresses) {
            
            if ([participant[@"email"] isEqualToString:linkedEmail]) {
                isMe = YES;
            }
        }
        
        if (isMe) {
            continue;
        }
        
        if (!participants.length) {
            participants = @"";
        }
        else {
            participants = [participants stringByAppendingString:@", "];
        }
        
        if ([participant[@"name"] length]) {
            participants = [participants stringByAppendingString:participant[@"name"]];
        }
        else {
            participants = [participants stringByAppendingString:participant[@"email"]];
        }
    }
    
    self.snippetLabel.text = thread.snippet;
    self.subjectLabel.text = thread.subject;
    self.unreadIndicatorView.hidden = ![thread hasTagWithID:INTagIDUnread];
    self.fromLabel.text = participants;
    self.dateLabel.text = [DateFormatter stringFromDate:thread.lastMessageDate];
    
    if (thread.messageIDs.count > 1) {
        self.numMessagesView.label.text = @(thread.messageIDs.count).description;
    }
    else {
        self.numMessagesView.label.text = nil;
    }
    
    [self configureWithRead:![thread hasTagWithID:INTagIDUnread] multipleMessages:thread.messageIDs.count>1 attachment:NO];
}

@end
