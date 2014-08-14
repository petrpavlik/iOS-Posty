//
//  MessageTableViewCell.h
//  MailClient
//
//  Created by Petr Pavlik on 07/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageHeaderView.h"
#import "AttachmentView.h"

@class MessageTableViewCell;

@protocol MessageTableViewCellDelegate <NSObject>

- (void)messageCellDidRequestReload:(MessageTableViewCell*)cell;

- (void)messageCell:(MessageTableViewCell*)cell didSelectURL:(NSURL*)url;

@end

@interface MessageTableViewCell : UITableViewCell

@property(nonatomic, strong) MessageHeaderView* headerView;
@property(nonatomic, strong) UIWebView* contentWebView;
@property(nonatomic, strong) id <MessageTableViewCellDelegate> delegate;

- (void)setAttachmentViews:(NSArray*)attachmentViews;

@end
