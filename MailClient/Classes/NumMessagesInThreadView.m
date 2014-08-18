//
//  NumMessagesInThreadView.m
//  MailClient
//
//  Created by Petr Pavlik on 18/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "NumMessagesInThreadView.h"

@implementation NumMessagesInThreadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    SkinProvider* skin = [SkinProvider sharedInstance];
    
    UIFont* font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    
    UIFontDescriptor *descriptor = [[UIFontDescriptor alloc] initWithFontAttributes:@{UIFontDescriptorFamilyAttribute:font.familyName}];
    descriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    font =  [UIFont fontWithDescriptor:descriptor size:font.pointSize];
    
    _label = [[UILabel alloc] init];
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    _label.font = font;
    _label.textColor = [UIColor whiteColor];
    [self addSubview:_label];
    
    self.backgroundColor = skin.textColor;
    self.layer.cornerRadius = 2;
    self.clipsToBounds = YES;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-4-[_label]-4-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label)]];
}

@end
