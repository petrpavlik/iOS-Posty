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

@interface ComposeMessageViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITextView* bodyTextView;
@property(nonatomic, strong) UITableView* headerTableView;

@property(nonatomic) NSString* subject;
@property(nonatomic, readonly) ContactsTextView* contactsInputTextView;

@property(nonatomic) NSInteger heightOfContactsCell;

@end

@implementation ComposeMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSelected)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(sendSelected)];
    
    SkinProvider* skin = [SkinProvider sharedInstance];
    
    _bodyTextView = [UITextView new];
    _bodyTextView.frame = self.view.bounds;
    _bodyTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _bodyTextView.textColor = [UIColor blackColor];
    _bodyTextView.backgroundColor = skin.cellBackgroundColor;
    _bodyTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _bodyTextView.contentInset = UIEdgeInsetsMake(88, 0, 0, 0);
    [self.view addSubview:_bodyTextView];
    
    _headerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -88, self.view.bounds.size.width, 88) style:UITableViewStylePlain];
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
    
    _bodyTextView.attributedText = mutableSignarure;
    
    /*signarute enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, signarute.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        
        
    }*/

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.messageToReplyTo) {
        
        self.subject = [NSString stringWithFormat:@"Re: %@", self.messageToReplyTo.subject];
        
        for (NSDictionary* from in self.messageToReplyTo.from) {
            [self.contactsInputTextView addEmail:from[@"email"]];
        }
        
        [self.bodyTextView becomeFirstResponder];
        self.bodyTextView.selectedRange = NSMakeRange(0, 0);
    }
    else {
        
        [self.contactsInputTextView becomeFirstResponder];
    }
}

#pragma mark -

- (void)cancelSelected {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Save Draft" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
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
    
    INNamespace* namespace = [[INAPIManager shared] namespaces].firstObject;
 
    INDraft * draft = nil;
    
    if (self.messageToReplyTo) {
            draft = [[INDraft alloc] initInNamespace:namespace inReplyTo:_messageToReplyTo.thread];
    }
    else {
        draft = [[INDraft alloc] initInNamespace:namespace];
    }

    [draft setSubject: self.subject];
    
    NSDictionary *documentAttributes = [NSDictionary dictionaryWithObjectsAndKeys:NSHTMLTextDocumentType, NSDocumentTypeDocumentAttribute, nil];
    NSData *htmlData = [self.bodyTextView.attributedText dataFromRange:NSMakeRange(0, self.bodyTextView.attributedText.length) documentAttributes:documentAttributes error:nil];
    
    NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    
    [draft setBody:htmlString];
    
    NSMutableArray* recepients = [NSMutableArray new];
    for (NSString* email in self.contactsInputTextView.emails) {
        [recepients addObject:@{@"email": email}];
    }
    
    if (!recepients.count) {
        return;
    }
    
    [draft setTo:recepients];
    
    [draft send];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
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
    
    InputTableViewCell* cell = (InputTableViewCell*)[self.headerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    cell.valueTextField.text = subject;
}

- (NSString*)subject {
    
    InputTableViewCell* cell = (InputTableViewCell*)[self.headerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    return cell.valueTextField.text;
}

- (ContactsTextView*)contactsInputTextView {
    
    ContactsTableViewCell* cell = (ContactsTableViewCell*)[self.headerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    return cell.textView;
}


@end
