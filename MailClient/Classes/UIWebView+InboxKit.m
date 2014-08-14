//
//  UIWebView+InboxKit.m
//  MailClient
//
//  Created by Petr Pavlik on 09/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "UIWebView+InboxKit.h"
#import <Inbox.h>

@implementation UIWebView (InboxKit)

- (void)setupWithMessage:(INMessage *)message {
    
    if ([message.body containsString:@"<head"]) {
        
        //TODO: add default formating right after <head>
        NSString* css = @"<style> body { color: #677277; font-size: 17px; font-family: \"Helvetica Neue\"; } a { color: #007AFF; text-decoration: none; } </style>";
        
        NSRange range = [message.body rangeOfString:@"<head>"];
        NSString* body = [message.body stringByReplacingCharactersInRange:NSMakeRange(range.location+range.length, 0) withString:css];
        
        [self loadHTMLString:body baseURL:nil];
    }
    else {
        
        NSString* templatePath = [[NSBundle mainBundle] pathForResource:@"SimpleMailTemplate" ofType:@"html"];
        NSString* content = [[NSString alloc] initWithData:[[NSFileManager defaultManager] contentsAtPath:templatePath] encoding:NSUTF8StringEncoding];
        
        content = [content stringByReplacingOccurrencesOfString:@"%@" withString:message.body];
        
        [self loadHTMLString:content baseURL:nil];
    }
    
    
}

@end
