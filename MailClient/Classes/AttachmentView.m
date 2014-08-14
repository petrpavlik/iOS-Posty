//
//  AttachmentView.m
//  MailClient
//
//  Created by Petr Pavlik on 13/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "AttachmentView.h"

@interface AttachmentView ()

@property(nonatomic, strong) UILabel* titleLabel;
@property(nonatomic, strong) UILabel* loadLabel;
@property(nonatomic, strong) UIActivityIndicatorView* loadingActivityIndicator;

@end

@implementation AttachmentView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    SkinProvider* skin = [SkinProvider sharedInstance];
    
    _titleLabel = [UILabel new];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _titleLabel.textColor = skin.headerTextColor;
    [self addSubview:_titleLabel];
    
    _loadLabel = [UILabel new];
    _loadLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _loadLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    _loadLabel.textColor = skin.tintColor;
    _loadLabel.text =  @"Load";
    [self addSubview:_loadLabel];
    
    NSDictionary* bindings = NSDictionaryOfVariableBindings(_titleLabel, _loadLabel);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_titleLabel]-[_loadLabel]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:bindings]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_titleLabel(>=44)]|" options:0 metrics:nil views:bindings]];
}

- (void)setName:(NSString *)name {
    _titleLabel.text = name;
}

- (NSString*)name {
    return _titleLabel.text;
}

@end
