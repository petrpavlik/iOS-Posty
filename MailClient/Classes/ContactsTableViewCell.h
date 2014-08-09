//
//  ContactsTableViewCell.h
//  MailClient
//
//  Created by Petr Pavlik on 02/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsTextView.h"

@interface ContactsTableViewCell : UITableViewCell

@property(nonatomic, strong) ContactsTextView* textView;

@end
