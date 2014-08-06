//
//  ContactsTextStorage.h
//  MailClient
//
//  Created by Petr Pavlik on 06/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsTextStorage : NSTextStorage

@property(nonatomic, strong) UIColor* emailHighlightColor;
@property(nonatomic, strong) UIColor* emailSeparatorColor;

@end
