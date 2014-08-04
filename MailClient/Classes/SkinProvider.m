//
//  SkinProvider.m
//  MailClient
//
//  Created by Petr Pavlik on 25/07/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "SkinProvider.h"

@implementation SkinProvider

+ (SkinProvider*)sharedInstance {
    
    static SkinProvider* skinProvider = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        skinProvider = [SkinProvider new];
    });
    
    return skinProvider;
}

- (UIColor*)tintColor {
    return [UIColor colorWithRed:0.329 green:0.604 blue:0.988 alpha:1];
}

- (UIColor*)cellBackgroundColor {
    return [UIColor whiteColor];
}

- (UIColor*)cellSelectedBackgroundColor {
    return [UIColor colorWithRed:0.004 green:0.361 blue:0.863 alpha:1];
}

- (UIColor*)cellSeparatorColor {
    return self.textColor;
}

- (UIColor*)navigationBarColor {
    //return [UIColor colorWithRed:0.965 green:0.965 blue:0.965 alpha:1];
    return [UIColor whiteColor];
}

- (UIColor*)navigationBarTitleTextColor {
    return [UIColor colorWithRed:71/255.0 green:82/255.0 blue:93/255.0 alpha:1];
}

- (UIColor*)headerTextColor {
    return self.navigationBarTitleTextColor;
}

- (UIColor*)textColor {
    return [UIColor colorWithRed:103/255.0 green:114/255.0 blue:119/255.0 alpha:1];
}

@end
