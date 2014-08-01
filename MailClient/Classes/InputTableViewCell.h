//
//  InputTableViewCell.h
//  MailClient
//
//  Created by Petr Pavlik on 22/07/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputTableViewCell : UITableViewCell

@property(nonatomic, strong) UILabel* titleLabel;
@property(nonatomic, strong) UITextField* valueTextField;

@end
