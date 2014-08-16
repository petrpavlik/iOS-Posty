//
//  MailSummaryView.m
//  MailClient
//
//  Created by Petr Pavlik on 16/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "MailSummaryView.h"

@interface MailSummaryView ()

@property(nonatomic, strong) UIButton* spamButton;

@end

@implementation MailSummaryView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    SkinProvider* skin = [SkinProvider sharedInstance];
    
    _spamButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _spamButton.translatesAutoresizingMaskIntoConstraints = NO;
    _spamButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    _spamButton.enabled = NO;
    [_spamButton setTitle:@"No spam today" forState:UIControlStateNormal];
    [self addSubview:_spamButton];
    
    UIView* separatorView = [UIView new];
    separatorView.translatesAutoresizingMaskIntoConstraints = NO;
    separatorView.backgroundColor = skin.cellSeparatorColor;
    [self addSubview:separatorView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_spamButton]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_spamButton)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[separatorView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_spamButton, separatorView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_spamButton][separatorView(0.5)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_spamButton, separatorView)]];
    
}

- (void)setGotSpamToday:(BOOL)gotSpamToday {

    _gotSpamToday = gotSpamToday;
    
    if (gotSpamToday) {
        
        _spamButton.enabled = YES;
        [_spamButton setTitle:@"Got spam today" forState:UIControlStateNormal];
    }
    else {
        
        _spamButton.enabled = NO;
        [_spamButton setTitle:@"No spam today" forState:UIControlStateNormal];
    }
}

@end
