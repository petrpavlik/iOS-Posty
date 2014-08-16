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
@property(nonatomic, strong) UIView* attachmentsWrapperView;

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
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView* contentView = self.contentView;
    
    SkinProvider* skin = [SkinProvider sharedInstance];
    
    self.backgroundColor = skin.cellBackgroundColor;
    
    _headerView = [[MessageHeaderView alloc] init];
    _headerView.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:_headerView];
    
    _contentWebView = [UIWebView new];
    _contentWebView.translatesAutoresizingMaskIntoConstraints = NO;
    _contentWebView.backgroundColor = [UIColor whiteColor];
    _contentWebView.dataDetectorTypes = UIDataDetectorTypeAll;
    _contentWebView.delegate = self;
    _contentWebView.scrollView.scrollEnabled = NO;
    //_contentWebView.scrollView.minimumZoomScale = 0.1;
    //_contentWebView.scrollView.maximumZoomScale = 10;
    //_contentWebView.scalesPageToFit = YES;
    [contentView addSubview:_contentWebView];
    
    _attachmentsWrapperView = [UIView new];
    _attachmentsWrapperView.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:_attachmentsWrapperView];
    
    NSDictionary* bindings = NSDictionaryOfVariableBindings(_headerView, _contentWebView, _attachmentsWrapperView);
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_headerView]|" options:0 metrics:nil views:bindings]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_contentWebView]|" options:0 metrics:nil views:bindings]];
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_attachmentsWrapperView]|" options:0 metrics:nil views:bindings]];
    
    NSDictionary* heightMetrics = @{@"contentWebViewHeight": @44};
    _heightDefiningConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_headerView]-[_contentWebView(contentWebViewHeight@999)]-[_attachmentsWrapperView]|" options:0 metrics:heightMetrics views:bindings];
    
    [contentView addConstraints:_heightDefiningConstraints];
    
}

#pragma mark -

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    CGSize contentSize = webView.scrollView.contentSize;
    
    if (contentSize.width > 320) {
        
        webView.scalesPageToFit = YES;
        
        /*if (!webView.scalesPageToFit) {
            
            webView.scalesPageToFit = YES;
            [webView reload];
            
            return;
        }*/
        CGFloat scale = 320 / contentSize.width;
        
        contentSize.width *= scale;
        contentSize.height *= scale;
        
        //[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document. body.style.zoom = %f;", scale]];
        
        
    }
    
    CGFloat requiredHeight = contentSize.height;
    
    [self.contentView removeConstraints:_heightDefiningConstraints];
    
    NSDictionary* bindings = NSDictionaryOfVariableBindings(_headerView, _contentWebView, _attachmentsWrapperView);
    
    NSDictionary* heightMetrics = @{@"contentWebViewHeight": @(requiredHeight)};
    _heightDefiningConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_headerView]-[_contentWebView(contentWebViewHeight@999)]-[_attachmentsWrapperView]|" options:0 metrics:heightMetrics views:bindings];
    
    [self.contentView addConstraints:_heightDefiningConstraints];
    
    [self.delegate messageCellDidRequestReload:self];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ((navigationType == UIWebViewNavigationTypeOther) || (navigationType == UIWebViewNavigationTypeReload)) {
        return YES;
    }
    
    [self.delegate messageCell:self didSelectURL:request.URL];
    
    return NO;
}

- (void)setAttachmentViews:(NSArray*)attachmentViews {
    
    for (UIView* attachmentView in self.attachmentsWrapperView.subviews) {
        [attachmentView removeFromSuperview];
    }
    
    UIView* attachmentView = attachmentViews[0];
    
    [self.attachmentsWrapperView addSubview:attachmentView];
    
    [self.attachmentsWrapperView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[attachmentView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(attachmentView)]];
    
}

@end
