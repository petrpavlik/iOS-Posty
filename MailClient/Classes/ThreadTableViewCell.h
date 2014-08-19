//
//  ThreadTableViewCell.h
//  MailClient
//
//  Created by Petr Pavlik on 19/07/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnreadIndicatorView.h"
#import "NumMessagesInThreadView.h"

@interface ThreadTableViewCell : UITableViewCell

@property(nonatomic, strong) UILabel* subjectLabel;
@property(nonatomic, strong) UILabel* fromLabel;
@property(nonatomic, strong) UILabel* snippetLabel;
@property(nonatomic, strong) UILabel* dateLabel;
@property(nonatomic, strong) NumMessagesInThreadView* numMessagesView;
@property(nonatomic, strong) UnreadIndicatorView* unreadIndicatorView;
@property(nonatomic, strong) UIImageView* attachmentImageView;

- (void)configureWithRead:(BOOL)isRead multipleMessages:(BOOL)hasMultipleMessages attachment:(BOOL)hasAttachment;

@end
