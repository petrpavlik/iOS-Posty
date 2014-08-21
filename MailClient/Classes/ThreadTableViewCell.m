//
//  ThreadTableViewCell.m
//  MailClient
//
//  Created by Petr Pavlik on 19/07/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "ThreadTableViewCell.h"

@interface ThreadTableViewCell ()

@property(nonatomic, strong) NSArray* constraints;

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
    
    self.layoutMargins = UIEdgeInsetsZero;
    
    self.backgroundColor = skin.cellBackgroundColor;
    
    UIView* selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    selectedBackgroundView.backgroundColor = skin.cellSelectedBackgroundColor;
    self.selectedBackgroundView = selectedBackgroundView;
    
    UIView* contentView = self.contentView;
    
    _subjectLabel = [UILabel new];
    _subjectLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _subjectLabel.numberOfLines = 1;
    _subjectLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    _subjectLabel.textColor = skin.headerTextColor;
    [contentView addSubview:_subjectLabel];
    
    _fromLabel = [UILabel new];
    _fromLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _fromLabel.numberOfLines = 1;
    _fromLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    _fromLabel.textColor = skin.headerTextColor;
    [_fromLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [_fromLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [contentView addSubview:_fromLabel];
    
    _dateLabel = [UILabel new];
    _dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _dateLabel.numberOfLines = 1;
    _dateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    _dateLabel.textColor = skin.textColor;
    [_dateLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [contentView addSubview:_dateLabel];
    
    _snippetLabel = [UILabel new];
    _snippetLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _snippetLabel.numberOfLines = 2;
    _snippetLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    _snippetLabel.textColor = skin.textColor;
    [contentView addSubview:_snippetLabel];
    
    _unreadIndicatorView = [[UnreadIndicatorView alloc] initWithFrame:CGRectZero];
    _unreadIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [_unreadIndicatorView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [contentView addSubview:_unreadIndicatorView];
    
    _numMessagesView = [NumMessagesInThreadView new];
    _numMessagesView.translatesAutoresizingMaskIntoConstraints = NO;
    [_numMessagesView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [contentView addSubview:_numMessagesView];
    
    _attachmentImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"icn-attachment"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    _attachmentImageView.tintColor = skin.headerTextColor;
    _attachmentImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [_attachmentImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_attachmentImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [contentView addSubview:_attachmentImageView];
    
    NSDictionary* bindings = NSDictionaryOfVariableBindings(_subjectLabel, _fromLabel, _dateLabel, _snippetLabel, _unreadIndicatorView, _numMessagesView, _attachmentImageView);
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_snippetLabel(288)]" options:0 metrics:nil views:bindings]];
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[_fromLabel]-2-[_subjectLabel]-1-[_snippetLabel]-7-|" options:0 metrics:nil views:bindings]];
}

- (void)configureWithRead:(BOOL)isRead multipleMessages:(BOOL)hasMultipleMessages attachment:(BOOL)hasAttachment {
    
    if (self.constraints) {
        [self.contentView removeConstraints:self.constraints];
    }
    
    self.unreadIndicatorView.hidden = isRead;
    self.numMessagesView.hidden = !hasMultipleMessages;
    self.attachmentImageView.hidden = !hasAttachment;
    
    NSMutableArray* constraints = [NSMutableArray new];
    
    NSString* constraintTemplate = @"|-{0}[_fromLabel]-[_dateLabel]{1}-|";
    
    if (isRead) {
        constraintTemplate = [constraintTemplate stringByReplacingOccurrencesOfString:@"{0}" withString:@""];
    }
    else {
        constraintTemplate = [constraintTemplate stringByReplacingOccurrencesOfString:@"{0}" withString:@"[_unreadIndicatorView]-5-"];
    }
    
    if (hasMultipleMessages) {
        constraintTemplate = [constraintTemplate stringByReplacingOccurrencesOfString:@"{1}" withString:@"-6-[_numMessagesView]"];
    }
    else {
        constraintTemplate = [constraintTemplate stringByReplacingOccurrencesOfString:@"{1}" withString:@""];
    }
    
    NSDictionary* bindings = NSDictionaryOfVariableBindings(_subjectLabel, _fromLabel, _dateLabel, _snippetLabel, _unreadIndicatorView, _numMessagesView, _attachmentImageView);
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:constraintTemplate options:NSLayoutFormatAlignAllCenterY metrics:nil views:bindings]];
    
    if (hasAttachment) {
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_attachmentImageView]-4-[_subjectLabel]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:bindings]];
    }
    else {
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_subjectLabel]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:bindings]];
    }
    
    [self.contentView addConstraints:constraints];
    
    self.constraints = constraints;
}

@end
