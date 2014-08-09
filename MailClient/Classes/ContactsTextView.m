//
//  ContactsTextView.m
//  MailClient
//
//  Created by Petr Pavlik on 09/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "ContactsTextView.h"

@implementation ContactsTextView

- (void)addEmail:(NSString *)email {
    
    NSString* text = self.text;
    
    if (text.length == 4) { //'To: '
        text = [text stringByAppendingString:email];
    }
    else {
        text = [text stringByAppendingString:[NSString stringWithFormat:@", %@", email]];
    }
    
    self.text = text;
}

- (NSArray*)emails {
    
    NSMutableArray* emails = [NSMutableArray new];
    
    NSString* text = [self.text stringByReplacingOccurrencesOfString:@"To: " withString:@""];
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSArray* componnets = [text componentsSeparatedByString:@","];
    for (NSString* component in componnets) {
        
        NSString* trimmedComponent = [component stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [emails addObject:trimmedComponent];
    }
    
    if (emails.count) {
        return emails;
    }
    else {
        return nil;
    }
}

@end
