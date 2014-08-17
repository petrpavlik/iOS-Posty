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
    return [UIColor colorWithRed:0.263 green:0.671 blue:0.882 alpha:1];
}

- (UIColor*)cellBackgroundColor {
    return [UIColor whiteColor];
}

- (UIColor*)cellSelectedBackgroundColor {
    return [UIColor colorWithRed:0.969 green:0.973 blue:0.976 alpha:1];
}

- (UIColor*)cellSeparatorColor {
    return self.textColor;
}

- (UIColor*)navigationBarColor {
    //return [UIColor colorWithRed:0.965 green:0.965 blue:0.965 alpha:1];
    return [UIColor whiteColor];
}

- (UIColor*)navigationBarTitleTextColor {
    return [UIColor colorWithRed:0.322 green:0.373 blue:0.404 alpha:1];
}

- (UIColor*)headerTextColor {
    return self.navigationBarTitleTextColor;
}

- (UIColor*)textColor {
    return [UIColor colorWithRed:0.584 green:0.631 blue:0.655 alpha:1];
}

@end
