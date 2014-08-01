//
//  MessageHeaderView.m
//  MailClient
//
//  Created by Petr Pavlik on 25/07/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "MessageHeaderView.h"

@implementation MessageHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self configure];
    }
    return self;
}

- (void)configure {
    
    self.backgroundColor = [UIColor whiteColor];
    
    _subjectLabel = [UILabel new];
    _subjectLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _subjectLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    [self addSubview:_subjectLabel];
    
    _fromLabel = [UILabel new];
    _fromLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _fromLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self addSubview:_fromLabel];
    
    _toLabel = [UILabel new];
    _toLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _toLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self addSubview:_toLabel];
    
    NSDictionary* bindings = NSDictionaryOfVariableBindings(_subjectLabel, _fromLabel, _toLabel);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_subjectLabel]-|" options:0 metrics:nil views:bindings]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_fromLabel]-|" options:0 metrics:nil views:bindings]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_toLabel]-|" options:0 metrics:nil views:bindings]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_subjectLabel][_fromLabel][_toLabel]-|" options:0 metrics:nil views:bindings]];
    
    
}

@end
