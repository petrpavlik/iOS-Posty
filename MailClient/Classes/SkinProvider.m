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
    return [UIColor colorWithRed:0.878 green:0.878 blue:0.878 alpha:1];
}

- (UIColor*)navigationBarColor {
    return [UIColor colorWithRed:0.965 green:0.965 blue:0.965 alpha:1];
}

- (UIColor*)navigationBarTitleTextColor {
    return [UIColor blackColor];
}

@end
