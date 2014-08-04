//
//  SkinProvider.h
//  MailClient
//
//  Created by Petr Pavlik on 25/07/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SkinProvider : NSObject

+ (SkinProvider*)sharedInstance;

- (UIColor*)tintColor;
- (UIColor*)cellBackgroundColor;
- (UIColor*)cellSelectedBackgroundColor;
- (UIColor*)navigationBarColor;
- (UIColor*)navigationBarTitleTextColor;
- (UIColor*)cellSeparatorColor;
- (UIColor*)headerTextColor;
- (UIColor*)textColor;

@end
