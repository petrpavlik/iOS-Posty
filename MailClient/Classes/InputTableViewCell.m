//
//  InputTableViewCell.m
//  MailClient
//
//  Created by Petr Pavlik on 22/07/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "InputTableViewCell.h"

@implementation InputTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self configure];
    }
    return self;
}

- (void)configure {
    
    SkinProvider* skin = [SkinProvider sharedInstance];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = skin.cellBackgroundColor;
    
    UIView* contentView = self.contentView;
    
    _titleLabel = [UILabel new];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.numberOfLines = 1;
    [_titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [contentView addSubview:_titleLabel];
    
    _valueTextField = [UITextField new];
    _valueTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _valueTextField.textColor = [UIColor blackColor];
    [contentView addSubview:_valueTextField];
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_titleLabel]-[_valueTextField]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel, _valueTextField)]];
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_titleLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel, _valueTextField)]];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        [_valueTextField becomeFirstResponder];
    }
}

@end
