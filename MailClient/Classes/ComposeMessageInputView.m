//
//  ComposeMessageInputView.m
//  MailClient
//
//  Created by Petr Pavlik on 20/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "ComposeMessageInputView.h"

@implementation ComposeMessageInputView

- (instancetype)initWithFrame:(CGRect)frame inputViewStyle:(UIInputViewStyle)inputViewStyle {
    self = [super initWithFrame:frame inputViewStyle:inputViewStyle];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView {
    
    UIButton* attachmentButton = [UIButton buttonWithType:UIButtonTypeSystem];
    attachmentButton.translatesAutoresizingMaskIntoConstraints = NO;
    [attachmentButton setTitle:@"Attachments" forState:UIControlStateNormal];
    [self addSubview:attachmentButton];
    
    UIButton* draftsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    draftsButton.translatesAutoresizingMaskIntoConstraints = NO;
    [draftsButton setTitle:@"Drafts" forState:UIControlStateNormal];
    [self addSubview:draftsButton];
    
    NSDictionary* bindings = NSDictionaryOfVariableBindings(attachmentButton, draftsButton);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[attachmentButton]-[draftsButton]->=8-|" options:0 metrics:nil views:bindings]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[attachmentButton]|" options:0 metrics:nil views:bindings]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[draftsButton]|" options:0 metrics:nil views:bindings]];
}

@end
