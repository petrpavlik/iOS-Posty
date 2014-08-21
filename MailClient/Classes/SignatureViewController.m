//
//  SignatureViewController.m
//  MailClient
//
//  Created by Petr Pavlik on 21/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "SignatureViewController.h"

@interface SignatureViewController ()

@property(nonatomic, strong) UITextView* textView;
@property(nonatomic, strong) UISegmentedControl* segmentedControl;
@property(nonatomic, strong) NSString* loadedSignature;
@property(nonatomic) BOOL loadedSignatureWasHTML;

@end

@implementation SignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.title = @"Signature";
    
    
    
    SkinProvider* skin = [SkinProvider sharedInstance];
    
    _textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _textView.textColor = [skin headerTextColor];
    [self.view addSubview:_textView];
    
    UISegmentedControl* segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Plaintext", @"HTML"]];
    _segmentedControl = segmentedControl;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    BOOL signatureIsHTML = [userDefaults boolForKey:MailSignatureIsHTMLKey];
    if (signatureIsHTML) {
        segmentedControl.selectedSegmentIndex = 1;
    }
    else {
        segmentedControl.selectedSegmentIndex = 0;
    }
    
    self.loadedSignatureWasHTML = signatureIsHTML;
    
    NSString* signature = [userDefaults stringForKey:MailSignatureKey];
    
    if (!signature) {
        signature = @"";
    }
    
    _loadedSignature = signature;
    
    _textView.text = signature;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSString* signature = _textView.text;
    
    if (!signature) {
        signature = @"";
    }
    
    BOOL isHTML = self.segmentedControl.selectedSegmentIndex==1;
    
    if (![signature isEqualToString:_loadedSignature] || self.loadedSignatureWasHTML != isHTML) {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Save changes?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:signature forKey:MailSignatureKey];
            [userDefaults setBool:isHTML forKey:MailSignatureIsHTMLKey];
            [userDefaults synchronize];
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }
}



@end
