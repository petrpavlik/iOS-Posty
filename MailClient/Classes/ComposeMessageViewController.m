//
//  ComposeMessageViewController.m
//  MailClient
//
//  Created by Petr Pavlik on 22/07/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "ComposeMessageViewController.h"
#import <Inbox.h>
#import "InputTableViewCell.h"
#import "ContactsTableViewCell.h"
#import "ComposeMessageInputView.h"

@interface ComposeMessageViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITextView* bodyTextView;
@property(nonatomic, strong) UITableView* headerTableView;

@property(nonatomic) NSString* subject;
@property(nonatomic, readonly) ContactsTextView* toContactsTextView;
@property(nonatomic, readonly) ContactsTextView* ccContactsTextView;

@property(nonatomic) NSInteger heightOfContactsCell;

@property(nonatomic, strong) INDraft* draft;

@end

static inline UIViewAnimationOptions AnimationOptionsForCurve(UIViewAnimationCurve curve)
{
    return curve << 16;
}

@implementation ComposeMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSelected)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(sendSelected)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    SkinProvider* skin = [SkinProvider sharedInstance];
    
    _bodyTextView = [UITextView new];
    _bodyTextView.frame = self.view.bounds;
    _bodyTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _bodyTextView.textColor = [UIColor blackColor];
    _bodyTextView.backgroundColor = skin.cellBackgroundColor;
    _bodyTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _bodyTextView.contentInset = UIEdgeInsetsMake(132, 0, 0, 0);
    [self.view addSubview:_bodyTextView];
    
    //_bodyTextView.inputAccessoryView = [[ComposeMessageInputView alloc] initWithFrame:CGRectMake(0, 0, 320, 44) inputViewStyle:UIInputViewStyleKeyboard];
    
    _headerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -132, self.view.bounds.size.width, 132) style:UITableViewStylePlain];
    _headerTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _headerTableView.delegate = self;
    _headerTableView.dataSource = self;
    _headerTableView.scrollEnabled = NO;
    //tableView.registerClass(InputTableViewCell.classForCoder(), forCellReuseIdentifier: "InputTableViewCell")
    [_headerTableView registerClass:[InputTableViewCell class] forCellReuseIdentifier:@"InputTableViewCell"];
    [_headerTableView registerClass:[ContactsTableViewCell class] forCellReuseIdentifier:@"ContactsTableViewCell"];
    
    [_bodyTextView addSubview:_headerTableView];
    
    if (self.messageToReplyTo) {
        
        self.title = @"Reply";
    }
    else {
        self.title = @"New Email";
    }
    
    self.heightOfContactsCell = 44;
    
    NSString* htmlSignarute = @"<br/><br/>Sent with <a href=\"http://postyapp.com\">Posty for iOS</a>";
    
    NSAttributedString* signarute = [[NSAttributedString alloc] initWithData:[htmlSignarute dataUsingEncoding:NSUTF8StringEncoding]
                                     options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                               NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                          documentAttributes:nil error:nil];
    
    NSMutableAttributedString* mutableSignarure = [signarute mutableCopy];
    
    [mutableSignarure removeAttribute:NSFontAttributeName range:NSMakeRange(0, signarute.length)];
    [mutableSignarure removeAttribute:NSForegroundColorAttributeName range:NSMakeRange(0, signarute.length)];
    [mutableSignarure removeAttribute:NSParagraphStyleAttributeName range:NSMakeRange(0, signarute.length)];
    [mutableSignarure addAttribute:NSFontAttributeName value:self.bodyTextView.font range:NSMakeRange(0, mutableSignarure.length)];
    
    _bodyTextView.attributedText = mutableSignarure;
    
    
    INNamespace* namespace = [[INAPIManager shared] namespaces].firstObject;
    
    if (self.messageToReplyTo) {
        _draft = [[INDraft alloc] initInNamespace:namespace inReplyTo:_messageToReplyTo.thread];
    }
    else {
        _draft = [[INDraft alloc] initInNamespace:namespace];
    }

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.messageToReplyTo) {
        
        self.subject = [NSString stringWithFormat:@"Re: %@", self.messageToReplyTo.subject];
        
        for (NSDictionary* from in self.messageToReplyTo.from) {
            [self.toContactsTextView addEmail:from[@"email"]];
        }
        
        for (NSDictionary* from in self.messageToReplyTo.cc) {
            [self.ccContactsTextView addEmail:from[@"email"]];
        }
        
        //self.messageToReplyTo.c
        
        [self.bodyTextView becomeFirstResponder];
        self.bodyTextView.selectedRange = NSMakeRange(0, 0);
    }
    else {
        
        [self.toContactsTextView becomeFirstResponder];
    }
}

#pragma mark -

- (void)cancelSelected {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Save Draft" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self populateDraftWithContent];
        [self.draft save];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Delete Message" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)sendSelected {
    
    [self populateDraftWithContent];
    
    [_draft send];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return self.heightOfContactsCell;
    }
    else {
        return 44;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        ContactsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ContactsTableViewCell" forIndexPath:indexPath];
        
        cell.textView.prefix = @"To: ";
        
        //cell.contactsPicker.delegate = self;
        //cell.contactsPicker.datasource = self;
        
        return cell;
    }
    else if (indexPath.row == 1) {
        
        ContactsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ContactsTableViewCell" forIndexPath:indexPath];
        
        cell.textView.prefix = @"Cc: ";
        
        //cell.contactsPicker.delegate = self;
        //cell.contactsPicker.datasource = self;
        
        return cell;
    }
    else {
        
        InputTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"InputTableViewCell" forIndexPath:indexPath];
        
        cell.titleLabel.text = @"Subject:";
        cell.valueTextField.text = nil;
        
        return cell;
    }
}

#pragma mark -

- (void)setSubject:(NSString *)subject {
    
    InputTableViewCell* cell = (InputTableViewCell*)[self.headerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    cell.valueTextField.text = subject;
}

- (NSString*)subject {
    
    InputTableViewCell* cell = (InputTableViewCell*)[self.headerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    return cell.valueTextField.text;
}

- (ContactsTextView*)toContactsTextView {
    
    ContactsTableViewCell* cell = (ContactsTableViewCell*)[self.headerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    return cell.textView;
}

- (ContactsTextView*)ccContactsTextView {
    
    ContactsTableViewCell* cell = (ContactsTableViewCell*)[self.headerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    return cell.textView;
}

#pragma mark -

- (void)populateDraftWithContent {
    
    [_draft setSubject: self.subject];
    
    NSMutableAttributedString* mutableAttributedString = [self.bodyTextView.attributedText mutableCopy];
    
    NSDictionary *documentAttributes = [NSDictionary dictionaryWithObjectsAndKeys:NSHTMLTextDocumentType, NSDocumentTypeDocumentAttribute, nil];
    NSData *htmlData = [mutableAttributedString dataFromRange:NSMakeRange(0, mutableAttributedString.length) documentAttributes:documentAttributes error:nil];
    
    NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    
    //remove css
    NSInteger cssStart = [htmlString rangeOfString:@"<style type=\"text/css\">"].location;
    NSInteger cssEnd = [htmlString rangeOfString:@"</style>"].location + [htmlString rangeOfString:@"</style>"].length;
    
    htmlString = [htmlString stringByReplacingCharactersInRange:NSMakeRange(cssStart, cssEnd-cssStart) withString:@""];
    
    [_draft setBody:htmlString];
    
    NSMutableArray* recepients = [NSMutableArray new];
    for (NSString* email in self.toContactsTextView.emails) {
        [recepients addObject:@{@"email": email}];
    }
    
    [_draft setTo:recepients];
}

#pragma mark -

- (void)keyboardWillShowNotification:(NSNotification*)notification {
    
    CGRect keyboardEndFrameWindow;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrameWindow];
    CGRect keyboardEndFrameView = [self.view convertRect:keyboardEndFrameWindow fromView:nil];
    
    double keyboardTransitionDuration;
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&keyboardTransitionDuration];
    
    UIViewAnimationCurve keyboardTransitionAnimationCurve;
    [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&keyboardTransitionAnimationCurve];
    
    
    
    [UIView animateWithDuration:keyboardTransitionDuration delay:0 options:AnimationOptionsForCurve(keyboardTransitionAnimationCurve) animations:^{
        
        self.bodyTextView.contentInset = UIEdgeInsetsMake(132, 0, keyboardEndFrameView.size.height, 0);
        self.bodyTextView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, keyboardEndFrameView.size.height, 0);
        
    } completion:nil];
}

- (void)keyboardWillHideNotification:(NSNotification*)notification {
    
    
}

@end
