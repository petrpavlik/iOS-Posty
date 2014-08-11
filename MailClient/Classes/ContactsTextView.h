//
//  ContactsTextView.h
//  MailClient
//
//  Created by Petr Pavlik on 09/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsTextView : UITextView

@property(nonatomic, strong) NSString* prefix;

@property(nonatomic, readonly) NSArray* emails;

- (void)addEmail:(NSString*)email;

@end
