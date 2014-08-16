//
//  QuickReplyHeaderView.h
//  MailClient
//
//  Created by Petr Pavlik on 16/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QuickReplyHeaderView;

@protocol QuickReplyHeaderViewDelegate <NSObject>

- (void)quickReplyView:(QuickReplyHeaderView*)view didRequestReplyWithText:(NSString*)text;

@end

@interface QuickReplyHeaderView : UIView

@property(nonatomic, weak) id <QuickReplyHeaderViewDelegate> delegate;

@end
