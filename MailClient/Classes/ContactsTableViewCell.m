//
//  ContactsTableViewCell.m
//  MailClient
//
//  Created by Petr Pavlik on 02/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "ContactsTableViewCell.h"

@implementation ContactsTableViewCell

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
    
    //_textView = [[UITextView alloc] initWithFrame:CGRectZero textContainer:<#(NSTextContainer *)#>];
    _textView = [[UITextView alloc] initWithFrame:CGRectZero];
    _textView.translatesAutoresizingMaskIntoConstraints = NO;
    _textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _textView.textColor = skin.textColor;
    _textView.text = @"To: ";
    [self.contentView addSubview:_textView];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_textView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_textView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textView)]];
}

@end
