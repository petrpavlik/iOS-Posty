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
    NSParameterAssert(self.prefix.length);
    
    [super processEditing];
    
    NSString* string = self.string;
    
    SkinProvider* skin = [SkinProvider sharedInstance];
    
    [self removeAttribute:NSForegroundColorAttributeName range:NSMakeRange(0, string.length)];
    [self addAttribute:NSForegroundColorAttributeName value:skin.textColor range:NSMakeRange(0, string.length)];
    
    NSString* contacts = [string stringByReplacingOccurrencesOfString:self.prefix withString:@""];
 
    NSArray* components = [contacts componentsSeparatedByString:@","];
    [components enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString* component = [(NSString*)obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        //NSLog(@"enumerated '%@'", component);
        
        if (!component.length) {
            return;
        }
        
        NSRange range = [string rangeOfString:component options:0];
        
        [self addAttribute:NSForegroundColorAttributeName value:skin.tintColor range:range];
    }];
}

@end
