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
    
    /*_textView = [UITextView alloc] initWithCoder:<#(NSCoder *)#>
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contactsPicker]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contactsPicker)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contactsPicker]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contactsPicker)]];*/
}

@end
