//
//  ContactsTextStorage.m
//  MailClient
//
//  Created by Petr Pavlik on 06/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "ContactsTextStorage.h"

@interface ContactsTextStorage ()

@property(nonatomic, strong) NSMutableAttributedString* internalAtributtedString;

@end

@implementation ContactsTextStorage

- (id)init
{
    self = [super init];
    if (self) {
        _internalAtributtedString = [NSMutableAttributedString new];
    }
    return self;
}

- (NSString *)string
{
    return _internalAtributtedString.string;
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
    return [_internalAtributtedString attributesAtIndex:location effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    [_internalAtributtedString replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters range:range
  changeInLength:(NSInteger)str.length - (NSInteger)range.length];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
    [_internalAtributtedString setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
}

- (void)processEditing
{
    [super processEditing];
    
    [self removeAttribute:NSForegroundColorAttributeName range:NSMakeRange(4, self.string.length-4)];
    
    NSString* contacts = [self.string stringByReplacingOccurrencesOfString:@"To: " withString:@""];
    
    __block NSInteger startIndex = 0;
 
    NSArray* components = [contacts componentsSeparatedByString:@","];
    [components enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        NSString* component = [(NSString*)obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSRange range = [self.string rangeOfString:component options:0 range:NSMakeRange(startIndex, self.string.length-startIndex)];
        
        [self addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        
        startIndex +=  range.length;
    }];
}

@end
