//
//  NavigationController.m
//  MailClient
//
//  Created by Petr Pavlik on 19/07/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SkinProvider* skin = [SkinProvider sharedInstance];
    
    //self.navigationBar.backgroundColor = UIColor(white: 77/255.0, alpha: 1)
    self.navigationBar.barTintColor = skin.navigationBarColor;
    self.navigationBar.translucent = NO;
    self.navigationBar.barStyle = UIBarStyleDefault;
    
    //[UIColor colorWithRed:0.341 green:0.671 blue:1.000 alpha:1]
    self.view.tintColor = skin.tintColor;
}


@end
