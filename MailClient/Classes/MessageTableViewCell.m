//
//  MessageTableViewCell.m
//  MailClient
//
//  Created by Petr Pavlik on 07/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "MessageTableViewCell.h"

@interface MessageTableViewCell () <UIWebViewDelegate>

@property(nonatomic, strong) NSArray* heightDefiningConstraints;

@end

@implementation MessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self configure];
    }
    return self;
}

- (void)configure {
    
    UIView* contentView = self.contentView;
    
    SkinProvider* skin = [SkinProvider sharedInstance];
    
    _headerView = [[MessageHeaderView alloc] init];
    _headerView.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:_headerView];
    
    _contentWebView = [UIWebView new];
    _contentWebView.backgroundColor = [UIColor whiteColor];
    _contentWebView.dataDetectorTypes = UIDataDetectorTypeAll;
    _contentWebView.delegate = self;
    [contentView addSubview:_contentWebView];
    
    NSDictionary* bindings = NSDictionaryOfVariableBindings(_headerView, _contentWebView);
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_headerView]|" options:0 metrics:nil views:bindings]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_contentWebView]|" options:0 metrics:nil views:bindings]];
    
    NSDictionary* heightMetrics = @{@"contentWebViewHeight": @44};
    _heightDefiningConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_headerView]-[_contentWebView(contentWebViewHeight)]-|" options:0 metrics:heightMetrics views:bindings];
    
    [contentView addConstraints:_heightDefiningConstraints];
    
}

@end
