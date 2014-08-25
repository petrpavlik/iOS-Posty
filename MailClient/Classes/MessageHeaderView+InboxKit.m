//
//  MessageHeaderView+InboxKit.m
//  MailClient
//
//  Created by Petr Pavlik on 09/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "MessageHeaderView+InboxKit.h"
#import <Inbox.h>
#import "DateFormatter.h"

@implementation MessageHeaderView (InboxKit)

- (void)setupWithMessage:(INMessage *)message {
    
    if (message.subject.length) {
        self.subjectLabel.text = message.subject;
    }
    else {
        self.subjectLabel.text = @"No subject";
    }
    
    
    
    NSString* from = @"From: ";
    for (NSDictionary* fromDictionary in message.from) {
        
        if ([fromDictionary[@"name"] length]) {
            from = [from stringByAppendingString:fromDictionary[@"name"]];
        }
        else {
            from = [from stringByAppendingString:fromDictionary[@"email"]];
        }
    }
    self.fromLabel.text = from;
    
    for (NSDictionary* fromDictionary in message.from) {
        
        NSString* urlString = [NSString stringWithFormat:@"mailto:%@", fromDictionary[@"email"]];
        NSURL* url = [NSURL URLWithString:urlString];
        
        if ([fromDictionary[@"name"] length]) {
            [self.fromLabel addLinkToURL:url withRange:[self.fromLabel.text rangeOfString:fromDictionary[@"name"]]];
        }
        else {
            [self.fromLabel addLinkToURL:url withRange:[self.fromLabel.text rangeOfString:fromDictionary[@"email"]]];
        }
    }
    
    NSString* to = @"To: ";
    for (NSDictionary* toDictionary in message.to) {
        
        if ([toDictionary[@"name"] length]) {
            to = [to stringByAppendingString:toDictionary[@"name"]];
        }
        else {
            to = [to stringByAppendingString:toDictionary[@"email"]];
        }
    }
    self.toLabel.text = to;
    
    for (NSDictionary* toDictionary in message.to) {
        
        NSString* urlString = [NSString stringWithFormat:@"mailto:%@", toDictionary[@"email"]];
        NSURL* url = [NSURL URLWithString:urlString];
        
        if ([toDictionary[@"name"] length]) {
            [self.toLabel addLinkToURL:url withRange:[self.toLabel.text rangeOfString:toDictionary[@"name"]]];
        }
        else {
            [self.toLabel addLinkToURL:url withRange:[self.toLabel.text rangeOfString:toDictionary[@"email"]]];
        }
    }
    
    if (message.cc.count) {
        
        NSString* cc = @"Cc: ";
        for (NSDictionary* ccDictionary in message.cc) {
            
            if ([ccDictionary[@"name"] length]) {
                cc = [cc stringByAppendingString:ccDictionary[@"name"]];
            }
            else {
                cc = [cc stringByAppendingString:ccDictionary[@"email"]];
            }
        }
        self.ccLabel.text = cc;
        
        for (NSDictionary* ccDictionary in message.to) {
            
            NSString* urlString = [NSString stringWithFormat:@"mailto:%@", ccDictionary[@"email"]];
            NSURL* url = [NSURL URLWithString:urlString];
            
            if ([ccDictionary[@"name"] length]) {
                [self.ccLabel addLinkToURL:url withRange:[self.ccLabel.text rangeOfString:ccDictionary[@"name"]]];
            }
            else {
                [self.ccLabel addLinkToURL:url withRange:[self.ccLabel.text rangeOfString:ccDictionary[@"email"]]];
            }
        }
        
        for (NSDictionary* ccDictionary in message.cc) {
            
            NSString* urlString = [NSString stringWithFormat:@"mailto:%@", ccDictionary[@"email"]];
            NSURL* url = [NSURL URLWithString:urlString];
            
            if ([ccDictionary[@"name"] length]) {
                [self.ccLabel addLinkToURL:url withRange:[self.ccLabel.text rangeOfString:ccDictionary[@"name"]]];
            }
            else {
                [self.ccLabel addLinkToURL:url withRange:[self.ccLabel.text rangeOfString:ccDictionary[@"email"]]];
            }
        }

    }
    else {
        self.ccLabel.text = @"";
    }
    
    self.dateLabel.text = [DateFormatter stringFromDate:message.date];
}

@end
