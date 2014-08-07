//
//  MessagePreviewTableViewCell.m
//  MailClient
//
//  Created by Petr Pavlik on 07/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "MessagePreviewTableViewCell.h"

@implementation MessagePreviewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self configure];
    }
    return self;
}

- (void)configure {
    
    UIView* contentView = self.contentView;
    
    SkinProvider* skin = [SkinProvider sharedInstance];
    
    _headerView = [[MessageHeaderView alloc] init];
    _headerView.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:_headerView];
    
    _snippetLabel = [UILabel new];
    _snippetLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _snippetLabel.numberOfLines = 3;
    _snippetLabel.textColor = skin.textColor;
    [contentView addSubview:_snippetLabel];
    
    NSDictionary* bindings = NSDictionaryOfVariableBindings(_headerView, _snippetLabel);
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_headerView]|" options:0 metrics:nil views:bindings]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_snippetLabel]-|" options:0 metrics:nil views:bindings]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_headerView]-[_snippetLabel]-|" options:0 metrics:nil views:bindings]];
    
}

@end
