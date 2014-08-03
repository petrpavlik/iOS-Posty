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
    
    UIFont* headlineFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
    _subjectLabel = [UILabel new];
    _subjectLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _subjectLabel.font = [headlineFont fontWithSize:headlineFont.pointSize*1.2];
    _subjectLabel.numberOfLines = 0; //TODO: allow multiline
    [self addSubview:_subjectLabel];
    
    _fromLabel = [TTTAttributedLabel new];
    _fromLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _fromLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _fromLabel.textColor = [UIColor colorWithRed:0.557 green:0.557 blue:0.576 alpha:1];
    _fromLabel.linkAttributes = @{NSForegroundColorAttributeName: self.tintColor};
    
    
    [self addSubview:_fromLabel];
    
    _toLabel = [TTTAttributedLabel new];
    _toLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _toLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    _toLabel.textColor = [UIColor colorWithRed:0.557 green:0.557 blue:0.576 alpha:1];
    _toLabel.linkAttributes = @{NSForegroundColorAttributeName: self.tintColor};
    [self addSubview:_toLabel];
    
    _dateLabel = [UILabel new];
    _dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _dateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    _dateLabel.numberOfLines = 0;
    _dateLabel.textColor = [UIColor colorWithRed:0.557 green:0.557 blue:0.576 alpha:1];
    [self addSubview:_dateLabel];
    
    UIView* separator = [UIView new];
    separator.translatesAutoresizingMaskIntoConstraints = NO;
    separator.backgroundColor = [UIColor colorWithRed:0.557 green:0.557 blue:0.576 alpha:1];;
    [self addSubview:separator];
    
    NSDictionary* bindings = NSDictionaryOfVariableBindings(_subjectLabel, _fromLabel, _toLabel, _dateLabel, separator);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_subjectLabel]-|" options:0 metrics:nil views:bindings]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_fromLabel]-|" options:0 metrics:nil views:bindings]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_toLabel]-|" options:0 metrics:nil views:bindings]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_dateLabel]-|" options:0 metrics:nil views:bindings]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[separator]|" options:0 metrics:nil views:bindings]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_fromLabel][_toLabel]-8-[separator(0.5)]-10-[_subjectLabel][_dateLabel]" options:0 metrics:nil views:bindings]];
    
    
}

@end
