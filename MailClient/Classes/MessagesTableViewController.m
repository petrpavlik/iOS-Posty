//
//  MessagesTableViewController.m
//  MailClient
//
//  Created by Petr Pavlik on 20/07/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "MessagesTableViewController.h"
#import <Inbox.h>

#import "MessagePreviewTableViewCell.h"
#import "DateFormatter.h"
#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "WebViewController.h"
#import "ComposeMessageViewController.h"
#import "NavigationController.h"

#import "MessageHeaderView+InboxKit.h"
#import "UIWebView+InboxKit.h"

#import "QuickReplyHeaderView.h"

@interface MessagesTableViewController () <MessageTableViewCellDelegate>

@property(nonatomic) BOOL heightOfLatestMessageAlreadyDetected;

@end

@implementation MessagesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SkinProvider* skin = [SkinProvider sharedInstance];
    
    self.tableView.backgroundColor = skin.cellBackgroundColor;
    self.tableView.separatorColor = skin.cellSeparatorColor;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[MessagePreviewTableViewCell class] forCellReuseIdentifier:@"MessagePreviewTableViewCell"];
    [self.tableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:@"MessageTableViewCell"];
    
    QuickReplyHeaderView* headerView = [[QuickReplyHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.tableView.tableHeaderView = headerView;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[self.messageProvider items] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell...
    
    INMessage * message = [[self.messageProvider items] objectAtIndex: indexPath.row];
    
    if (indexPath.row == 0) {
        
        MessageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTableViewCell" forIndexPath:indexPath];
        
        cell.delegate = self;
        
        [cell.headerView setupWithMessage:message];
        
        [cell.contentWebView setupWithMessage:message];
        
        for (INFile* file in message.attachments) {
            
            AttachmentView* attachmentView = [[AttachmentView alloc] init];
            attachmentView.translatesAutoresizingMaskIntoConstraints = NO;
            
            attachmentView.name = @"Blah";
            
            [cell setAttachmentViews:@[attachmentView]];
            
            /*[file reload:^(BOOL success, NSError *error) {
                
                NSLog(@"%@", file);
                
                [file getDataWithCallback:^(NSError *error, NSData *data) {
                    
                    UIImage* image = [UIImage imageWithData:data];
                    NSLog(@"%@", image);
                } progress:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                    
                    //NSLog(@"progress %f%%", ((double)totalBytesRead/totalBytesExpectedToRead));
                }];
            }];*/
        }
        
        return cell;
    }
    else {
        
        MessagePreviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessagePreviewTableViewCell" forIndexPath:indexPath];
        
        cell.snippetLabel.text = message.snippet;
        
        [cell.headerView setupWithMessage:message];
        
        return cell;
    }
}

#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    INMessage * message = [[self.messageProvider items] objectAtIndex: indexPath.row];
    
    MessageViewController* controller = [[MessageViewController alloc] init];
    controller.message = message;
    
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - INModelProvider delegate

- (void)providerDataChanged:(INModelProvider*)provider
{
    [self.tableView reloadData];
}

- (void)provider:(INModelProvider*)provider dataAltered:(INModelProviderChangeSet *)changeSet
{
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:[changeSet indexPathsFor:INModelProviderChangeRemove] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView insertRowsAtIndexPaths:[changeSet indexPathsFor:INModelProviderChangeAdd] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadRowsAtIndexPaths:[changeSet indexPathsFor:INModelProviderChangeUpdate] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

- (void)provider:(INModelProvider*)provider dataFetchFailed:(NSError *)error
{
    NSLog(@"%@", error);
    
    //[[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    //[self.refreshControl endRefreshing];
    
    [self.delegate messagesTableViewController:self dataFetchDidFailWithError:error];
}

- (void)providerDataFetchCompleted:(INModelProvider*)provider
{
    //[self.refreshControl endRefreshing];
    [self.delegate messagesTableViewControllerDidCompleteDataFetch:self];
}

#pragma mark -

- (void)messageCellDidRequestReload:(MessageTableViewCell *)cell {
    
    if (self.heightOfLatestMessageAlreadyDetected) {
        return;
    }
    
    self.heightOfLatestMessageAlreadyDetected = YES;
    
    [self.tableView reloadData];
}

- (void)messageCell:(MessagesTableViewController *)cell didSelectURL:(NSURL *)url {
    
    WebViewController* controller = [[WebViewController alloc] init];
    controller.url = url;
    
    [self.navigationController  pushViewController:controller animated:YES];
}

@end
