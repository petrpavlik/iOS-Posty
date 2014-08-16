//
//  QuickReplyHeaderView.m
//  MailClient
//
//  Created by Petr Pavlik on 16/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "QuickReplyHeaderView.h"

@interface QuickReplyHeaderView ()

@property(nonatomic, strong) UITextField* textField;

@end

@implementation QuickReplyHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    SkinProvider* skin = [SkinProvider sharedInstance];
    
    _textField = [[UITextField alloc] init];
    _textField.translatesAutoresizingMaskIntoConstraints = NO;
    _textField.placeholder = @"Quick reply...";
    _textField.returnKeyType = UIReturnKeySend;
    [self addSubview:_textField];
    
    UIView* separatorView = [UIView new];
    separatorView.translatesAutoresizingMaskIntoConstraints = NO;
    separatorView.backgroundColor = skin.cellSeparatorColor;
    [self addSubview:separatorView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_textField]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textField)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[separatorView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textField, separatorView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_textField][separatorView(0.5)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textField, separatorView)]];
}

- (BOOL)resignFirstResponder {
    return [self.textField resignFirstResponder];
}

@end
