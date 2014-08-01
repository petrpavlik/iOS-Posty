//
//  UnreadIndicatorView.m
//  MailClient
//
//  Created by Petr Pavlik on 19/07/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "UnreadIndicatorView.h"

@implementation UnreadIndicatorView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self configure];
    }
    return self;
}

- (void)configure {
    
    SkinProvider* skin = [SkinProvider sharedInstance];
    
    self.backgroundColor = skin.tintColor;
    self.layer.cornerRadius = self.intrinsicContentSize.width/2;
    self.clipsToBounds = YES;
}

- (CGSize)intrinsicContentSize {
    
    if (self.hidden) {
        return CGSizeZero;
    }
    else {
        return CGSizeMake(12, 12);
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    
    SkinProvider* skin = [SkinProvider sharedInstance];
    
    [super setBackgroundColor:skin.tintColor]; // prevents change of color when highlighted
}

@end
