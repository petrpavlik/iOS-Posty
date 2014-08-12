//
//  ThreadTableViewCell.m
//  MailClient
//
//  Created by Petr Pavlik on 19/07/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "ThreadTableViewCell.h"

@interface ThreadTableViewCell ()

@property(nonatomic, strong) NSArray* unreadStateConstraints;
@property(nonatomic, strong) NSArray* readStateConstraints;

@end

@implementation ThreadTableViewCell

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
    
    self.backgroundColor = skin.cellBackgroundColor;
    
    UIView* selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    selectedBackgroundView.backgroundColor = skin.cellSelectedBackgroundColor;
    self.selectedBackgroundView = selectedBackgroundView;
    
    UIView* contentView = self.contentView;
    
    _subjectLabel = [UILabel new];
    _subjectLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _subjectLabel.numberOfLines = 1;
    _subjectLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _subjectLabel.textColor = skin.headerTextColor;
    [contentView addSubview:_subjectLabel];
    
    _fromLabel = [UILabel new];
    _fromLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _fromLabel.numberOfLines = 1;
    _fromLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    _fromLabel.textColor = skin.headerTextColor;
    [contentView addSubview:_fromLabel];
    
    _dateLabel = [UILabel new];
    _dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _dateLabel.numberOfLines = 1;
    _dateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    _dateLabel.textColor = skin.textColor;
    [contentView addSubview:_dateLabel];
    
    _snippetLabel = [UILabel new];
    _snippetLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _snippetLabel.numberOfLines = 2;
    _snippetLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _snippetLabel.textColor = skin.textColor;
    [contentView addSubview:_snippetLabel];
    
    _unreadIndicatorView = [[UnreadIndicatorView alloc] initWithFrame:CGRectZero];
    _unreadIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [_unreadIndicatorView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [contentView addSubview:_unreadIndicatorView];
    
    NSDictionary* bindings = NSDictionaryOfVariableBindings(_subjectLabel, _fromLabel, _dateLabel, _snippetLabel, _unreadIndicatorView);
    
    self.unreadStateConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-[_unreadIndicatorView]-5-[_fromLabel]-[_dateLabel]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:bindings];
    
    self.readStateConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-[_fromLabel]-[_dateLabel]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:bindings];
    
    [contentView addConstraints:_unreadStateConstraints];
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_subjectLabel]-|" options:0 metrics:nil views:bindings]];
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_snippetLabel(288)]" options:0 metrics:nil views:bindings]];
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[_fromLabel][_subjectLabel][_snippetLabel]-7-|" options:0 metrics:nil views:bindings]];
}

- (void)setReadState {
    
    [self.contentView removeConstraints:_unreadStateConstraints];
    [self.contentView removeConstraints:_readStateConstraints];
    
    [self.contentView addConstraints:_readStateConstraints];
}

- (void)setUnreadState {
    
    [self.contentView removeConstraints:_unreadStateConstraints];
    [self.contentView removeConstraints:_readStateConstraints];
    
    [self.contentView addConstraints:_unreadStateConstraints];
}

@end
