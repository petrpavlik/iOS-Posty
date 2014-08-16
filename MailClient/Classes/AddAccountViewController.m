//
//  AddAccountViewController.m
//  MailClient
//
//  Created by Petr Pavlik on 14/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "AddAccountViewController.h"
#import <Inbox.h>
#import "ThreadsTableViewController.h"
#import "NavigationController.h"

@interface AddAccountViewController ()

@property(nonatomic, strong) UIView* contentScrollView;
@property(nonatomic, strong) UILabel* addAccountLabel;
@property(nonatomic, strong) UITextField* accountTextField;
@property(nonatomic, strong) UIButton* submitButton;

@end

@implementation AddAccountViewController

- (void)loadView {
    [super loadView];
    
    SkinProvider* skin = [SkinProvider sharedInstance];
    
    self.view.tintColor = skin.tintColor;
    
    _contentScrollView = [[UIView alloc] initWithFrame:self.view.bounds];
    _contentScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_contentScrollView];
    
    _addAccountLabel = [[UILabel alloc] init];
    _addAccountLabel.textColor = skin.headerTextColor;
    _addAccountLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    _addAccountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _addAccountLabel.numberOfLines = 0;
    _addAccountLabel.text = @"Add an Account";
    _addAccountLabel.textAlignment = NSTextAlignmentCenter;
    _addAccountLabel.textColor = skin.headerTextColor;
    [_contentScrollView addSubview:_addAccountLabel];
    
    _accountTextField = [[UITextField alloc] init];
    _accountTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _accountTextField.placeholder = @"Your email";
    [_accountTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _accountTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _accountTextField.returnKeyType = UIReturnKeyDone;
    [_accountTextField becomeFirstResponder];
    _accountTextField.textAlignment = NSTextAlignmentCenter;
    _accountTextField.textColor = skin.headerTextColor;
    _accountTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    [_contentScrollView addSubview:_accountTextField];
    
    _submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _submitButton.translatesAutoresizingMaskIntoConstraints = NO;
    _submitButton.hidden = YES;
    [_submitButton setTitle:@"Add Account" forState:UIControlStateNormal];
    [_submitButton addTarget:self action:@selector(submitButtonSelected) forControlEvents:UIControlEventTouchUpInside];
    [_contentScrollView addSubview:_submitButton];
    
    NSDictionary* bindigs = NSDictionaryOfVariableBindings(_addAccountLabel, _accountTextField, _submitButton);
    
    [_contentScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_addAccountLabel]-|" options:0 metrics:nil views:bindigs]];
    [_contentScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_accountTextField]-|" options:0 metrics:nil views:bindigs]];
    [_contentScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_submitButton]-|" options:0 metrics:nil views:bindigs]];
    [_contentScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_addAccountLabel(>=44)]-44-[_accountTextField(>=44)]-[_submitButton(>=44)]->=0-|" options:0 metrics:nil views:bindigs]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([INAPIManager shared].isAuthenticated) {
        
        [self displayThreadsAnimated:NO];
    }
}

#pragma mark -

- (void)textFieldDidChange:(UITextField*)textField {
    
    _submitButton.hidden = ![self NSStringIsValidEmail:textField.text];
}

- (void)submitButtonSelected {
    
    NSString * email = @"pavlipe7@gmail.com";
    [[INAPIManager shared] authenticateWithEmail:email andCompletionBlock:^(BOOL success, NSError *error) {
        
        if (error) {
            
            [[[UIAlertView alloc] initWithTitle:@"Oh Fuck!" message:error.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
        else {
            
            [self displayThreadsAnimated:YES];
        }
    }];
}

#pragma mark -

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

#pragma mark -

- (void)displayThreadsAnimated:(BOOL)animated {
    
    ThreadsTableViewController* controller = [[ThreadsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController* navController = [[NavigationController alloc] initWithRootViewController:controller];
    navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:navController animated:animated completion:nil];
    
}


@end
