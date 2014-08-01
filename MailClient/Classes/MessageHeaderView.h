//
//  MessageHeaderView.h
//  MailClient
//
//  Created by Petr Pavlik on 25/07/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageHeaderView : UIView

@property(nonatomic, strong) UILabel* subjectLabel;
@property(nonatomic, strong) UILabel* fromLabel;
@property(nonatomic, strong) UILabel* toLabel;

@end
