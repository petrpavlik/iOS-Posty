//
//  MessageTableViewCell.h
//  MailClient
//
//  Created by Petr Pavlik on 07/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageHeaderView.h"

@interface MessageTableViewCell : UITableViewCell

@property(nonatomic, strong) MessageHeaderView* headerView;
@property(nonatomic, strong) UIWebView* contentWebView;

@end
