//
//  ContactsTextView.m
//  MailClient
//
//  Created by Petr Pavlik on 09/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "ContactsTextView.h"
#import "ContactsTextStorage.h"

@implementation ContactsTextView

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        
        [self addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:nil];
    }
    
    return self;
}

- (void)dealloc {
    
    [self removeObserver:self forKeyPath:@"contentSize" context:nil];
}

- (void)addEmail:(NSString *)email {
    
    NSParameterAssert(self.prefix.length);
    
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
    
    NSParameterAssert(self.prefix.length);
    
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

- (void)setPrefix:(NSString *)prefix {
    
    _prefix = prefix;
    
    ContactsTextStorage* textStorate = (ContactsTextStorage*)self.textStorage;
    textStorate.prefix = prefix;
    
    self.text = prefix;
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    UITextView *tv = object;
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}

@end
