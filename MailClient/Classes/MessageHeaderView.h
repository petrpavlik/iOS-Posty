//
//  MessageHeaderView.h
//  MailClient
//
//  Created by Petr Pavlik on 25/07/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTTAttributedLabel.h>

@interface MessageHeaderView : UIView

@property(nonatomic, strong) UILabel* subjectLabel;
@property(nonatomic, strong) TTTAttributedLabel* fromLabel;
@property(nonatomic, strong) TTTAttributedLabel* toLabel;
@property(nonatomic, strong) UILabel* dateLabel;

@end
